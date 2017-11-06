Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:41890 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750715AbdKFI2q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Nov 2017 03:28:46 -0500
Subject: Re: ath10k: Fix reported HT MCS rates with NSS > 1
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
        akolli@qti.qualcomm.com, linux-wireless@vger.kernel.org
References: <20170511090930.18205-1-sven.eckelmann@openmesh.com>
 <0a29ec25ec374a12adbc222af9a7dda1@euamsexm01a.eu.qualcomm.com>
 <94091927-c8a1-2918-749a-dc289686c268@dd-wrt.com>
 <1728147.6Xy77nSgBU@bentobox>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <d27a10b1-6323-ebf0-5c2d-4a9c3b8d978d@dd-wrt.com> (sfid-20171106_092849_996186_8A1F315D)
Date: Mon, 6 Nov 2017 09:28:42 +0100
MIME-Version: 1.0
In-Reply-To: <1728147.6Xy77nSgBU@bentobox>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 06.11.2017 um 09:23 schrieb Sven Eckelmann:
> On Sonntag, 5. November 2017 10:22:22 CET Sebastian Gottschall wrote:
>> the assumption made in this patch is obviously wrong (at least for more
>> recent firmwares and 9984)
>> my log is flooded with messages like
>> [208802.803537] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
>> [208805.108515] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
>> [208821.747621] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
>> [208822.516599] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
>> [208841.257780] ath10k_pci 0001:03:00.0: Invalid VHT mcs 15 peer stats
>>
>>
>> i tested this with the 10.4.3.5-0038 firmware which isnt official
>> published but made from athwlan.bin i got from qca chipcode
> Hm, yes there is most likely something wrong. But not sure whether this patch
> is actually the culprit. It looks to me like this would also be reported the
> same way without the patch. cec17c382140 ("ath10k: add per peer htt tx stats
> support for 10.4") seems to be your problem, right?
>
> This patch only splits WMI_RATE_PREAMBLE_HT & WMI_RATE_PREAMBLE_VHT. And for
> WMI_RATE_PREAMBLE_HT (*not VHT*), it uses a slightly different approach. But
> the WMI_RATE_PREAMBLE_VHT part (which you see in your logs) is basically
> untouched.

then a question follows up. is this check really neccessary?


Sebastian


>
> Kind regards,
> 	Sven


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
