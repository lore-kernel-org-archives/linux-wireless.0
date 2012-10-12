Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30263 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980Ab2JLLtH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 07:49:07 -0400
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qca.qualcomm.com>,
	Jin Navy <nhjin@qca.qualcomm.com>
Message-ID: <50780153.8030207@qca.qualcomm.com> (sfid-20121012_134912_633716_F2A3DFA5)
Date: Fri, 12 Oct 2012 14:38:59 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Fix random rx data corruption
References: <1348211724-24243-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1348211724-24243-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/21/2012 10:15 AM, Vasanthakumar Thiagarajan wrote:
> The skb->tail pointer of rx buffers is not adjusted
> after skb->data pointer is aligned to 4-byte, this
> causes random rx data corruption.
> 
> Signed-off-by: Jin Navy <nhjin@qca.qualcomm.com>
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

Thanks, I have applied this.

This alignment issue has created nothing but grief in ath6kl, at some
point we should really fix this properly. For example, the problem
should only happen in TX path, not in RX path.

Kalle
