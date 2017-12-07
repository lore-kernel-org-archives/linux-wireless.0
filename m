Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:47830 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754414AbdLGPG7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 10:06:59 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rakesh Pillai <pillair@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Govind Singh <govinds@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] ath10k: WMI: Add management tx by reference
 support over wmi
Date: Thu, 7 Dec 2017 15:06:48 +0000
Message-ID: <87tvx2tw54.fsf@kamboji.qca.qualcomm.com> (sfid-20171207_160709_946376_07E2DFB5)
References: <1512214248-17127-1-git-send-email-pillair@qti.qualcomm.com>
        <1512214248-17127-3-git-send-email-pillair@qti.qualcomm.com>
In-Reply-To: <1512214248-17127-3-git-send-email-pillair@qti.qualcomm.com>
        (Rakesh Pillai's message of "Sat, 2 Dec 2017 17:00:46 +0530")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakesh Pillai <pillair@qti.qualcomm.com> writes:

> HL1.0 firmware branch, used in wcn3990, transmits management
> frames by reference over WMI.
>
> Add support for management tx by reference over WMI.
>
> Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
> Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>

This one has an endian problem:

drivers/net/wireless/ath/ath10k/wmi-tlv.c:2537:22: warning: incorrect type =
in assignment (different base types)
drivers/net/wireless/ath/ath10k/wmi-tlv.c:2537:22:    expected restricted _=
_le32 [usertype] vdev_id
drivers/net/wireless/ath/ath10k/wmi-tlv.c:2537:22:    got unsigned int [uns=
igned] [assigned] [usertype] vdev_id

I recommend running ath10k-check before submission:

https://wireless.wiki.kernel.org/en/users/drivers/ath10k/codingstyle#checki=
ng_code

--=20
Kalle Valo=
