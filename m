Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48287 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab2ACJgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 04:36:04 -0500
Date: Tue, 3 Jan 2012 15:05:34 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 3/3] ath6kl: Remove few deadcode in main.c
Message-ID: <20120103093532.GA17369@chvasanth-lnx> (sfid-20120103_103609_740361_5DC5B704)
References: <1325154939-6986-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1325154939-6986-3-git-send-email-vthiagar@qca.qualcomm.com>
 <4F01DC4B.50501@qca.qualcomm.com>
 <20120103054000.GB16733@chvasanth-lnx>
 <1325578370.3905.3.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1325578370.3905.3.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 03, 2012 at 09:12:50AM +0100, Johannes Berg wrote:
> On Tue, 2012-01-03 at 11:10 +0530, Vasanthakumar Thiagarajan wrote:
> 
> > > > @@ -62,8 +62,7 @@ static void ath6kl_add_new_sta(struct ath6kl *ar, u8 *mac, u16 aid, u8 *wpaie,
> > > >  
> > > >  	sta = &ar->sta_list[free_slot];
> > > >  	memcpy(sta->mac, mac, ETH_ALEN);
> > > > -	if (ielen <= ATH6KL_MAX_IE)
> > > > -		memcpy(sta->wpa_ie, wpaie, ielen);
> > > > +	memcpy(sta->wpa_ie, wpaie, ielen);
> > 
> > > 
> > > And then someone changes the u8 ielen to something else and accidentally
> > > adds a bug. I would prefer to have an explicit check for the ielen to
> > > make it obvious what's the maximum length.
> > > 
> > > I don't really like using u8 for ielen either. IMHO size_t or similar
> > > would be better.
> > 
> > The length of any IE is 1 byte, u8 is the appropriate one.
> 
> No -- this can contain multiple IEs.

Right, it can, but as of now this is any one these ies, wpa, wapi, wpa/wpa2.
Ok, i don't see any disadvantage in converting this u8 to size_t,
i'll send the next version.

Vasanth
