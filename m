Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:33504 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755953Ab2CGShk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 13:37:40 -0500
Message-ID: <1331145456.2140.61.camel@joe2Laptop> (sfid-20120307_193743_634493_F72B115C)
Subject: Re: [PATCH 00/12] ath6kl: checkpatch fixes
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 07 Mar 2012 10:37:36 -0800
In-Reply-To: <4F57A193.3030406@qca.qualcomm.com>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
	 <1330537026.13689.1.camel@joe2Laptop> <4F4E635A.3060003@qca.qualcomm.com>
	 <1330539665.13689.9.camel@joe2Laptop> <4F57A193.3030406@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-03-07 at 19:57 +0200, Kalle Valo wrote:
> On 02/29/2012 08:21 PM, Joe Perches wrote:
> > On Wed, 2012-02-29 at 19:41 +0200, Kalle Valo wrote:
> >> On 02/29/2012 07:37 PM, Joe Perches wrote:
> >>> Why not just make these functions?
> >> Because of the HI_ITEM() macro I can't pass the item parameter to a
> >> function:
> >> #define HI_ITEM(item)  offsetof(struct host_interest, item)
> > Perhaps something like:
> > void _ath6kl_bmi_write_hi32(struct ath6kl ar, size_t offset, u32 *val)
> > {
> > 	u32 addr;
> > 	__le32 v;
> > 
> > 	addr = ath6kl_get_hi_item_addr(ar, offset);
> > 	v = cpu_to_le32(*val);
> > 	ath6kl_bmi_write(ar, addr, (u8 *)&v, sizeof(v));
> > }
> > #define ath6kl_bmi_write_hi32(ar, item, val)		\
> > 	_ath6kl_bmi_write_hi32(ar, HI_ITEM(item), &(val))
> 
> I tried this but actually this ends to a header file dependency hell. I
> don't want to deal with that right now so I have to use the original macros.

No worries.
When your series is stable, maybe I'll play with it.


