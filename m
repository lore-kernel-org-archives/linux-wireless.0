Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33804 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945031AbcJaRJ7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Oct 2016 13:09:59 -0400
MIME-Version: 1.0
Reply-To: rajatxjain@gmail.com
In-Reply-To: <20161030204131.pwfjqekpwd6nr3gb@rob-hp-laptop>
References: <1477070156-109965-1-git-send-email-rajatja@google.com>
 <1477084869-15612-1-git-send-email-rajatja@google.com> <20161030204131.pwfjqekpwd6nr3gb@rob-hp-laptop>
From: Rajat Jain <rajatxjain@gmail.com>
Date: Mon, 31 Oct 2016 10:09:57 -0700
Message-ID: <CAA93t1pOffe6F_g_jm2h7=rGhnvrsdVnuiBuc8pgoqWQM8EJvg@mail.gmail.com> (sfid-20161031_181007_916303_901FB5CA)
Subject: Re: [PATCH v6] mwifiex: parse device tree node for PCIe
To: Rob Herring <robh@kernel.org>
Cc: Rajat Jain <rajatja@google.com>, linux-wireless@vger.kernel.org,
        devicetree@vger.kernel.org, Xinming Hu <huxm@marvell.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Brian Norris <briannorris@google.com>,
        Kalle Valo <kvalo@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 30, 2016 at 1:41 PM, Rob Herring <robh@kernel.org> wrote:
> On Fri, Oct 21, 2016 at 02:21:09PM -0700, Rajat Jain wrote:
>> From: Xinming Hu <huxm@marvell.com>
>>
>> This patch derives device tree node from pcie bus layer framework, and
>> fixes a minor memory leak in mwifiex_pcie_probe() (in failure path).
>> Device tree bindings file has been renamed(marvell-sd8xxx.txt ->
>> marvell-8xxx.txt) to accommodate PCIe changes.
>>
>> Signed-off-by: Xinming Hu <huxm@marvell.com>
>> Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
>> Signed-off-by: Rajat Jain <rajatja@google.com>
>> Reviewed-by: Brian Norris <briannorris@chromium.org>
>> ---
>> v2: Included vendor and product IDs in compatible strings for PCIe
>> chipsets(Rob Herring)
>> v3: Patch is created using -M option so that it will only include diff of
>> original and renamed files(Rob Herring)
>> Resend v3: Resending the patch because I missed to include device tree mailing
>> while sending v3.
>> v4: Fix error handling, also move-on even if no device tree node is present.
>> v5: Update commit log to include memory leak, return -EINVAL instead of -1.
>> v6: Remove an unnecessary error print, fix typo in commit log
>>
>>  .../{marvell-sd8xxx.txt => marvell-8xxx.txt}       |  8 +++--
>>  drivers/net/wireless/marvell/mwifiex/pcie.c        | 36 +++++++++++++++++++---
>>  drivers/net/wireless/marvell/mwifiex/sta_cmd.c     |  3 +-
>>  3 files changed, 39 insertions(+), 8 deletions(-)
>>  rename Documentation/devicetree/bindings/net/wireless/{marvell-sd8xxx.txt => marvell-8xxx.txt} (91%)
>>
>> diff --git a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
>> similarity index 91%
>> rename from Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
>> rename to Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
>> index c421aba..dfe5f8e 100644
>> --- a/Documentation/devicetree/bindings/net/wireless/marvell-sd8xxx.txt
>> +++ b/Documentation/devicetree/bindings/net/wireless/marvell-8xxx.txt
>> @@ -1,8 +1,8 @@
>> -Marvell 8897/8997 (sd8897/sd8997) SDIO devices
>> +Marvell 8897/8997 (sd8897/sd8997/pcie8997) SDIO/PCIE devices
>>  ------
>>
>> -This node provides properties for controlling the marvell sdio wireless device.
>> -The node is expected to be specified as a child node to the SDIO controller that
>> +This node provides properties for controlling the marvell sdio/pcie wireless device.
>
> s/marvell/Marvell/
> s/sdio\/pcie/SDIO\/PCIE/
>
>> +The node is expected to be specified as a child node to the SDIO/PCIE controller that
>>  connects the device to the system.
>>
>>  Required properties:
>> @@ -10,6 +10,8 @@ Required properties:
>>    - compatible : should be one of the following:
>>       * "marvell,sd8897"
>>       * "marvell,sd8997"
>> +     * "pci11ab,2b42"
>> +     * "pci1b4b,2b42"
>

Hi Rob,

> I think I already said this, but you have the vendor and product IDs
> reversed.

Actually Marvell has 2 vendor IDs assigned to it. In include/linux/pci_ids.h:

#define PCI_VENDOR_ID_MARVELL           0x11ab
#define PCI_VENDOR_ID_MARVELL_EXT       0x1b4b

So in this case the compatible property describes a single product ID,
with both possible vendor IDs.

Thanks,

Rajat



>
> Rob
