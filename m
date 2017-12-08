Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:5800 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753841AbdLHJuV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 04:50:21 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Christian Lamparter <chunkeey@googlemail.com>
CC: Sven Eckelmann <sven.eckelmann@openmesh.com>,
        "ext.waldemar.rymarkiewicz@tieto.com"
        <ext.waldemar.rymarkiewicz@tieto.com>,
        Aeolus Yang <aeolus@qti.qualcomm.com>,
        Adrian Chadd <adrian@freebsd.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 2/2] ath10k: search DT for qcom,
 ath10k-calibration-variant
Date: Fri, 8 Dec 2017 09:50:12 +0000
Message-ID: <87bmj9tup8.fsf@kamboji.qca.qualcomm.com> (sfid-20171208_105222_625694_34FD75C8)
References: <20170310080615.22958-1-sven.eckelmann@openmesh.com>
        <20170310080615.22958-2-sven.eckelmann@openmesh.com>
        <3853747.Q0JJmSnsYM@debian64>
In-Reply-To: <3853747.Q0JJmSnsYM@debian64> (Christian Lamparter's message of
        "Fri, 10 Mar 2017 19:20:54 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter <chunkeey@googlemail.com> writes:

> On Friday, March 10, 2017 9:06:15 AM CET Sven Eckelmann wrote:
>> Board Data File (BDF) is loaded upon driver boot-up procedure. The right
>> board data file is identified on QCA4019 using bus, bmi-chip-id and
>> bmi-board-id.
>>=20
>> The problem, however, can occur when the (default) board data file canno=
t
>> fulfill with the vendor requirements and it is necessary to use a differ=
ent
>> board data file.
>>=20
>> This problem was solved for SMBIOS by adding a special SMBIOS type 0xF8.
>> Something similar has to be provided for systems without SMBIOS but with
>> device trees. No solution was specified by QCA and therefore a new one h=
as
>> to be found for ath10k.
>>=20
>> The device tree requires addition strings to define the variant name
>>=20
>>     wifi@a000000 {
>>     	status =3D "okay";
>>     	qcom,ath10k-calibration-variant =3D "RT-AC58U";
>>     };
>>=20
>>     wifi@a800000 {
>>     	status =3D "okay";
>>     	qcom,ath10k-calibration-variant =3D "RT-AC58U";
>>     };
>>=20
>> This would create the boarddata identifiers for the board-2.bin search
>>=20
>>  *  bus=3Dahb,bmi-chip-id=3D0,bmi-board-id=3D16,variant=3DRT-AC58U
>>  *  bus=3Dahb,bmi-chip-id=3D0,bmi-board-id=3D17,variant=3DRT-AC58U
>>=20
>> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>

[...]

> @Aeolus Yang / Kalle / QCA: Would it be possible to assign a variant stri=
ng to
> the Asus RT-AC58U?

What do you mean? Add qcom,ath10k-calibration-variant to that board's
device tree or something else?

> I've attached the necessary bmi-board-id=3D16 and bmi-board-id=3D17 board=
=20
> files to this mail as well. So, all that needs to be done is to add
> them to the board-2.bin on your codeaurora / ath10k-firmware project.
>
> Kalle: Can you please update the board-2.bin for the IPQ40XX on your
> ath10k-firmware project on github?

Where did you get these board files from?

BTW, it seems lots of people want to add board files so I wrote
instruction how I prefer them submitted:

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/boardfiles

> https://source.codeaurora.org/quic/qsdk/oss/firmware/ath10k-firmware/plai=
n/ath10k/QCA40XX/hw1.0/board-2.bin
>
> It looks like this board-2.bin has support for a few more boards.

I checked and that should be in ath10k-firmware.git now:

$ ath10k-bdencoder --diff ../board-2.bin board-2.bin  | tail -1
0 board image(s) added, 0 changed, 0 deleted, 9 in total



--=20
Kalle Valo=
