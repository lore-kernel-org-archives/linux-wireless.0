Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab3LPLJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Dec 2013 06:09:27 -0500
Message-ID: <1387192164.4665.11.camel@jlt4.sipsolutions.net> (sfid-20131216_120930_726413_199E8FE1)
Subject: Re: [RFC] mac80211: implement HS2.0 gratuitous ARP/unsolicited NA
 dropping
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"j@w1.fi" <j@w1.fi>
Date: Mon, 16 Dec 2013 12:09:24 +0100
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F532572E0@SC-VEXCH1.marvell.com>
References: <1386010602-3916-1-git-send-email-johannes@sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F70430F532572E0@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> > diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
> > index 5c85d78..1887629 100644
> > --- a/drivers/net/wireless/mwifiex/decl.h
> > +++ b/drivers/net/wireless/mwifiex/decl.h
> > @@ -153,12 +153,4 @@ struct mwifiex_types_wmm_info {
> >  	u8 reserved;
> >  	struct ieee_types_wmm_ac_parameters ac_params[IEEE80211_NUM_ACS];
> >  } __packed;
> > -
> > -struct mwifiex_arp_eth_header {
> > -	struct arphdr hdr;
> > -	u8 ar_sha[ETH_ALEN];
> > -	u8 ar_sip[4];
> > -	u8 ar_tha[ETH_ALEN];
> > -	u8 ar_tip[4];
> > -} __packed;
> 
> "#include <uapi/linux/if_arp.h" in this file can be removed too.

Indeed, good catch. I'll roll this into my patch, but due to
holidays/vacation I won't actually work on it until January or so.

johannes

