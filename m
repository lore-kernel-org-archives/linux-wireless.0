Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:35462 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030904Ab2B2RhI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 12:37:08 -0500
Message-ID: <1330537026.13689.1.camel@joe2Laptop> (sfid-20120229_183713_241933_840533D5)
Subject: Re: [PATCH 00/12] ath6kl: checkpatch fixes
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 09:37:06 -0800
In-Reply-To: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-29 at 19:18 +0200, Kalle Valo wrote:
> Here are quite a few checkpatch fixes and other cleanups.
> 
> Especially I would like to people review these two macros, they ended up
> a bit too clever and I'm sure there are issues:
> 
> #define ath6kl_bmi_write_hi32(ar, item, val)				\
> 	({								\
> 		u32 addr;						\
> 		__le32 v;						\
> 									\
> 		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
> 		v = cpu_to_le32(val);					\
> 		ath6kl_bmi_write(ar, addr, (u8 *) &v, sizeof(v));	\
> 	})
> 
> #define ath6kl_bmi_read_hi32(ar, item, val)				\
> 	({								\
> 		u32 addr, *check_type = val;				\
> 		__le32 tmp;						\
> 		int ret;						\
> 									\
> 		(void) (check_type == val);				\
> 		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
> 		ret = ath6kl_bmi_read(ar, addr, (u8 *) &tmp, 4);	\
> 		*val = le32_to_cpu(tmp);				\
> 		ret;							\
> 	})

Why not just make these functions?


