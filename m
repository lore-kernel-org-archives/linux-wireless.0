Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:55405 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810Ab3CSF0K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Mar 2013 01:26:10 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <drwho@infidigm.net>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>
Subject: Re: AR9374 v1.3 (Ath6kl - 6004) in sdio mode
References: <a10f9fe2e0e48f8b7378bb655d673151.squirrel@www.infidigm.net>
Date: Tue, 19 Mar 2013 07:25:58 +0200
In-Reply-To: <a10f9fe2e0e48f8b7378bb655d673151.squirrel@www.infidigm.net>
	(drwho@infidigm.net's message of "Mon, 18 Mar 2013 13:53:04 -0400")
Message-ID: <877gl43qqh.fsf@kamboji.qca.qualcomm.com> (sfid-20130319_062616_288250_99854AFD)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

<drwho@infidigm.net> writes:

> Can anyone confirm if they have had an AR9374 v1.3 (=AR6004) working in
> sdio mode in compat v3.8?  I have three AR9374s working just fine in USB
> mode with compat v3.8.  I have an AR6103 (=AR6003), sdio, working on the
> same host as I'm trying the AR9374 on.  The AR9374 only gets as far as
> registering as mmc1.  The vendor and device IDs are correct.  When I try
> to load ath6kl_sdio, I get....
>
> ath6kl: 8f69fe04
> ath6kl: 8f69fe34
> ath6kl: 8f69fe7c
> ath6kl_sdio: probe of mmc1:0001:1 failed with error -110
>
> loading ath6kl_core.ko debug_mask=0xffffffff doesn't give much more. 
> compat is build with
> export CONFIG_ATH_DEBUG=y
> export CONFIG_ATH6KL_DEBUG=y
> and I'm getting tones on debug when booting the AR6103.
>
> My hardware settings for usb or sdio mode on the AR9374....
>
> USB mode
> sdio_cmd = 10k pull down
>
> SDIO mode
> sdio_cmd = 10k pull up to 3.3v
> sdio_D1 = 10k pull up to 3.3v
>
> I've tried dropping my sdio clock from 50Mhz to 10Mhz,  no go either.

Sounds like a hardware problem but difficult to say for sure. From
ath6kl point of view ar6003 and ar6004/ar9374 are not that different, at
least not that early on hardware initialisation.

-- 
Kalle Valo
