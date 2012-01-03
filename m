Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17188 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab2ACFkc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 00:40:32 -0500
Date: Tue, 3 Jan 2012 11:10:02 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 3/3] ath6kl: Remove few deadcode in main.c
Message-ID: <20120103054000.GB16733@chvasanth-lnx> (sfid-20120103_064051_183446_5E9CAA08)
References: <1325154939-6986-1-git-send-email-vthiagar@qca.qualcomm.com>
 <1325154939-6986-3-git-send-email-vthiagar@qca.qualcomm.com>
 <4F01DC4B.50501@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4F01DC4B.50501@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 02, 2012 at 06:33:15PM +0200, Kalle Valo wrote:
> On 12/29/2011 12:35 PM, Vasanthakumar Thiagarajan wrote:
> > 1. In ath6kl_add_new_sta(), if (ielen <= ATH6KL_MAX_IE) is going to be
> > always true due to ielen being u8 and is checked against 256.
> > 
> > 2. In ath6kl_reset_device(), since control can never reach switch..case
> > when the target_type is neither TARGET_TYPE_AR6003 nor TARGET_TYPE_AR6004,
> > remove the default option of switch statement.
> 
> Two separate patches, please.

Ok, I split the patch.
> 
> > @@ -62,8 +62,7 @@ static void ath6kl_add_new_sta(struct ath6kl *ar, u8 *mac, u16 aid, u8 *wpaie,
> >  
> >  	sta = &ar->sta_list[free_slot];
> >  	memcpy(sta->mac, mac, ETH_ALEN);
> > -	if (ielen <= ATH6KL_MAX_IE)
> > -		memcpy(sta->wpa_ie, wpaie, ielen);
> > +	memcpy(sta->wpa_ie, wpaie, ielen);

> 
> And then someone changes the u8 ielen to something else and accidentally
> adds a bug. I would prefer to have an explicit check for the ielen to
> make it obvious what's the maximum length.
> 
> I don't really like using u8 for ielen either. IMHO size_t or similar
> would be better.

The length of any IE is 1 byte, u8 is the appropriate one.

Vasanth
