Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:26071 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932634AbcBAOiG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Feb 2016 09:38:06 -0500
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Coelho, Luciano" <luciano.coelho@intel.com>
Subject: Re: [PATCH 04/31] iwlwifi: pcie: add initial RTPM support for PCI
Date: Mon, 1 Feb 2016 14:38:02 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E9F682B@hasmsx107.ger.corp.intel.com> (sfid-20160201_153811_569449_F2BE5A37)
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
 <1454238386-27032-4-git-send-email-emmanuel.grumbach@intel.com>
 <87y4b4sdqo.fsf@purkki.adurom.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 02/01/2016 04:32 PM, Kalle Valo wrote:
> Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:
>
>> From: Luca Coelho <luciano.coelho@intel.com>
>>
>> Add an initial implementation of runtime power management (RTPM) for
>> PCI devices.  With this patch, RTPM is only used when wifi is off
>> (i.e. the wifi interface is down).  This implementation is behind a
>> new Kconfig flag, IWLWIFI_PCIE_RTPM.
>>
>> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> [...]
>
>> --- a/drivers/net/wireless/intel/iwlwifi/Kconfig
>> +++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
>> @@ -99,6 +99,18 @@ config IWLWIFI_UAPSD
>>  
>>  	  If unsure, say N.
>>  
>> +config IWLWIFI_PCIE_RTPM
>> +       bool "Enable runtime power management mode for PCIe devices"
>> +       depends on IWLMVM && IWLWIFI_PCIE && PM
>> +       default false
>> +       help
>> +         Say Y here to enable runtime power management for PCIe
>> +         devices.  If enabled, the device will go into low power mode
>> +         when idle for a short period of time, allowing for improved
>> +         power saving during runtime.
>> +
>> +	 If unsure, say N.
> I didn't see the new option in menuconfig and then noticed that I can't
> find IWLWIFI_PCIE anywhere. Is that correct?
>

Right... This option is not upstreamed yet...
I'll respin. Sorry...
