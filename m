Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36170 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754641AbcLTRL6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 12:11:58 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali.rohar@gmail.com>,
        Daniel Wagner <wagi@monom.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Tom Gundersen <teg@jklm.no>,
        Johannes Berg <johannes@sipsolutions.net>,
        Ming Lei <ming.lei@canonical.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82eck?= =?utf-8?Q?i?=
        <zajec5@gmail.com>, Sebastian Reichel <sre@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Michal Kazior <michal.kazior@tieto.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Takashi Iwai <tiwai@suse.de>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: wl1251 & mac address & calibration data
References: <201611111820.52072@pali> <201612181204.52928@pali>
        <83b2e9a4-f990-68a8-241e-375e46448d47@broadcom.com>
        <201612181309.01298@pali>
        <fd180271-1cd4-9891-e3d5-ae9cd0fb088b@broadcom.com>
        <87shpiu8j8.fsf@kamboji.qca.qualcomm.com>
        <20161220165658.GI4920@atomide.com>
Date: Tue, 20 Dec 2016 19:11:45 +0200
In-Reply-To: <20161220165658.GI4920@atomide.com> (Tony Lindgren's message of
        "Tue, 20 Dec 2016 08:56:58 -0800")
Message-ID: <87bmw6ttim.fsf@kamboji.qca.qualcomm.com> (sfid-20161220_181223_056339_8EB95E80)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tony Lindgren <tony@atomide.com> writes:

> * Kalle Valo <kvalo@codeaurora.org> [161220 03:47]:
>> Arend Van Spriel <arend.vanspriel@broadcom.com> writes:
>>=20
>> > On 18-12-2016 13:09, Pali Roh=C3=A1r wrote:
>> >
>> >> File wl1251-nvs.bin is provided by linux-firmware package and contain=
s=20
>> >> default data which should be overriden by model specific calibrated=20
>> >> data.
>> >
>> > Ah. Someone thought it was a good idea to provide the "one ring to rule
>> > them all". Nice.
>>=20
>> Yes, that was a bad idea. wl1251-nvs.bin in linux-firmware.git should be
>> renamed to wl1251-nvs.bin.example, or something like that, as it should
>> be only installed to a real system only if there's no real calibration
>> data available (only for developers to use, not real users).
>
> Makes sense to me. Note that with the recent changes to wlcore, we can
> now easily provide board specific calibration firmware simply by adding a
> new compatible value. So for n900, we could have something like
> compatible =3D "ti,wl1251-n900" and have it point to n900 specific calibr=
ation
> file wl1251-nvs-n900.bin. Of course this won't help with the mac address,
> or any of the device specific data..
>
> That is assuming the calibration values are the same for each similar
> device and don't have to be generated for each device. And naturally wl12=
51
> needs simlar changes done to make use of devices specific calibration fil=
es.

No, these are unique per each sold device. Every N900 was calibrated at
the factory and they all have different calibration data which is stored
to the flash. So when N900 boots (and in _every_ boot) it has to load
the calibration data from the flash and provide it to the wl1251 driver
somehow.

--=20
Kalle Valo
