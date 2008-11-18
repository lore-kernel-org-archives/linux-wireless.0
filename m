Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:8200 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752473AbYKRTeR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Nov 2008 14:34:17 -0500
Subject: Re: [PATCH] Re: Problem with Kernel Oops in ipw2200
From: reinette chatre <reinette.chatre@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Frank Seidel <fseidel@suse.de>, "Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	"ipw2100-devel@lists.sourceforge.net"
	<ipw2100-devel@lists.sourceforge.net>,
	"hschaa@suse.de" <hschaa@suse.de>
In-Reply-To: <20081118192321.GC21772@tuxdriver.com>
References: <49130E75.1000903@suse.de> <49131173.3010409@suse.de>
	 <20081112213350.GJ2411@tuxdriver.com> <491BF062.4050705@suse.de>
	 <1226631539.2604.411.camel@debian.sh.intel.com> <49214BF3.8050306@suse.de>
	 <20081118192321.GC21772@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 11:34:59 -0800
Message-Id: <1227036899.31385.53.camel@rc-desk> (sfid-20081118_203421_586363_60FD48A4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-11-18 at 11:23 -0800, John W. Linville wrote:
> On Mon, Nov 17, 2008 at 11:48:19AM +0100, Frank Seidel wrote:
> > From: Zhu Yi <yi.zhu@intel.com>
> > 
> > Fixes Oops in ipw2200:ipw_tx_skb when pinging through
> > a WPA enterprise connection.
> > 
> > Signed-off-by: Zhu Yi <yi.zhu@intel.com>
> > Tested-by: Frank Seidel <fseidel@suse.de>
> > Signed-off-by: Ffrank Seidel <fseidel@suse.de>
> > 
> > ---
> >  drivers/net/wireless/ipw2200.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > --- a/drivers/net/wireless/ipw2200.c
> > +++ b/drivers/net/wireless/ipw2200.c
> > @@ -10190,6 +10190,11 @@ static int ipw_tx_skb(struct ipw_priv *p
> >  	u16 remaining_bytes;
> >  	int fc;
> >  
> > +	if (!(priv->status & STATUS_ASSOCIATED)) {
> > +		IPW_DEBUG_TX("Tx attempt while not associated.\n");
> > +		goto drop;
> > +	}
> > +
> >  	hdr_len = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_ctl));
> >  	switch (priv->ieee->iw_mode) {
> >  	case IW_MODE_ADHOC:
> > 
> 
> Well, I'm sorry to be a PITA...but the changelog doesn't really
> explain how the patch works or what it is doing.  Also, this still
> seems to me more like a band-aid than a real fix...?

John,

The commit message could be changed to:

"This patch fixes the ipw2200 kernel oops caused by sending frames
while not in associated state."

Will this be sufficient?

Reinette

