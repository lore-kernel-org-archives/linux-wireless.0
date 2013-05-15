Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:21608 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab3EOOu1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:50:27 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ignacy Gawedzki <i@lri.fr>
CC: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [ath9k-devel] ath9k_htc: Target is unresponsive
References: <20130515134258.GA9033@zenon.in.qult.net>
Date: Wed, 15 May 2013 17:50:16 +0300
In-Reply-To: <20130515134258.GA9033@zenon.in.qult.net> (Ignacy Gawedzki's
	message of "Wed, 15 May 2013 15:42:58 +0200")
Message-ID: <87a9nwpaaf.fsf@kamboji.qca.qualcomm.com> (sfid-20130515_165031_410568_A7476D14)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ignacy Gawedzki <i@lri.fr> writes:

> Hi everyone,
>
> This is an old issue, about which it seems the first posts date back to 2009.
> With the latest possible version of the firmware for AR9271 and the latest
> possible wireless drivers, the issue is still there.  Whether this is still
> the exact same problem every time remains to be checked, but it is annoying
> enough to deserve some consideration.
>
> The problem is that the driver can't talk to the device if the following
> conditions are met:
>
>  - The system cold boots with the USB dongle inserted or the USB dongle is
>    inserted on a running system.
>
>  - The interface is *not* brought up.
>
>  - The system (warm) reboots.
>
> Then the driver complains about the target being unresponsive after uploading
> the firmware.  Apparently the only way to make it work again is to unplug and
> then plug the USB dongle back, physically.  It seems that if the USB port is
> not powered down during reboot (which happens with at least two different
> setups that I've tested it with), the device is left in a broken state.
>
> I would gladly help in tracing down this bug if only I knew where to start.

With ath6kl a cold reset helped in a similar situation. Try to find if
ath9k_htc has a cold/warm reset and see if that helps.

-- 
Kalle Valo
