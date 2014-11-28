Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:32378 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaK1Jy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 04:54:58 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <ath10k@lists.infradead.org>, <devicetree@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, <toshik@chromium.org>
Subject: Re: [PATCH v4 1/2] dt: bindings: add ath10k wireless device
References: <20141127120727.17546.61202.stgit@potku.adurom.net>
	<20141127120856.17546.32014.stgit@potku.adurom.net>
	<3202372.2AaH3c4qv1@wuerfel>
Date: Fri, 28 Nov 2014 11:54:39 +0200
In-Reply-To: <3202372.2AaH3c4qv1@wuerfel> (Arnd Bergmann's message of "Thu, 27
	Nov 2014 13:28:45 +0100")
Message-ID: <87fvd3sl9c.fsf@kamboji.qca.qualcomm.com> (sfid-20141128_105504_926039_9411F874)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> On Thursday 27 November 2014 14:08:56 Kalle Valo wrote:
>> diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> new file mode 100644
>> index 000000000000..edefc26c6204
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath10k.txt
>> @@ -0,0 +1,30 @@
>> +* Qualcomm Atheros ath10k wireless devices
>> +
>> +For ath10k devices the calibration data can be provided through Device
>> +Tree. The node is a child node of the PCI controller.
>> +
>> +Required properties:
>> +-compatible : Should be "qcom,ath10k"
>> +
>> +Optional properties:
>> +- qcom,ath10k-calibration-data : calibration data as an array, the
>> +                                length can vary between hw versions
>> +
>
> Does the device always have a valid mac address in hardware? If not,
> how about listing that as well using the mac-address property?

Right now ath10k does not support that, but in the future we might want
to add mac address as well. We need to do some testing with the firmware
to make sure that we can safely change the "main" address from ath10k.

And because of Virtual AP (mBSSID) feature we actually would need to
provide multiple addresses, not just one. Maybe with addr_mask like
struct wiphy has?

 * @perm_addr: permanent MAC address of this device
 * @addr_mask: If the device supports multiple MAC addresses by masking,
 *	set this to a mask with variable bits set to 1, e.g. if the last
 *	four bits are variable then set it to 00-00-00-00-00-0f. The actual
 *	variable bits shall be determined by the interfaces added, with
 *	interfaces not matching the mask being rejected to be brought up.

	/* permanent MAC address(es) */
	u8 perm_addr[ETH_ALEN];
	u8 addr_mask[ETH_ALEN];

-- 
Kalle Valo
