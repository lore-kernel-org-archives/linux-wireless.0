Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:40094 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbeBAIgU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Feb 2018 03:36:20 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Amitkumar Karwar <amitkarwar@gmail.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Subject: Re: [v5 7/8] rsi: add module parameter operating mode
References: <1513168977-2121-1-git-send-email-amitkarwar@gmail.com>
        <1513168977-2121-8-git-send-email-amitkarwar@gmail.com>
        <87a7wtmbf0.fsf@purkki.adurom.net>
        <6E3DC959-D3C0-4638-A94B-5F800A3A89DC@holtmann.org>
Date: Thu, 01 Feb 2018 10:36:15 +0200
In-Reply-To: <6E3DC959-D3C0-4638-A94B-5F800A3A89DC@holtmann.org> (Marcel
        Holtmann's message of "Thu, 1 Feb 2018 09:20:39 +0100")
Message-ID: <87efm5m7i8.fsf@kamboji.qca.qualcomm.com> (sfid-20180201_093625_530830_3C0DBA36)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Marcel Holtmann <marcel@holtmann.org> writes:

> Hi Kalle,
>
>>> Operating mode determines the support for other protocols.
>>> This is made as module parameter for better usage.
>>> 
>>> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
>>> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
>>> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
>> 
>> [...]
>> 
>>> +/* Default operating mode is wlan STA + BT */
>>> +static u16 dev_oper_mode = DEV_OPMODE_STA_BT_DUAL;
>>> +module_param(dev_oper_mode, ushort, 0444);
>>> +MODULE_PARM_DESC(dev_oper_mode,
>>> +		 "1[Wi-Fi], 4[BT], 8[BT LE], 5[Wi-Fi STA + BT classic]\n"
>>> +		 "9[Wi-Fi STA + BT LE], 13[Wi-Fi STA + BT classic + BT LE]\n"
>>> +		 "6[AP + BT classic], 14[AP + BT classic + BT LE]");
>> 
>> I really wish that we have nl80211 interface for configuring btcoex. We
>> have been talking about that for years but nobody has implemented it :(
>
> the Bluetooth subsystem and Wireless subsystem can handle that
> perfectly between themselves. Involving userspace is utterly
> pointless. First step should be that the Wireless subsystem has an
> option to inform its actively used frequencies to the Bluetooth
> subsystem. It then could adjust AFP channel mapping.

Yeah, that would be much better.

-- 
Kalle Valo
