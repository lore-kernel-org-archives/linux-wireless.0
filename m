Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57972 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987Ab2ACIMx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 03:12:53 -0500
Subject: Re: [PATCH 3/3] ath6kl: Remove few deadcode in main.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath6kl-devel@qualcomm.com
In-Reply-To: <20120103054000.GB16733@chvasanth-lnx> (sfid-20120103_064051_183446_5E9CAA08)
References: <1325154939-6986-1-git-send-email-vthiagar@qca.qualcomm.com>
	 <1325154939-6986-3-git-send-email-vthiagar@qca.qualcomm.com>
	 <4F01DC4B.50501@qca.qualcomm.com>  <20120103054000.GB16733@chvasanth-lnx>
	 (sfid-20120103_064051_183446_5E9CAA08)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 03 Jan 2012 09:12:50 +0100
Message-ID: <1325578370.3905.3.camel@jlt3.sipsolutions.net> (sfid-20120103_091256_473955_0021745F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-01-03 at 11:10 +0530, Vasanthakumar Thiagarajan wrote:

> > > @@ -62,8 +62,7 @@ static void ath6kl_add_new_sta(struct ath6kl *ar, u8 *mac, u16 aid, u8 *wpaie,
> > >  
> > >  	sta = &ar->sta_list[free_slot];
> > >  	memcpy(sta->mac, mac, ETH_ALEN);
> > > -	if (ielen <= ATH6KL_MAX_IE)
> > > -		memcpy(sta->wpa_ie, wpaie, ielen);
> > > +	memcpy(sta->wpa_ie, wpaie, ielen);
> 
> > 
> > And then someone changes the u8 ielen to something else and accidentally
> > adds a bug. I would prefer to have an explicit check for the ielen to
> > make it obvious what's the maximum length.
> > 
> > I don't really like using u8 for ielen either. IMHO size_t or similar
> > would be better.
> 
> The length of any IE is 1 byte, u8 is the appropriate one.

No -- this can contain multiple IEs.

johannes

