Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f173.google.com ([209.85.210.173]:52902 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991Ab3EOOnB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 10:43:01 -0400
Received: by mail-ia0-f173.google.com with SMTP id k20so2210017iak.4
        for <linux-wireless@vger.kernel.org>; Wed, 15 May 2013 07:43:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130515134258.GA9033@zenon.in.qult.net>
References: <20130515134258.GA9033@zenon.in.qult.net>
Date: Wed, 15 May 2013 16:43:00 +0200
Message-ID: <CAFSJ42Zraj0xZ-YJ_LednHvjOa1uXt2-BWvSiYdhE=ttQXup8w@mail.gmail.com> (sfid-20130515_164306_071846_D6E18FF9)
Subject: Re: [ath9k-devel] ath9k_htc: Target is unresponsive
From: Eugene Krasnikov <k.eugene.e@gmail.com>
To: Ignacy Gawedzki <i@lri.fr>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware is open nowadays for AR9271
https://github.com/qca/open-ath9k-htc-firmware/
But this is an interesting issue. I am currently working on one
problem that target becomes unresponsive(as described here
https://github.com/qca/open-ath9k-htc-firmware/issues/25) but i doubt
it's the same issue as yours. Let me see if i can reproduce your
problem. Will come back to you shortly.

2013/5/15 Ignacy Gawedzki <i@lri.fr>:
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
>
> Thanks for any suggestion.
>
> Ignacy
>
> --
> A person is shit's way of making more shit.
>                 -- S. Barnett, anthropologist.
> _______________________________________________
> ath9k-devel mailing list
> ath9k-devel@lists.ath9k.org
> https://lists.ath9k.org/mailman/listinfo/ath9k-devel



-- 
Best regards,
Eugene
