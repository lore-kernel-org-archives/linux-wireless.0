Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:10563 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752188AbaE1NPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 09:15:47 -0400
Date: Wed, 28 May 2014 09:08:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luca Coelho <luca@coelho.fi>, linux-wireless@vger.kernel.org,
	michal.kazior@tieto.com
Subject: Re: [RFC] trace-cmd: plugin_mac80211: add parsing for the new
 drv_switch_vif_chanctx
Message-ID: <20140528090837.2b868d22@gandalf.local.home> (sfid-20140528_151551_266620_871C5B06)
In-Reply-To: <1401088941.19055.0.camel@jlt4.sipsolutions.net>
References: <1400873435-9687-1-git-send-email-luca@coelho.fi>
	<1401088941.19055.0.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 26 May 2014 09:22:21 +0200
Johannes Berg <johannes@sipsolutions.net> wrote:

> Steven, what do you think about those packed structs in a dynamic
> array? I've applied the kernel patch but I can still back it out if you
> know of a better solution.

I consider you more of the maintainer of the mac80211 plugin, so I'll
leave that decision up to you ;-)

> 
> Thanks,
> johannes
> 
> On Fri, 2014-05-23 at 22:30 +0300, Luca Coelho wrote:
> > From: Luciano Coelho <luciano.coelho@intel.com>
> > 
> > This new command has a complex trace, with a variable number of struct
> > elements in an array and needs special parsing.  Add a parsing
> > function to handle it.
> > 
> > Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
> > ---
> >  I'm sending this to linux-wireless as an RFC before sending it to
> > Steven to get some comments and because the new function hasn't yet
> > gotten to linux-wireless/mainline.
> > 
> >  plugin_mac80211.c | 93 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 93 insertions(+)
> > 
> > diff --git a/plugin_mac80211.c b/plugin_mac80211.c
> > index f35cb80..0b4835e 100644
> > --- a/plugin_mac80211.c
> > +++ b/plugin_mac80211.c
> > @@ -191,12 +191,105 @@ static int drv_config(struct trace_seq *s, struct pevent_record *record,
> >  	return 0;
> >  }
> >  
> > +struct trace_vif_entry {
> > +	int vif_type;
> 
> This in particular was an enum upstream - which technically doesn't n

Looks like you got distracted and didn't finish your thought.

-- Steve

> 
> > +	bool p2p;
> > +	char vif_name[8];
> > +} __attribute__((packed));
> > +
> > +struct trace_chandef_entry {
> > +	unsigned int control_freq;
> > +	unsigned int chan_width;
> > +	unsigned int center_freq1;
> > +	unsigned int center_freq2;
> > +} __attribute__((packed));
> > +
> > +struct trace_switch_entry {
> > +	struct trace_vif_entry vif;
> > +	struct trace_chandef_entry old_chandef;
> > +	struct trace_chandef_entry new_chandef;
> > +} __attribute__((packed));
> > +
> > +static int drv_switch_vif_chanctx(struct trace_seq *s,
> > +				  struct pevent_record *record,
> > +				  struct event_format *event, void *context)
> > +{
> > +	struct format_field *f = pevent_find_field(event, "n_vifs");
> > +	unsigned int i, offset, len;
> > +	long long unsigned int n_vifs;
> > +	void *data = record->data;
> > +	struct trace_switch_entry *vifs;
> > +
> > +	if (!f) {
> > +		trace_seq_printf(s, "NOTFOUND: n_vifs");
> > +		return 0;
> > +	}
> > +
> > +	if (pevent_read_number_field(f, data, &n_vifs)) {
> > +		trace_seq_puts(s, "field-invalid: n_vifs");
> > +		return 0;
> > +	}
> > +
> > +	f = pevent_find_field(event, "vifs");
> > +
> > +	if (!f) {
> > +		trace_seq_printf(s, "NOTFOUND: vifs");
> > +		return 0;
> > +	}
> > +
> > +	offset = f->offset;
> > +	len = f->size;
> > +	if (f->flags & FIELD_IS_DYNAMIC) {
> > +		long long unsigned int val;
> > +
> > +		val = pevent_read_number(event->pevent, data + offset, len);
> > +		offset = val;
> > +		len = offset >> 16;
> > +		offset &= 0xffff;
> > +	}
> > +
> > +	if (len != sizeof(*vifs) * n_vifs) {
> > +		trace_seq_printf(s, "field-invalid: vifs");
> > +		return 0;
> > +	}
> > +
> > +	print_string(s, event, "wiphy_name", data);
> > +	pevent_print_num_field(s, " n_vifs:%d ", event, "n_vifs", record, 1);
> > +	print_enum(s, event, "mode", data,
> > +		   { 0, "REASSIGN_VIF" },
> > +		   { 1, "SWAP_CONTEXTS"} );
> > +
> > +	vifs = (void *) (char *) data + offset;
> > +
> > +	for (i = 0; i < n_vifs; i++) {
> > +		trace_seq_printf(s, "\n%*s\t", INDENT, "");
> > +		trace_seq_printf(s, "vif %d:\tname: %s type: %d p2p: %d",
> > +				 i, vifs[i].vif.vif_name, vifs[i].vif.vif_type,
> > +				 vifs[i].vif.p2p);
> > +		trace_seq_printf(s, "\n%*s\t\t", INDENT, "");
> > +		trace_seq_printf(s, "old_ctx: control_freq: %d chan_width: %d center_freq1: %d center_freq2: %d",
> > +				 vifs[i].old_chandef.control_freq,
> > +				 vifs[i].old_chandef.chan_width,
> > +				 vifs[i].old_chandef.center_freq1,
> > +				 vifs[i].old_chandef.center_freq2);
> > +		trace_seq_printf(s, "\n%*s\t\t", INDENT, "");
> > +		trace_seq_printf(s, "new_ctx: control_freq: %d chan_width: %d center_freq1: %d center_freq2: %d",
> > +				 vifs[i].new_chandef.control_freq,
> > +				 vifs[i].new_chandef.chan_width,
> > +				 vifs[i].new_chandef.center_freq1,
> > +				 vifs[i].new_chandef.center_freq2);
> > +	}
> > +
> > +	return 0;
> > +}
> >  int PEVENT_PLUGIN_LOADER(struct pevent *pevent)
> >  {
> >  	pevent_register_event_handler(pevent, -1, "mac80211", "drv_bss_info_changed",
> >  				      drv_bss_info_changed, NULL);
> >  	pevent_register_event_handler(pevent, -1, "mac80211", "drv_config",
> >  				      drv_config, NULL);
> > +	pevent_register_event_handler(pevent, -1, "mac80211", "drv_switch_vif_chanctx",
> > +				      drv_switch_vif_chanctx, NULL);
> >  
> >  	return 0;
> >  }
> 
> 

