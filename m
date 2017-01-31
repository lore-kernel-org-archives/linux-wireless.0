Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:48724 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750727AbdAaGfW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 01:35:22 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Pavel Machek <pavel@ucw.cz>,
        Pali =?utf-8?Q?Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Michal Kazior <michal.kazior@tieto.com>,
        Daniel Wagner <wagi@monom.org>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/6] wl1251: Use request_firmware_prefer_user() for loading NVS calibration data
References: <def4c357-64c0-0681-a5d5-f49a6cb84a92@broadcom.com>
        <20170127101043.GD24223@pali>
        <f60cf2c0-bc1e-3a5f-991c-dc6c95a656af@broadcom.com>
        <20170127103408.GG24223@pali>
        <87bmus7mfk.fsf@kamboji.qca.qualcomm.com>
        <20170127115706.GH24223@pali>
        <8737g47kpd.fsf@kamboji.qca.qualcomm.com>
        <20170127131146.GI24223@pali>
        <87bmus5xyc.fsf@kamboji.qca.qualcomm.com> <20170127194012.GE20571@amd>
        <20170130175309.GY7403@atomide.com>
Date: Tue, 31 Jan 2017 08:35:09 +0200
In-Reply-To: <20170130175309.GY7403@atomide.com> (Tony Lindgren's message of
        "Mon, 30 Jan 2017 09:53:09 -0800")
Message-ID: <8737fzrb36.fsf@kamboji.qca.qualcomm.com> (sfid-20170131_073532_057514_FBFD056F)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tony Lindgren <tony@atomide.com> writes:

> * Pavel Machek <pavel@ucw.cz> [170127 11:41]:
>> On Fri 2017-01-27 17:23:07, Kalle Valo wrote:
>> > Pali Roh=C3=A1r <pali.rohar@gmail.com> writes:
>> >=20
>> > > On Friday 27 January 2017 14:26:22 Kalle Valo wrote:
>> > >> Pali Roh=C3=A1r <pali.rohar@gmail.com> writes:
>> > >>=20
>> > >> > 2) It was already tested that example NVS data can be used for N9=
00 e.g.
>> > >> > for SSH connection. If real correct data are not available it is =
better
>> > >> > to use at least those example (and probably log warning message) =
so user
>> > >> > can connect via SSH and start investigating where is problem.
>> > >>=20
>> > >> I disagree. Allowing default calibration data to be used can be
>> > >> unnoticed by user and left her wondering why wifi works so badly.
>> > >
>> > > So there are only two options:
>> > >
>> > > 1) Disallow it and so these users will have non-working wifi.
>> > >
>> > > 2) Allow those data to be used as fallback mechanism.
>> > >
>> > > And personally I'm against 1) because it will break wifi support for
>> > > *all* Nokia N900 devices right now.
>> >=20
>> > All two of them? :)
>>=20
>> Umm. You clearly want a flock of angry penguins at your doorsteps :-).
>
> Well this silly issue of symlinking and renaming nvs files in a standard
> Linux distro was also hitting me on various devices with wl12xx/wl18xx
> trying to use the same rootfs.
>
> Why don't we just set a custom compatible property for n900 that then
> picks up some other nvs file instead of the default?

Please don't. An ugly kernel workaround in kernel because of user space
problems is a bad idea. wl1251 should just ask for NVS file from user
space, it shouldn't care if it's a "default" file or something else.
That's a user space policy decision.

Why can't you do something like this:

* rename the NVS file linux-firmware to wl1251-nvs.bin.example

* before distro updates linux-firmware create yours own deb/rpm/whatever
  package "wl1251-firmware" which installs your flavor of nvs file (or
  the user fallback helper if more dynamic functionality is preferred)

--=20
Kalle Valo
