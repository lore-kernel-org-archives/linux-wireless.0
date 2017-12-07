Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:64067 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753728AbdLGPFG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 10:05:06 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rakesh Pillai <pillair@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Govind Singh <govinds@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 1/4] ath10k: WMI: modify svc bitmap parsing for wcn3990
Date: Thu, 7 Dec 2017 15:04:55 +0000
Message-ID: <87y3metw8f.fsf@kamboji.qca.qualcomm.com> (sfid-20171207_160511_183800_11B6488E)
References: <1512214248-17127-1-git-send-email-pillair@qti.qualcomm.com>
        <1512214248-17127-2-git-send-email-pillair@qti.qualcomm.com>
In-Reply-To: <1512214248-17127-2-git-send-email-pillair@qti.qualcomm.com>
        (Rakesh Pillai's message of "Sat, 2 Dec 2017 17:00:45 +0530")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakesh Pillai <pillair@qti.qualcomm.com> writes:

> Due to the limitation of wmi tlv parsing logic, if there are
> two parameters in a wmi event with same tlv tag, we can get only
> the last value, as it overwrites the prev value of the same tlv tag.
>
> The service ready event in wcn3990 contains two parameters of the
> same tag UINT32, due to which the svc bitmap is overwritten with the
> DBS support parameter.
>
> Refactor the service ready event parsing to allow parsing two tlv
> of the same tag UINT32 for wcn3990.
>
> Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
> Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>

ath10k-check found a warning in this patch:

drivers/net/wireless/ath/ath10k/wmi-tlv.c:981: braces {} are not necessary =
for single statement blocks

--=20
Kalle Valo=
