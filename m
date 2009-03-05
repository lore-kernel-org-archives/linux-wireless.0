Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:23320 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077AbZCEBuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2009 20:50:09 -0500
Received: by rv-out-0506.google.com with SMTP id g37so3600891rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2009 17:50:07 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18863.12192.871072.649460@gargle.gargle.HOWL> (sfid-20090305_025026_001589_F1EAA8ED)
Date: Thu, 5 Mar 2009 07:19:20 +0530
To: Gabor Juhos <juhosg@openwrt.org>
Cc: "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: use correct init values for ar9100
 devices
In-Reply-To: <49AEAA34.8080806@openwrt.org>
References: <1236103846-1672-1-git-send-email-juhosg@openwrt.org>
	<18862.1025.217829.656599@gargle.gargle.HOWL>
	<18862.4870.138381.234256@gargle.gargle.HOWL>
	<49AE8466.3040906@openwrt.org>
	<18862.36430.959276.440720@gargle.gargle.HOWL>
	<49AEAA34.8080806@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gabor Juhos wrote:
> Well, I was curious, so I did it. :)
> 
> After some cut&paste job, here is the diff between the original and the new
> initvals from your patch:
> 
> diff --git a/drivers/net/wireless/ath9k/initvals.h
> b/drivers/net/wireless/ath9k/initvals.h
> index d492363..d5a8aec 100644
> --- a/drivers/net/wireless/ath9k/initvals.h
> +++ b/drivers/net/wireless/ath9k/initvals.h
> @@ -658,7 +657,7 @@ static const u32 ar5416Addac_9100[][2] = {
>      {0x0000989c,  0x00000000 },
>      {0x0000989c,  0x00000000 },
>      {0x0000989c,  0x00000000 },
> -    {0x000098cc,  0x00000000 },
> +    {0x000098c4,  0x00000000 },
>  };
> 
>  static const u32 ar5416Modes[][6] = {
> @@ -862,7 +861,7 @@ static const u32 ar5416Common[][2] = {
>      { 0x00008134, 0x00000000 },
>      { 0x00008138, 0x00000000 },
>      { 0x0000813c, 0x00000000 },
> -    { 0x00008144, 0x00000000 },
> +    { 0x00008144, 0xffffffff },
>      { 0x00008168, 0x00000000 },
>      { 0x0000816c, 0x00000000 },
>      { 0x00008170, 0x32143320 },
> 

Heh. :-)
Dunno if those 2 values make any difference.

> >>> +#define AR_SREV_VERSION_9100		0x014
> >> 0x14?
> > 
> > Yep, this can be fixed.
> 
> I have to send a new patch, or you will take care of it?

Feel free to send a patch fixing this, and the macro cleanup.
I'll just update the initvals, fix the check for AR9100 in HW attach 
and the typo for AR9285 chipsets.

Sujith
