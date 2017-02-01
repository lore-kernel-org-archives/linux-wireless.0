Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:34927 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751925AbdBAJfF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Feb 2017 04:35:05 -0500
Received: by mail-qk0-f174.google.com with SMTP id u25so192167520qki.2
        for <linux-wireless@vger.kernel.org>; Wed, 01 Feb 2017 01:35:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170201083312.GA6609@pali>
References: <20170127103408.GG24223@pali> <87bmus7mfk.fsf@kamboji.qca.qualcomm.com>
 <20170127115706.GH24223@pali> <8737g47kpd.fsf@kamboji.qca.qualcomm.com>
 <20170127131146.GI24223@pali> <87bmus5xyc.fsf@kamboji.qca.qualcomm.com>
 <20170127194012.GE20571@amd> <20170130175309.GY7403@atomide.com>
 <8737fzrb36.fsf@kamboji.qca.qualcomm.com> <20170131155918.GD7403@atomide.com> <20170201083312.GA6609@pali>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Wed, 1 Feb 2017 10:35:03 +0100
Message-ID: <CA+BoTQnNFWFNe1W9nO+Kwp0oZaPuGZX=0F=MX3+m7X-ekNYPPQ@mail.gmail.com> (sfid-20170201_103544_818063_6965E8E6)
Subject: Re: [PATCH 2/6] wl1251: Use request_firmware_prefer_user() for
 loading NVS calibration data
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>,
        Kalle Valo <kvalo@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Ming Lei <ming.lei@canonical.com>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Gnedt <david.gnedt@davizone.at>,
        Daniel Wagner <wagi@monom.org>,
        Sebastian Reichel <sre@kernel.org>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Grazvydas Ignotas <notasas@gmail.com>,
        linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 1 February 2017 at 09:33, Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
> On Tuesday 31 January 2017 07:59:18 Tony Lindgren wrote:
>> * Kalle Valo <kvalo@codeaurora.org> [170130 22:36]:
[...]
>> > * before distro updates linux-firmware create yours own deb/rpm/whatev=
er
>> >   package "wl1251-firmware" which installs your flavor of nvs file (or
>> >   the user fallback helper if more dynamic functionality is preferred)
>>
>> And that won't work when using the same file system on other machines.
>>
>> Think NFSroot for example. At least I'm using the same NFSroot across
>> about 15 different machines including one n900 macro board with smc91x
>> Ethernet.
>
> Exactly problem which we already discussed in previous emails. You
> cannot serve one file (loaded by direct request_firmware) when your
> rootfs is readonly, e.g. comes via NFS shared for more devices...

You can extract the nvs blob, put it in tmpfs and bind-mount (or
symlink) it to /lib/firmware/ via modprobe install hook (or init
scripts).


Micha=C5=82
