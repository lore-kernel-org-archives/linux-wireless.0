Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:33583 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731968AbeGaNWK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jul 2018 09:22:10 -0400
Received: by mail-qt0-f193.google.com with SMTP id c15-v6so15498497qtp.0
        for <linux-wireless@vger.kernel.org>; Tue, 31 Jul 2018 04:42:14 -0700 (PDT)
Subject: Re: [PATCH 5/6] qtnfmac: add support for PTA configuration
To: Kalle Valo <kvalo@codeaurora.org>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
References: <20180531091102.28666-1-sergey.matyukevich.os@quantenna.com>
 <20180531091102.28666-6-sergey.matyukevich.os@quantenna.com>
 <87d0v4stqm.fsf@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Andrey Shevchenko <ashevchenko@quantenna.com>,
        Sergei Maksimenko <smaksimenko@quantenna.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B604B14.8080607@broadcom.com> (sfid-20180731_134242_091197_6B35BBF6)
Date: Tue, 31 Jul 2018 13:42:12 +0200
MIME-Version: 1.0
In-Reply-To: <87d0v4stqm.fsf@codeaurora.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7/30/2018 4:06 PM, Kalle Valo wrote:
> Sergey Matyukevich <sergey.matyukevich.os@quantenna.com> writes:
>
>> From: Andrey Shevchenko <ashevchenko@quantenna.com>
>>
>> Implement support for PTA (Packet Traffic Arbitration) configuration.
>> The PTA mechanism is used to coordinate sharing of the medium between
>> WiFi and other 2.4 wireless networks, e.g. Bluetooth or ZigBee.
>>
>> This patch implements core infrastructure and vendor specific commands
>> to control PTA functionality in firmware.
>
> And no description of the actual interface which would have helped with
> the review.
>
> Anyway, the vendor commands are pain and they just make me grumpy. The
> original idea was that upstream drivers should not support them at all,
> later we flexed the rules so that low level hardware specific interfaces
> might be ok, for example we added one in wil6210.
>
> If I would even consider applying a patch which adds a vendor command it
> needs a really good commit log with a proper description of the actual
> interface and good justifications why a generic nl80211 command won't
> work. I don't see anything even remotely close here.
>
> Sorry for being grumpy, I just hate these vendor commands. Especially
> when I see that a generic nl80211 command has not even be consired at
> all.

For what it is worth, looking at part of the patch:

+/**
+ * enum qlink_pta_mode - Packet Traffic Arbiter operating modes
+ *
+ * @QLINK_PTA_MODE_DISABLED: PTA is disabled
+ * @QLINK_PTA_MODE_2_WIRE: enable PTA 2-wire mode
+ */
+enum qlink_pta_mode {
+	QLINK_PTA_MODE_DISABLED = 0,
+	QLINK_PTA_MODE_2_WIRE = 2
+};
+

it smells very much like low-level btcoex. The question is whether this 
needs to be conveyed from user-space or should these be device 
configuration, eg. like DT properties.

Regards,
Arend
