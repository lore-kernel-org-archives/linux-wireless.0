Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:31289 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930Ab2ABOWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 09:22:20 -0500
Message-ID: <4F01BCE7.6040309@qca.qualcomm.com> (sfid-20120102_152224_067956_A55BF779)
Date: Mon, 2 Jan 2012 19:49:19 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: Felix Fietkau <nbd@openwrt.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qca.qualcomm.com>,
	<m.sujith@gmail.com>, <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC] ath9k_hw: make use of ar9003_calc_ptr_chksum
References: <1325509985-11720-1-git-send-email-mohammed@qca.qualcomm.com> <4F01B408.1080900@openwrt.org> <4F01B9CF.2020206@qca.qualcomm.com> <4F01BC85.8050806@openwrt.org>
In-Reply-To: <4F01BC85.8050806@openwrt.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 02 January 2012 07:47 PM, Felix Fietkau wrote:
> On 2012-01-02 3:06 PM, Mohammed Shafi Shajakhan wrote:
>> hi Felix,
>>
>>
>> On Monday 02 January 2012 07:11 PM, Felix Fietkau wrote:
>>> On 2012-01-02 2:13 PM, Mohammed Shafi Shajakhan wrote:
>>>> From: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>>>
>>>> make use of the already available function 'ar9003_calc_ptr_chksum'
>>>> in 'ar9003_set_txdesc'
>>>>
>>>> Signed-off-by: Mohammed Shafi Shajakhan<mohammed@qca.qualcomm.com>
>>> NACK. I intentionally did not use that function to avoid unnecessary
>>> access to uncached memory (for performance reasons).
>>
>> please explain how it effects the performance and will it cause a
>> significant impact
> I don't have any exact numbers anymore, but it was visible enough in the
> oprofile stats to justify a little functional duplication of code.
> Eventually this duplication can go away if I can change the
> ar9003_hw_set_desc_link function to incrementally fix up the checksum
> instead of recalculating it, which would make the code even more efficient.

ok, thanks.

>
> - Felix


-- 
thanks,
shafi
