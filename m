Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:43769 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750741AbdJ2HG5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Oct 2017 03:06:57 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ryan Hsu <ryanhsu@qti.qualcomm.com>
CC: Thorsten Leemhuis <linux@leemhuis.info>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k-regression in 4.14: Connections aborts with "failed to
 extract amsdu: -11"
Date: Sun, 29 Oct 2017 07:06:43 +0000
Message-ID: <87y3nu4em6.fsf@kamboji.qca.qualcomm.com> (sfid-20171029_082017_818361_62FFD14B)
References: <5a4860eb-3734-7587-d81f-9c3de6ff11c8@leemhuis.info>
        <46f918c5-b07d-e397-2f3d-8136c7c1a8f3@qti.qualcomm.com>
In-Reply-To: <46f918c5-b07d-e397-2f3d-8136c7c1a8f3@qti.qualcomm.com> (Ryan
        Hsu's message of "Mon, 2 Oct 2017 23:40:31 +0000")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ linux-wireless

Ryan Hsu <ryanhsu@qti.qualcomm.com> writes:

>>> ath10k_pci 0000:3a:00.0: Direct firmware load for
>>> ath10k/pre-cal-pci-0000:3a:00.0.bin failed with error -2
>>> ath10k_pci 0000:3a:00.0: Direct firmware load for
>>> ath10k/cal-pci-0000:3a:00.0.bin failed with error -2
>> Do they have anything to do with this? Hardware is
>
> This error message is confusing since QCA6174 is not supporting
> pre-calibration feature, this reminds me that we need to clean this
> up.

These warnings come up again because of this commit:

c0cc00f250e1 ath10k: activate user space firmware loading again

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=3Da=
th-next&id=3Dc0cc00f250e19c717fc9cdbdb7f55aaa569c7498

We really need a function like request_firmware_nowarn() which would not
print a warning everytime a file is not found. It just confuses the
users and make them falsely believe that's the reason of their problems.

--=20
Kalle Valo=
