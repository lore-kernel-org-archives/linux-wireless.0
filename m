Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:42728 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbbAWTPZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2015 14:15:25 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: [v2] brcmfmac: Use put_unaligned_le32
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20150116160613.GA11361@vaishali-Ideapad-Z570>
To: Vaishali Thakkar <vthakkar1994@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	linux-wireless@vger.kernel.org
Message-Id: <20150123191524.90572141D77@smtp.codeaurora.org> (sfid-20150123_201528_510681_9A5D279C)
Date: Fri, 23 Jan 2015 19:15:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> This patch introduces the use of function put_unaligned_le32.
> 
> This is done using Coccinelle and semantic patch used is as follows:
> 
> @a@
> typedef u32, __le32, uint32_t;
> {u32,__le32,uint32_t} e32;
> identifier tmp;
> expression ptr;
> expression y,e;
> type T;
> type T;
> @@
> 
> - tmp = cpu_to_le32(y);
> 
> <+... when != tmp
> (
> - memcpy(ptr, (T)&tmp, \(4\|sizeof(u32)\|sizeof(__le32)\|sizeof(uint32_t)\|sizeof(e32)\));
> + put_unaligned_le32(y,ptr);
> |
> - memcpy(ptr, (T)&tmp, ...);
> + put_unaligned_le32(y,ptr);
> )
> ...+>
> ? tmp = e
> 
> @@ type T; identifier a.tmp; @@
> 
> - T tmp;
> ...when != tmp
> 
> Signed-off-by: Vaishali Thakkar <vthakkar1994@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
