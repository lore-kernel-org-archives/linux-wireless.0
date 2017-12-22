Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:60147 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751966AbdLVQVh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 11:21:37 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Gary Bisson <gary.bisson@boundarydevices.com>
CC: Alagu Sankar <alagusankar@silex-india.com>,
        "erik.stromdahl@gmail.com" <erik.stromdahl@gmail.com>,
        "silexcommon@gmail.com" <silexcommon@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 00/11] SDIO support for ath10k
Date: Fri, 22 Dec 2017 16:21:31 +0000
Message-ID: <87a7ya91is.fsf@kamboji.qca.qualcomm.com> (sfid-20171222_172141_521752_E7BE4828)
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
        <20171005151205.cymirl4wikuw4f7q@t450s.lan>     <59D66ACA.60801@silex-india.com>
        <20171006111613.ulatu65gvmgrr2ie@t450s.lan>
        <20171218161958.yi5ldohhdf2hadfy@t450s.lan>
In-Reply-To: <20171218161958.yi5ldohhdf2hadfy@t450s.lan> (Gary Bisson's
        message of "Mon, 18 Dec 2017 17:19:58 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gary Bisson <gary.bisson@boundarydevices.com> writes:

> On Fri, Oct 06, 2017 at 01:16:13PM +0200, Gary Bisson wrote:
>> On Thu, Oct 05, 2017 at 10:54:26PM +0530, Alagu Sankar wrote:
>> > On 05-10-2017 20:42, Gary Bisson wrote:
>> > >=20
>> > > First of all, thank you for sharing your patches, this will be a ver=
y
>> > > nice improvement to have SDIO QCA9377 working with ath10k.
>> > >=20
>> > > I've tried your series with Nitrogen7 [1] platform which is supporte=
d in
>> > > mainline already. It uses BD-SDMAC [2] which uses the same module as=
 the
>> > > SX-SDMAC.
>> > >=20
>> > > Below are some questions/remarks I have after the testing.
>> > >=20
>> > > Quick question on the firmware, is it the one from Kalle's repositor=
y?[3]
>> > >=20
>> > > If so, where does this firmware comes from? Is 00061 the firmware
>> > > version? So far I've only seen up to v0.0.0.60, see qcacld-2.0 outpu=
t:
>> > > Host SW:4.5.20.037, FW:0.0.0.60, HW:QCA9377_REV1_1
>> >
>> > Yes, it is from
>> > https://github.com/kvalo/ath10k-firmware/tree/master/QCA9377/hw1.0/unt=
ested.
>> > I have also used custom firmware from QCA/Silex as used in qcacld-2.0 =
driver
>> > without any issue. You need to use the firmware merger tool from
>> > https://github.com/erstrom/linux-ath/wiki/Firmware to combine the
>> > qwlan30.bin and otp30.bin to generate the firmware-sdio.bin.
>>=20
>> Good to know, thanks. Maybe Kalle can tell us more about the firmware
>> itself, what's the difference between the version 0.0.0.60 and 0.0.0.61?
>
> Any update on this, is there a release notes for this 0.0.0.61 firmware?

Unfortunately I don't have any changelogs for the firmware releases.

> As a FYI, I've tried your ath10k patches (along with a few backported
> patches from Erik) on the NXP-fork of 4.9 kernel [1].
>
> I confirm that it provides pretty decent performances:
> - ath10k: 110Mbit/s
> - qcacld-2.0: 125Mbit/s
>
> Here are some details about the setup:
> - TPLink AC router
> - Nitrogen7 (i.MX7) with BD-SDMAC
> - Kernel 4.9.68 (NXP fork [1])
> - FW 0.0.0.61 from ath10k-firmware repo

Nice, thanks for the report. This is always helpful.

--=20
Kalle Valo=
