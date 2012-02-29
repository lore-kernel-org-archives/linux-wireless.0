Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41971 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532Ab2B2Rm0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:42:26 -0500
Message-ID: <4F4E635A.3060003@qca.qualcomm.com> (sfid-20120229_184231_521073_B508CF0F)
Date: Wed, 29 Feb 2012 19:41:46 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/12] ath6kl: checkpatch fixes
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6> <1330537026.13689.1.camel@joe2Laptop>
In-Reply-To: <1330537026.13689.1.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/29/2012 07:37 PM, Joe Perches wrote:
> On Wed, 2012-02-29 at 19:18 +0200, Kalle Valo wrote:
>> Here are quite a few checkpatch fixes and other cleanups.
>>
>> Especially I would like to people review these two macros, they ended up
>> a bit too clever and I'm sure there are issues:
>>
>> #define ath6kl_bmi_write_hi32(ar, item, val)				\
>> 	({								\
>> 		u32 addr;						\
>> 		__le32 v;						\
>> 									\
>> 		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
>> 		v = cpu_to_le32(val);					\
>> 		ath6kl_bmi_write(ar, addr, (u8 *) &v, sizeof(v));	\
>> 	})
>>
>> #define ath6kl_bmi_read_hi32(ar, item, val)				\
>> 	({								\
>> 		u32 addr, *check_type = val;				\
>> 		__le32 tmp;						\
>> 		int ret;						\
>> 									\
>> 		(void) (check_type == val);				\
>> 		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
>> 		ret = ath6kl_bmi_read(ar, addr, (u8 *) &tmp, 4);	\
>> 		*val = le32_to_cpu(tmp);				\
>> 		ret;							\
>> 	})
> 
> Why not just make these functions?

Because of the HI_ITEM() macro I can't pass the item parameter to a
function:

#define HI_ITEM(item)  offsetof(struct host_interest, item)

I'm planning to change how host interest address are handled at some
point, but I don't have time to do that right now.

Kalle
