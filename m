Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kanga.kvack.org ([66.96.29.28]:38327 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbYDADM3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 23:12:29 -0400
Date: Tue, 1 Apr 2008 00:15:30 -0300
From: Marcelo Tosatti <marcelo@kvack.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Holger Schurig <hs4233@mail.mn-solutions.de>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	libertas-dev@lists.infradead.org
Subject: Re: [PATCH, take 3] libertas: convert RSSI to a direct command
Message-ID: <20080401031530.GA14633@dmt> (sfid-20080401_041235_449162_9A93B070)
References: <200803261021.48470.hs4233@mail.mn-solutions.de> <1206653042.21106.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1206653042.21106.10.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 27, 2008 at 05:24:02PM -0400, Dan Williams wrote:
> On Wed, 2008-03-26 at 10:21 +0100, Holger Schurig wrote:
> > Besided the direct conversion of the CMD_802_11_RSSI command, this
> > patch also changes the following things:
> > 
> > * calls CMD_802_11_RSSI either asynchronosly (in the background)
> >   when main.c thinks the firmware is hosed and just want's to
> >   get a command through
> > * calls CMD_802_11_RSSI synchronously when called to get wireless
> >   statistics.
> > * don't do in-driver averaging anymore, this and the previous point
> >   eliminates the need for any "struct lbs_private" values
> > * use a 100% quality in a  special ADHOC case
> > 
> > Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> 
> Acked-by: Dan Williams <dcbw@redhat.com>
> 
> > Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
> > ===================================================================
> > --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-26 09:18:24.000000000 +0100
> > +++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-26 09:18:31.000000000 +0100
> > @@ -692,6 +692,44 @@ static int lbs_cmd_802_11_rate_adapt_rat
> >  	return 0;
> >  }
> >  
> > +int lbs_get_rssi(struct lbs_private *priv, u16 *snr, u16 *nf)
> > +{
> > +	struct cmd_ds_802_11_rssi cmd;
> > +	struct cmd_ds_802_11_rssi_rsp rsp;
> > +	int ret;
> > +	u16 _snr, _nf;
> > +
> > +	lbs_deb_enter(LBS_DEB_CMD);
> > +
> > +	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
> > +	cmd.avg_factor = cpu_to_le16(1);
> > +	rsp.hdr.size = cpu_to_le16(sizeof(rsp));
> > +
> > +	/* main.c might have called us just to un-break a hanging firmware */
> > +	if (!snr && !nf) {
> > +		lbs_cmd_async(priv, CMD_802_11_RSSI, &cmd.hdr, sizeof(cmd));
> > +		return 0;
> > +	}
> > +
> > +	ret = lbs_cmd(priv, CMD_802_11_RSSI,
> > +		&cmd, lbs_cmd_copyback, (unsigned long) &rsp);

Won't this call block? You can't block in the get_wireless handler (it
holds the rtnl lock). See wext_handle_ioctl.
