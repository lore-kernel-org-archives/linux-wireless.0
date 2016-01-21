Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:55677 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965248AbcAUNpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jan 2016 08:45:06 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>,
	Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH v2] wl1251: add sysfs interface for bluetooth coexistence mode configuration
References: <1451130310-16666-1-git-send-email-pali.rohar@gmail.com>
Date: Thu, 21 Jan 2016 15:44:58 +0200
In-Reply-To: <1451130310-16666-1-git-send-email-pali.rohar@gmail.com> ("Pali
	=?utf-8?Q?Roh=C3=A1r=22's?= message of "Sat, 26 Dec 2015 12:45:10 +0100")
Message-ID: <87h9i7yrl1.fsf@kamboji.qca.qualcomm.com> (sfid-20160121_144511_536775_002C77FF)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pali Rohár <pali.rohar@gmail.com> writes:

> Port the bt_coex_mode sysfs interface from wl1251 driver version included
> in the Maemo Fremantle kernel to allow bt-coexistence mode configuration.
> This enables userspace applications to set one of the modes
> WL1251_BT_COEX_OFF, WL1251_BT_COEX_ENABLE and WL1251_BT_COEX_MONOAUDIO.
> The default mode is WL1251_BT_COEX_OFF.
> It should be noted that this driver always enabled bt-coexistence before
> and enabled bt-coexistence directly affects the receiving performance,
> rendering it unusable in some low-signal situations. Especially monitor
> mode is affected very badly with bt-coexistence enabled.
>
> Signed-off-by: David Gnedt <david.gnedt@davizone.at>
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> ---
> I'm resending this patch for review again as after two years there is no
> nl80211 interface for bt coex and wl1251 on Nokia N900 needs it. Once
> there will be common interface for bt coex I can rewrite my patches, but
> I do not want to wait another 2 years...

It doesn't work like that. Wireless drivers cannot have custom
interfaces via sysfs, all configuration has to go through cfg80211.
Instead of waiting two years you could have added it yourself.

-- 
Kalle Valo
