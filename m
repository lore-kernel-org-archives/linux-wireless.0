Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38032 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754622Ab1EFTIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 15:08:13 -0400
Received: by qyg14 with SMTP id 14so2823198qyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 06 May 2011 12:08:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTimZvffq8-wuz8h4Wh=cvNDKT1+mvQ@mail.gmail.com>
References: <4dc445d8.qNuBQj9x5elLlNec%Larry.Finger@lwfinger.net> <BANLkTimZvffq8-wuz8h4Wh=cvNDKT1+mvQ@mail.gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Fri, 6 May 2011 21:07:53 +0200
Message-ID: <BANLkTin84sLtVpFHi9pa8_UAtSeqmAYYiQ@mail.gmail.com> (sfid-20110506_210816_710734_6DE8DC0C)
Subject: Re: [PATCH] rtlwifi: rtl8192se: Remove need to disable ASPM
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/6 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Fri, May 6, 2011 at 9:02 PM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
>> From: Chaoming Li <chaoming_li@realsil.com.cn>
>>
>> When this driver was initially submitted, the system would crash unless
>> ASPM was disabled. This problem has been fixed.
>>
>> This patch also adds a printk that outputs the name of the firmware
>> file that is used.
>>
>> Signed-off-by: Chaoming_Li <chaoming_li@realsil.com.cn>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>
>> John,
>>
>> This is 2.6.40 material.
>>
>> Larry
>> ---
>>
>> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
>> ===================================================================
>> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/pci.c
>> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/pci.c
>> @@ -1611,6 +1611,7 @@ static bool _rtl_pci_find_adapter(struct
>>        u16 irqline;
>>        u8 tmp;
>>
>> +       pcipriv->ndis_adapter.pcibridge_vendor = PCI_BRIDGE_VENDOR_UNKNOWN;
>>        venderid = pdev->vendor;
>>        deviceid = pdev->device;
>>        pci_read_config_byte(pdev, 0x8, &revisionid);
>> Index: wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
>> ===================================================================
>> --- wireless-testing-new.orig/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
>> +++ wireless-testing-new/drivers/net/wireless/rtlwifi/rtl8192se/sw.c
>> @@ -58,7 +58,7 @@ static void rtl92s_init_aspm_vars(struct
>>         * 4 - Always Enable ASPM without Clock Req.
>>         * set defult to RTL8192CE:3 RTL8192E:2
>>         * */
>> -       rtlpci->const_pci_aspm = 0; /* changed from 2 due to crashes */
>> +       rtlpci->const_pci_aspm = 2; /* changed from 2 due to crashes */
>
> Remove the comment too, please.
>
>>
>>        /*Setting for PCI-E device */
>>        rtlpci->const_devicepci_aspm_setting = 0x03;
>> @@ -183,6 +183,8 @@ static int rtl92s_init_sw_vars(struct ie
>>                return 1;
>>        }
>>
>> +       printk(KERN_INFO "rtl8192se: Driver for Realtek RTL8192SE/RTL8191SE\n"
>> +              "           Loading firmware %s\n", rtlpriv->cfg->fw_name);
>
> Unrelated change.
>

Oops... ignore this comment, I did not read the commit message in its entirety.

>>        /* request fw */
>>        err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
>>                        rtlpriv->io.dev);
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
>



-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
