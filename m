Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38790 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933052AbcKVPXE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Nov 2016 10:23:04 -0500
Received: by mail-wm0-f41.google.com with SMTP id f82so30819367wmf.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Nov 2016 07:22:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161121155153.GM13735@pali>
References: <201611111820.52072@pali> <20161121155153.GM13735@pali>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Tue, 22 Nov 2016 16:22:57 +0100
Message-ID: <CA+BoTQm5yZYccMherMnmxZ0_b2PqkCWf_0nBoRLzsro-Ujz1eQ@mail.gmail.com> (sfid-20161122_162323_840309_4365072D)
Subject: Re: wl1251 & mac address & calibration data
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 November 2016 at 16:51, Pali Roh=C3=A1r <pali.rohar@gmail.com> wrote:
> On Friday 11 November 2016 18:20:50 Pali Roh=C3=A1r wrote:
>> Hi! I will open discussion about mac address and calibration data for
>> wl1251 wireless chip again...
>>
>> Problem: Mac address & calibration data for wl1251 chip on Nokia N900
>> are stored on second nand partition (mtd1) in special proprietary format
>> which is used only for Nokia N900 (probably on N8x0 and N9 too).
>> Wireless driver wl1251.ko cannot work without mac address and
>> calibration data.

Same problem applies to some ath9k/ath10k supported routers. Some even
carry mac address as implicit offset from ethernet mac address. As far
as I understand OpenWRT cooks cal blobs on first boot prior to loading
modules.


>> Absence of mac address cause that driver generates random mac address at
>> every kernel boot which has couple of problems (unstable identifier of
>> wireless device due to udev permanent storage rules; unpredictable
>> behaviour for dhcp mac address assignment, mac address filtering, ...).
>>
>> Currently there is no way to set (permanent) mac address for network
>> interface from userspace. And it does not make sense to implement in
>> linux kernel large parser for proprietary format of second nand
>> partition where is mac address stored only for one device -- Nokia N900.
>>
>> Driver wl1251.ko loads calibration data via request_firmware() for file
>> wl1251-nvs.bin. There are some "example" calibration file in linux-
>> firmware repository, but it is not suitable for normal usage as real
>> calibration data are per-device specific.

You could hook up a script that cooks up the cal/mac file via
modprobe's install hook, no?


Micha=C5=82
