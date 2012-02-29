Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:38418 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965490Ab2B2SVH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 13:21:07 -0500
Message-ID: <1330539665.13689.9.camel@joe2Laptop> (sfid-20120229_192111_511697_59F5ED83)
Subject: Re: [PATCH 00/12] ath6kl: checkpatch fixes
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 29 Feb 2012 10:21:05 -0800
In-Reply-To: <4F4E635A.3060003@qca.qualcomm.com>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
	 <1330537026.13689.1.camel@joe2Laptop> <4F4E635A.3060003@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-29 at 19:41 +0200, Kalle Valo wrote:
> On 02/29/2012 07:37 PM, Joe Perches wrote:
> > On Wed, 2012-02-29 at 19:18 +0200, Kalle Valo wrote:
> >> Here are quite a few checkpatch fixes and other cleanups.
> >>
> >> Especially I would like to people review these two macros, they ended up
> >> a bit too clever and I'm sure there are issues:
> >>
> >> #define ath6kl_bmi_write_hi32(ar, item, val)				\
> >> 	({								\
> >> 		u32 addr;						\
> >> 		__le32 v;						\
> >> 									\
> >> 		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
> >> 		v = cpu_to_le32(val);					\
> >> 		ath6kl_bmi_write(ar, addr, (u8 *) &v, sizeof(v));	\
> >> 	})
> >>
> >> #define ath6kl_bmi_read_hi32(ar, item, val)				\
> >> 	({								\
> >> 		u32 addr, *check_type = val;				\
> >> 		__le32 tmp;						\
> >> 		int ret;						\
> >> 									\
> >> 		(void) (check_type == val);				\
> >> 		addr = ath6kl_get_hi_item_addr(ar, HI_ITEM(item));	\
> >> 		ret = ath6kl_bmi_read(ar, addr, (u8 *) &tmp, 4);	\
> >> 		*val = le32_to_cpu(tmp);				\
> >> 		ret;							\
> >> 	})
> > 
> > Why not just make these functions?
> 
> Because of the HI_ITEM() macro I can't pass the item parameter to a
> function:
> 
> #define HI_ITEM(item)  offsetof(struct host_interest, item)

Perhaps something like:
void _ath6kl_bmi_write_hi32(struct ath6kl ar, size_t offset, u32 *val)
{
	u32 addr;
	__le32 v;

	addr = ath6kl_get_hi_item_addr(ar, offset);
	v = cpu_to_le32(*val);
	ath6kl_bmi_write(ar, addr, (u8 *)&v, sizeof(v));
}

#define ath6kl_bmi_write_hi32(ar, item, val)		\
	_ath6kl_bmi_write_hi32(ar, HI_ITEM(item), &(val))

etc...


