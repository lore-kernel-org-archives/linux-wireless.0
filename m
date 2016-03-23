Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64264 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbcCWLnv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Mar 2016 07:43:51 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Rob Herring <robh@kernel.org>
CC: Raja Mani <rmani@qti.qualcomm.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH] dt: bindings: add new dt entry for pre calibration in
 qcom,ath10k.txt
Date: Wed, 23 Mar 2016 11:43:45 +0000
Message-ID: <87twjxfmhb.fsf@kamboji.qca.qualcomm.com> (sfid-20160323_124416_760657_099B5CA6)
References: <1457604724-14378-1-git-send-email-rmani@qti.qualcomm.com>
	<20160318161823.GA5558@rob-hp-laptop>
In-Reply-To: <20160318161823.GA5558@rob-hp-laptop> (Rob Herring's message of
	"Fri, 18 Mar 2016 11:18:23 -0500")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rob Herring <robh@kernel.org> writes:

> On Thu, Mar 10, 2016 at 03:42:04PM +0530, Raja Mani wrote:
>> There two things done in this patch,
>> 
>> 1) Existing device tree entry 'qcom,ath10k-calibration-data' carries
>>    not only calibration data, it carries board specific data too.
>>    So, make appropriate update in doc.
>> 
>> 2) ipq4019 wifi needs new devie tree entry to carry calibration
>>    data alone (called pre cal data, it doesn't include any other info).
>>    Using 'qcom,ath10k-calibration-data' for ipq4019 would alter
>>    the purpose of it. Hence, add new device tree entry called
>>    'qcom,ath10k-pre-calibration-data' to carry only pre calibration data.
>> 
>> Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
>> ---
>> 
>> Below patches covers the corresponding changes in the ath10k driver.
>> It's posted separately to ath10k and linux-wireless mailing list.
>
> Generally the series should be posted together. The rest should not be 
> merged until this patch is accepted.

I'll merge them together, this as the first patch.

>>   1) ath10k: pass cal data location as an argument to ath10k_download_cal_{file|dt}
>>   2) ath10k: move cal data len to hw_params
>>   3) ath10k: incorporate qca4019 cal data download sequence
>> 
>>  .../bindings/net/wireless/qcom,ath10k.txt          | 23 +++++++++++++++-------
>>  1 file changed, 16 insertions(+), 7 deletions(-)
>
> Acked-by: Rob Herring <robh@kernel.org>

Thanks.

-- 
Kalle Valo