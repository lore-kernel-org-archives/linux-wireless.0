Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29038 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab1LTTq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 14:46:27 -0500
Date: Tue, 20 Dec 2011 11:46:18 -0800
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/6] ath6kl: fix sparse warning on init.c
Message-ID: <20111220194618.GD15071@tux> (sfid-20111220_204630_616882_D2F0C750)
References: <1324406771-7100-1-git-send-email-rodrigue@qca.qualcomm.com>
 <1324406771-7100-2-git-send-email-rodrigue@qca.qualcomm.com>
 <4EF0E4A3.9010306@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <4EF0E4A3.9010306@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 20, 2011 at 09:40:19PM +0200, Kalle Valo wrote:
> On 12/20/2011 08:46 PM, Luis R. Rodriguez wrote:
> > From: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> > 
> > This fixes this sparse warning:
> > 
> >   CC [M]  drivers/net/wireless/ath/ath6kl/init.o
> > drivers/net/wireless/ath/ath6kl/init.c: In function ‘ath6kl_init_hw_params’:
> > drivers/net/wireless/ath/ath6kl/init.c:1377:26: warning: ‘hw’ may be used uninitialized in this function
> 
> That's a compiler warning.
> 
> >  static int ath6kl_init_hw_params(struct ath6kl *ar)
> >  {
> > -	const struct ath6kl_hw *hw;
> > +	const struct ath6kl_hw *hw = NULL;
> >  	int i;
> >  
> >  	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
> > @@ -1390,6 +1390,9 @@ static int ath6kl_init_hw_params(struct ath6kl *ar)
> >  		return -EINVAL;
> >  	}
> >  
> > +	if (!hw)
> > +		return -EINVAL;
> 
> I can't see how hw can be uninitialised here (looking at the version in
> ath6kl.git). I copy the full code here:
> 
> static int ath6kl_init_hw_params(struct ath6kl *ar)
> {
> 	const struct ath6kl_hw *hw;
> 	int i;
> 
> 	for (i = 0; i < ARRAY_SIZE(hw_list); i++) {
> 		hw = &hw_list[i];
> 
> 		if (hw->id == ar->version.target_ver)
> 			break;
> 	}
> 
> 	if (i == ARRAY_SIZE(hw_list)) {
> 		ath6kl_err("Unsupported hardware version: 0x%x\n",
> 			   ar->version.target_ver);
> 		return -EINVAL;
> 	}
> 
> 	ar->hw = *hw;
> 
> I always check for both compiler and sparse warnings and I have never
> seen this. What version of compiler do you have?
> 
> I have:
> 
> gcc-4.5.real (Ubuntu/Linaro 4.5.2-8ubuntu4) 4.5.2

Same.

mcgrof@tux ~ $ gcc --version
gcc-4.5.real (Ubuntu/Linaro 4.5.2-8ubuntu4) 4.5.2
Copyright (C) 2010 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE

  Luis
