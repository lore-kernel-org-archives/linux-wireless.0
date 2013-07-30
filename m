Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38336 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754613Ab3G3TOF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jul 2013 15:14:05 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Eliad Peller <eliad@wizery.com>,
	Johannes Berg <johannes@sipsolutions.net>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] mac80211: implement critical protocol protection
Date: Tue, 30 Jul 2013 19:14:00 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301A1F285@HASMSX103.ger.corp.intel.com> (sfid-20130730_211419_897841_CF24538C)
References: <1374826090-17322-1-git-send-email-johannes@sipsolutions.net>
 <CAB3XZEfy_ts00HnEgaLYQqzMhLR2KbZsn1KVH6eOMYUiTSjD-g@mail.gmail.com>
In-Reply-To: <CAB3XZEfy_ts00HnEgaLYQqzMhLR2KbZsn1KVH6eOMYUiTSjD-g@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On Fri, Jul 26, 2013 at 11:08 AM, Johannes Berg <johannes@sipsolutions.net>
> wrote:
> > From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> >
> > This new API add in cfg80211 wasn't implemented in mac80211.
> > Advertise the capabilities based on the device's implementation
> > (possibly NULL) of crit_prot mac80211 ops.
> >
> > This callback will be called by cfg80211 when hinted by userspace that
> > a critical protocol is happening, e.g. it can be EAPOL, DHCP.
> >
> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> > ---
> 
> > +static void ieee80211_crit_prot_timeout(struct work_struct *wk) {
> > +       struct ieee80211_sub_if_data *sdata;
> > +
> > +       sdata = container_of(wk, struct ieee80211_sub_if_data,
> > +                            crit_prot_end_wk.work);
> > +
> > +       drv_crit_proto(sdata->local, sdata, NL80211_CRIT_PROTO_UNSPEC,
> > +false); }
> > +
> 
> i think you should call cfg80211_crit_proto_stopped()?
> and even better, maybe provide some callback to let/require the driver
> indicate completion (and implicitly call cfg80211_crit_proto_stopped() there).

Oops, your're right.
Otherwise I won't be able to issue another crit_prot_session since start reads:

	if (rdev->crit_proto_nlportid)
		return -EBUSY;

The API is just a bit funny: there is a duration, but I am still supposed to call stop when I am done?
If so, why not put the timer internally in cfg80211?
