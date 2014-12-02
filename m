Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:1495 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaLBIsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 03:48:53 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3 2/7] ath10k: add ATH10K_FW_IE_WMI_OP_VERSION
References: <20141201144400.18248.62714.stgit@potku.adurom.net>
	<20141201144507.18248.9856.stgit@potku.adurom.net>
	<CA+BoTQ=mx2PSX2uDKrN6pk+YN0e8s8Q1xGZpe0yG-4rT+Hn25Q@mail.gmail.com>
Date: Tue, 2 Dec 2014 10:48:46 +0200
In-Reply-To: <CA+BoTQ=mx2PSX2uDKrN6pk+YN0e8s8Q1xGZpe0yG-4rT+Hn25Q@mail.gmail.com>
	(Michal Kazior's message of "Tue, 2 Dec 2014 09:28:34 +0100")
Message-ID: <8761duphch.fsf@kamboji.qca.qualcomm.com> (sfid-20141202_094856_215644_61C2D5D6)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 1 December 2014 at 15:45, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> [...]
>> diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
>> index 514c219263a5..92b04fe73151 100644
>> --- a/drivers/net/wireless/ath/ath10k/core.h
>> +++ b/drivers/net/wireless/ath/ath10k/core.h
>> @@ -120,6 +120,7 @@ struct ath10k_mem_chunk {
>>  };
>>
>>  struct ath10k_wmi {
>> +       unsigned int op_version;
>
> I wonder - can't we have this as `enum ath10k_fw_wmi_op_version op_version;` ?

Oh yes, I was even planning to change it but apparently forgot. Will fix
in v4.

>> @@ -378,8 +379,9 @@ enum ath10k_fw_features {
>>         /* Firmware does not support P2P */
>>         ATH10K_FW_FEATURE_NO_P2P = 3,
>>
>> -       /* Firmware 10.2 feature bit. The ATH10K_FW_FEATURE_WMI_10X feature bit
>> -        * is required to be set as well.
>> +       /* Firmware 10.2 feature bit. The ATH10K_FW_FEATURE_WMI_10X feature
>> +        * bit is required to be set as well. Deprecated, don't use in new
>> +        * code.
>
> Just out of curiosity - any plans how long this is going to be
> depracated until removed/replaced?

So there are two parts:

1) In the driver we should not use these deprated flags with new code,
   and preferably remove existing uses bit by bit. But for backwards
   compatibility we will keep the flags in
   ath10k_core_init_firmware_features() so that we can set correct
   wmi.op_version when using firmware images which don't have
   ATH10K_FW_IE_WMI_OP_VERSION.

2) In firmware images we will continue use the deprecated flags with
   main, 10.1 and 10.2 firmware branches, at least for the time being.
   This makes it possible to have new firmware releases working on older
   drivers.

>> diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
>> index dfedfd0e0f34..04aaf9af3ca0 100644
>> --- a/drivers/net/wireless/ath/ath10k/hw.h
>> +++ b/drivers/net/wireless/ath/ath10k/hw.h
>> @@ -58,6 +58,16 @@ enum ath10k_fw_ie_type {
>>         ATH10K_FW_IE_FEATURES = 2,
>>         ATH10K_FW_IE_FW_IMAGE = 3,
>>         ATH10K_FW_IE_OTP_IMAGE = 4,
>> +
>> +       /* WMI "operations" interface version, 32 bit value. Supported from
>> +        * FW API 4 and above. */
>> +       ATH10K_FW_IE_WMI_OP_VERSION = 5,
>
> Hmm.. shouldn't we bump up the firmware filename from -3 to -4 and try
> loading 4..3..2..1?

I was thinking that we add FW API 4 only once we have all necessary
changes for the new hw. For example, in case we need HTT changes as
well.

-- 
Kalle Valo
