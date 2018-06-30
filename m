Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:45554 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751460AbeF3Rc3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 30 Jun 2018 13:32:29 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Timur =?utf-8?Q?Krist=C3=B3f?= <timur.kristof@gmail.com>
Cc: Ryan Hsu <ryanhsu@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [v2] ath10k: Update the phymode along with bandwidth change request
References: <1528482759-12604-1-git-send-email-ryanhsu@codeaurora.org>
        <20180628092800.6517B608C8@smtp.codeaurora.org>
        <45265cf5224d8d5e12e2eddc8968a879008657e5.camel@gmail.com>
Date: Sat, 30 Jun 2018 20:32:22 +0300
In-Reply-To: <45265cf5224d8d5e12e2eddc8968a879008657e5.camel@gmail.com>
        ("Timur \=\?utf-8\?Q\?Krist\=C3\=B3f\=22's\?\= message of "Sat, 30 Jun 2018 15:56:33
 +0200")
Message-ID: <87lgawdvtl.fsf@codeaurora.org> (sfid-20180630_193241_312389_22DCF1D0)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Timur Krist=C3=B3f <timur.kristof@gmail.com> writes:

> On Thu, 2018-06-28 at 09:28 +0000, Kalle Valo wrote:
>> Ryan Hsu <ryanhsu@codeaurora.org> wrote:
>>=20
>> > In the case of Station connects to AP with narrower bandwidth at
>> > beginning.
>> > And later the AP changes the bandwidth to winder bandwidth, the AP
>> > will
>> > beacon with wider bandwidth IE, eg VHT20->VHT40->VHT80 or VHT40-
>> > >VHT80.
>> >=20
>> > Since the supported BANDWIDTH will be limited by the PHYMODE, so
>> > while
>> > Station receives the bandwidth change request, it will also need to
>> > reconfigure the PHYMODE setting to firmware instead of just
>> > configuring
>> > the BANDWIDTH info, otherwise it'll trigger a firmware crash with
>> > non-support bandwidth.
>> >=20
>> > The issue was observed in WLAN.RM.4.4.1-00051-QCARMSWP-1, QCA6174
>> > with
>> > below scenario:
>> >=20
>> > AP xxx changed bandwidth, new config is 5200 MHz, width 2 (5190/0
>> > MHz)
>> > disconnect from AP xxx for new auth to yyy
>> > RX ReassocResp from xxx (capab=3D0x1111 status=3D0 aid=3D102)
>> > associated
>> >=20
>> > ....
>> >=20
>> > AP xxx changed bandwidth, new config is 5200 MHz, width 2 (5190/0
>> > MHz)
>> > AP xxx changed bandwidth, new config is 5200 MHz, width 3 (5210/0
>> > MHz)
>> >=20
>> > ....
>> >=20
>> > firmware register dump:
>> > [00]: 0x05030000 0x000015B3 0x00987291 0x00955B31
>> > [04]: 0x00987291 0x00060730 0x00000004 0x00000001
>> > [08]: 0x004089F0 0x00955A00 0x000A0B00 0x00400000
>> > [12]: 0x00000009 0x00000000 0x00952CD0 0x00952CE6
>> > [16]: 0x00952CC4 0x0098E25F 0x00000000 0x0091080D
>> > [20]: 0x40987291 0x0040E7A8 0x00000000 0x0041EE3C
>> > [24]: 0x809ABF05 0x0040E808 0x00000000 0xC0987291
>> > [28]: 0x809A650C 0x0040E948 0x0041FE40 0x004345C4
>> > [32]: 0x809A5C63 0x0040E988 0x0040E9AC 0x0042D1A8
>> > [36]: 0x8091D252 0x0040E9A8 0x00000002 0x00000001
>> > [40]: 0x809FDA9D 0x0040EA58 0x0043D554 0x0042D554
>> > [44]: 0x809F8B22 0x0040EA78 0x0043D554 0x00000001
>> > [48]: 0x80911210 0x0040EAC8 0x00000010 0x004041D0
>> > [52]: 0x80911154 0x0040EB28 0x00400000 0x00000000
>> > [56]: 0x8091122D 0x0040EB48 0x00000000 0x00400600
>> >=20
>> > Reported-by: Rouven Czerwinski <rouven@czerwinskis.de>
>> > Tested-by: Timur Krist=C3=B3f <timur.kristof@gmail.com>
>> > Signed-off-by: Ryan Hsu <ryanhsu@codeaurora.org>
>> > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
>>=20
>> Patch applied to ath-current branch of ath.git, thanks.
>>=20
>> 9191fc2a431b ath10k: update the phymode along with bandwidth change
>> request
>
> Thank you Kalle.
> Does this mean that the patch will get into kernel 4.18?

Yes, if all goes well. But it might take a week or two before it reaches
Linus' tree as I submit patches to net tree.

--=20
Kalle Valo
