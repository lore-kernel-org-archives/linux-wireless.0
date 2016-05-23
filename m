Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28858 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbcEWKjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 May 2016 06:39:42 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Stephan Mueller <smueller@chronox.de>
CC: "miaoqing@codeaurora.org" <miaoqing@codeaurora.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ATH9K RNG
Date: Mon, 23 May 2016 10:39:06 +0000
Message-ID: <874m9pawjf.fsf@kamboji.qca.qualcomm.com> (sfid-20160523_124000_269839_664DBA80)
References: <4722005.7KY1oJgCp9@tauon.atsec.com>
In-Reply-To: <4722005.7KY1oJgCp9@tauon.atsec.com> (Stephan Mueller's message
	of "Mon, 23 May 2016 12:26:12 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Stephan Mueller <smueller@chronox.de> writes:

> considering the patch ed14dc0af7ccea867b479feb88efdfe43ca2a0f9 which adds the 
> invocation of add_hwgenerator_randomness to the ATH9K driver, may I ask about 
> more details about how you concluded that the data from the ATH chip is 
> entropic?
>
> In addition, can you please elaborate on the ATH9K_RNG_ENTROPY macro? I am 
> wondering about the multiplication of 320. If I understand the code right, the 
> return code of ath9k_rng_data_read returns the number of u32 values read from 
> the device, i.e. at most 320. With the ATH9K_RNG_ENTROPY macro, that return 
> value is multiplied by 320 (bytes?) converted into bits. I.e. it sounds to be 
> that the macro returns 320 u32 values times 320 bytes converted into bits. I 
> am wondering whether the macro should rather read  (((x) * 8 * 32) >> 10) -- 
> i.e. at most the entire array size holding the data in bits divided by 1024?

Please include linux-wireless (Cced) in the discussion. I don't remember
the details (and can't check right now) but there were discussions in
linux-wireless mailing list.

-- 
Kalle Valo