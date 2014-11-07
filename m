Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:38747 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaKGIwH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 03:52:07 -0500
Received: by mail-lb0-f181.google.com with SMTP id l4so2286657lbv.26
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2014 00:52:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141106135217.11DF985248@smtp04.mail.de>
References: <20141106135217.11DF985248@smtp04.mail.de>
Date: Fri, 7 Nov 2014 10:52:04 +0200
Message-ID: <CANUX_P3eiKam=rvoawQybiaLLk+hcs2i4Ly8xnm0Qmnhijx+ag@mail.gmail.com> (sfid-20141107_095211_309067_8AE83ECC)
Subject: Re: Problem with Intel Wireless-N 7260 and Ubuntu 14.10
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: =?UTF-8?Q?Henry_W=C3=BCnsche?= <henry.wuensche@mail.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 6, 2014 at 3:52 PM, Henry Wünsche <henry.wuensche@mail.de> wrote:
> Hello!
> I got a problem with an Lenovo U330p botebook and it's build in Intel
> Wireless-N 7260 in combination with Ubuntu 14.10 .
> If the WiFi card is running in N-mode after a few minutes I am no more able
> to ping my router or visit any website. If the N-mode is disabled via the
> command "options iwlwifi 11n_disable=1" in "/etc/modprobe.d/iwlwifi.conf"
> it works for me.

Can you please enable 11n and record tracing while you can't ping your router?

sudo trace-cmd record -e iwlwifi -e mac80211 -e cfg80211 -e iwlwifi_msg

This will create a trace.dat file which you can send.

Take into account this kind of system issues are very hard to debug
remotely, so.... I am not sure I'll be able to do a lot for you.
And I'll be travelling to San Francisco the next two weeks, so I will
have very little time for that.


>
> I also noticed that the wifi range with that wireless card on Ubuntu is
> terrible. I dual boot with Windows 8.1 and there  wifi range is much better
> and even N-mode works.
>
> after booting Ubuntu (mainline kernel 3.17.1) dmesg shows this:
>
> [    4.133139] iwlwifi 0000:02:00.0: irq 49 for MSI/MSI-X
> [    4.133484] iwlwifi 0000:02:00.0: Direct firmware load for
> iwlwifi-7260-10.ucode failed with error -2
> [    4.133487] iwlwifi 0000:02:00.0: Falling back to user helper
> [    4.253735] iwlwifi 0000:02:00.0: loaded firmware version 25.222.9.0
> op_mode iwlmvm
> [    5.816514] iwlwifi 0000:02:00.0: Detected Intel(R) Wireless N 7260,
> REV=0x144
> [    5.816562] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
> [    5.816777] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
> [    6.086593] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
> [    6.086802] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
> [    7.167833] iwlwifi 0000:02:00.0: Time Event end notification failure
>
> the mentioned firmware  iwlwifi-7260-10.ucode isn't installed, but
>  iwlwifi-7260-7.ucode
>  iwlwifi-7260-8.ucode
>  iwlwifi-7260-9.ucode
>
> are.
>
> Is there any solution for this problem or any fix?
> I read that  iwlwifi-7260-10.ucode isn't atable yet, so I haven't installed
> it at the moment.
>
> Thanks in advance and best regards,
>
> Henry Wünsche
