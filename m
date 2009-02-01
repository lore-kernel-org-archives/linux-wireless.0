Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f21.google.com ([209.85.217.21]:35345 "EHLO
	mail-gx0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbZBAEgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Jan 2009 23:36:23 -0500
Received: by gxk14 with SMTP id 14so858318gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 31 Jan 2009 20:36:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090201004349.GB17607@hash.localnet>
References: <20090131023007.GD3342@makis>
	 <20090201004349.GB17607@hash.localnet>
Date: Sun, 1 Feb 2009 06:36:22 +0200
Message-ID: <40f31dec0901312036p34b638e9wdb0332384a66a29e@mail.gmail.com> (sfid-20090201_053636_618012_6593225F)
Subject: Re: [ath5k-devel] [PATCH 4/5] ath5k: Update initvals
From: Nick Kossifidis <mickflemm@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/2/1 Bob Copeland <me@bobcopeland.com>:
> On Sat, Jan 31, 2009 at 04:30:07AM +0200, Nick Kossifidis wrote:
>>  * Update initvals to match legacy and Sam's HAL
>>
>>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
>
> I spot checked some of these, this is the only thing I saw:
>
>> -     { AR5K_BEACON_CNT_5211, 0x00000000 },   /* change */
>> +     { AR5K_FRAME_CTL_QOSM,  0x000fc78f },
>
> legacy-hal and Sam disagree on the top 12 bits (0xffffc78f vs
> 0x000fc78f), we have Sam's.
>

According to docs, this is the aes mute mask and upper bits are the
aes mute mask for TID (traffic identifier) field used in QoS. So Sam
disables the TID thing on his HAL and legacy HAL leaves it unmasked.
It seems they also disable it on ath9k (have i mentioned that we have
many things in common ? :P) so i go with Sam's choice.

from ath9k's initvals.h
{ 0x0000805c, 0x000fc78f }


> Rest looks good to me, feel free to add my Acked-by if you want.




-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
