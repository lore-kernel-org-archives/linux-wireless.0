Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:42209 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751930AbdKEJWb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Nov 2017 04:22:31 -0500
Subject: Re: ath10k: Fix reported HT MCS rates with NSS > 1
To: Kalle Valo <kvalo@qca.qualcomm.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: ath10k@lists.infradead.org, akolli@qti.qualcomm.com,
        linux-wireless@vger.kernel.org
References: <20170511090930.18205-1-sven.eckelmann@openmesh.com>
 <0a29ec25ec374a12adbc222af9a7dda1@euamsexm01a.eu.qualcomm.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <94091927-c8a1-2918-749a-dc289686c268@dd-wrt.com> (sfid-20171105_102303_494732_4D620DC0)
Date: Sun, 5 Nov 2017 10:22:22 +0100
MIME-Version: 1.0
In-Reply-To: <0a29ec25ec374a12adbc222af9a7dda1@euamsexm01a.eu.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the assumption made in this patch is obviously wrong (at least for more 
recent firmwares and 9984)
my log is flooded with messages like
[208802.803537] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
[208805.108515] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
[208821.747621] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
[208822.516599] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
[208841.257780] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats


i tested this with the 10.4.3.5-0038 firmware which isnt official 
published but made from athwlan.bin i got from qca chipcode

Am 23.05.2017 um 17:28 schrieb Kalle Valo:
> Sven Eckelmann <sven.eckelmann@openmesh.com> wrote:
>> The QCA4019 firmware 10.4-3.2.1-00050 reports only HT MCS rates between
>> 0-9. But 802.11n MCS rates can be larger than that. For example a 2x2
>> device can send with up to MCS 15.
>>
>> The firmware encodes the higher MCS rates using the NSS field. The actual
>> calculation is not documented by QCA but it seems like the NSS field can be
>> mapped for HT rates to following MCS offsets:
>>
>>   * NSS 1: 0
>>   * NSS 2: 8
>>   * NSS 3: 16
>>   * NSS 4: 24
>>
>> This offset therefore has to be added for HT rates before they are stored
>> in the rate_info struct.
>>
>> Fixes: cec17c382140 ("ath10k: add per peer htt tx stats support for 10.4")
>> Signed-off-by: Sven Eckelmann <sven.eckelmann@openmesh.com>
> Patch applied to ath-next branch of ath.git, thanks.
>
> c1dd8016ae02 ath10k: fix reported HT MCS rates with NSS > 1
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
