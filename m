Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f178.google.com ([209.85.161.178]:33492 "EHLO
        mail-yw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935120AbcLTQOF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Dec 2016 11:14:05 -0500
Received: by mail-yw0-f178.google.com with SMTP id r204so84416397ywb.0
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2016 08:14:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161219223504.ttwayzpfvdumgouu@rob-hp-laptop>
References: <1481841044-4314-1-git-send-email-glansberry@gmail.com>
 <1481841044-4314-2-git-send-email-glansberry@gmail.com> <20161219223504.ttwayzpfvdumgouu@rob-hp-laptop>
From: Geoff Lansberry <geoff@kuvee.com>
Date: Tue, 20 Dec 2016 11:13:23 -0500
Message-ID: <CAO7Z3WLC7J+JzmtArOc-ZUNoLGeMX6s=1XQbzwB1zx1U3yTX2Q@mail.gmail.com> (sfid-20161220_171426_677610_7B823395)
Subject: Re: [PATCH 2/3] NFC: trf7970a: Add device tree option of 1.8 Volt IO voltage
To: Rob Herring <robh@kernel.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
        Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
        Samuel Ortiz <sameo@linux.intel.com>, mark.rutland@arm.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Greer <mgreer@animalcreek.com>,
        Justin Bronder <justin@kuvee.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 19, 2016 at 5:35 PM, Rob Herring <robh@kernel.org> wrote:
> On Thu, Dec 15, 2016 at 05:30:43PM -0500, Geoff Lansberry wrote:
>> From: Geoff Lansberry <geoff@kuvee.com>
>>
>> ---
>>  Documentation/devicetree/bindings/net/nfc/trf7970a.txt |  2 ++
>>  drivers/nfc/trf7970a.c                                 | 13 ++++++++++++-
>>  2 files changed, 14 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
>> index 9dda879..208f045 100644
>> --- a/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
>> +++ b/Documentation/devicetree/bindings/net/nfc/trf7970a.txt
>> @@ -21,6 +21,7 @@ Optional SoC Specific Properties:
>>  - t5t-rmb-extra-byte-quirk: Specify that the trf7970a has the erratum
>>    where an extra byte is returned by Read Multiple Block commands issued
>>    to Type 5 tags.
>> +- vdd_io_1v8: Set to specify that the trf7970a io voltage should be set to 1.8V
>
> Use the regulator binding and provide a fixed 1.8V supply.
>
>>  - crystal_27mhz: Set to specify that the input frequency to the trf7970a is 27.12MHz
>>
>>
>> @@ -45,6 +46,7 @@ Example (for ARM-based BeagleBone with TRF7970A on SPI1):
>>               irq-status-read-quirk;
>>               en2-rf-quirk;
>>               t5t-rmb-extra-byte-quirk;
>> +             vdd_io_1v8;
>>               crystal_27mhz;
>>               status = "okay";
>>       };

Rob - using the regulator binding is new to me, but I've given it a
shot and just sent you another set of patches for your inspection.
Please let me know if this is what you had in mind.

Geoff
