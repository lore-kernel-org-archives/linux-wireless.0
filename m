Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:51747 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816Ab2CEQdo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Mar 2012 11:33:44 -0500
Message-ID: <4F54EAE4.3040105@qca.qualcomm.com> (sfid-20120305_173349_240270_9EDE3E39)
Date: Mon, 5 Mar 2012 18:33:40 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 00/12] ath6kl: checkpatch fixes
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>	 <1330537026.13689.1.camel@joe2Laptop> <4F4E635A.3060003@qca.qualcomm.com> <1330539665.13689.9.camel@joe2Laptop>
In-Reply-To: <1330539665.13689.9.camel@joe2Laptop>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/29/2012 08:21 PM, Joe Perches wrote:
> On Wed, 2012-02-29 at 19:41 +0200, Kalle Valo wrote:
>> On 02/29/2012 07:37 PM, Joe Perches wrote:
>>
>>> Why not just make these functions?
>>
>> Because of the HI_ITEM() macro I can't pass the item parameter to a
>> function:
>>
>> #define HI_ITEM(item)  offsetof(struct host_interest, item)
> 
> Perhaps something like:
> void _ath6kl_bmi_write_hi32(struct ath6kl ar, size_t offset, u32 *val)
> {
> 	u32 addr;
> 	__le32 v;
> 
> 	addr = ath6kl_get_hi_item_addr(ar, offset);
> 	v = cpu_to_le32(*val);
> 	ath6kl_bmi_write(ar, addr, (u8 *)&v, sizeof(v));
> }
> 
> #define ath6kl_bmi_write_hi32(ar, item, val)		\
> 	_ath6kl_bmi_write_hi32(ar, HI_ITEM(item), &(val))
> 
> etc...

This is much better, I use this style. Thanks.

Kalle
