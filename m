Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13530 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757882AbYBMQzt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 11:55:49 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] ipw2200: le*_add_cpu conversion
Date: Wed, 13 Feb 2008 08:54:48 -0800
Message-ID: <D936D925018D154694D8A362EEB0892003A7F5B9@orsmsx416.amr.corp.intel.com> (sfid-20080213_165556_417797_DB68E026)
In-Reply-To: <1202857582-15450-8-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com> <1202857582-15450-8-git-send-email-marcin.slusarz@gmail.com>
From: "Chatre, Reinette" <reinette.chatre@intel.com>
To: <marcin.slusarz@gmail.com>, "LKML" <linux-kernel@vger.kernel.org>
Cc: "Zhu, Yi" <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, February 12, 2008 3:06 PM,
linux-wireless-owner@vger.kernel.org  wrote:

> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> replace all:
> little_endian_variable =
> cpu_to_leX(leX_to_cpu(little_endian_variable) +
> 					expression_in_cpu_byteorder);
> with:
> 	leX_add_cpu(&little_endian_variable,
> expression_in_cpu_byteorder);
> generated with semantic patch
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Zhu Yi <yi.zhu@intel.com>
> Cc: John W. Linville <linville@tuxdriver.com>
> Cc: linux-wireless@vger.kernel.org
> ---
> drivers/net/wireless/ipw2200.c |    4 +---
> 1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/ipw2200.c
> b/drivers/net/wireless/ipw2200.c
> index 3e6ad7b..5d9854e 100644
> --- a/drivers/net/wireless/ipw2200.c
> +++ b/drivers/net/wireless/ipw2200.c
> @@ -10326,9 +10326,7 @@ static int ipw_tx_skb(struct ipw_priv
> *priv, struct ieee80211_txb *txb,
> 					 remaining_bytes,
> 					 PCI_DMA_TODEVICE));
> 
> -			tfd->u.data.num_chunks =
> -
> cpu_to_le32(le32_to_cpu(tfd->u.data.num_chunks) +
> -					1);
> +			le32_add_cpu(&tfd->u.data.num_chunks, 1);
> 		}
> 	}
> 
> --
> 1.5.3.7

Thanks!

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reinette

