Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49569 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1I0S3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Sep 2011 14:29:09 -0400
Message-ID: <4E8215BF.5040301@qca.qualcomm.com> (sfid-20110927_202913_673632_60AC125A)
Date: Tue, 27 Sep 2011 21:28:15 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix TCP corruption
References: <20110927080008.28000.50462.stgit@localhost6.localdomain6>
In-Reply-To: <20110927080008.28000.50462.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/27/2011 11:00 AM, Kalle Valo wrote:
> From: Jouni Malinen <jouni@qca.qualcomm.com>
> 
> Commit 94e532d1a ("ath6kl: Fix system freeze under heavy data load")
> aligns the skb data without checking if the skb is cloned. Because of
> this ath6kl can corrupt the local TCP stack information that can result
> in TCP retransmission failing and TCP connections stalling.
> 
> To avoid the corruption we need to copy the skb. Now the alignment
> in ath6kl_htc_tx_buf_align() doesn't corrupt TCP packets anymore (and is
> not even used for the cloned skb's that got copied since the alignment
> of the data is handled at the copy time).

Applied.

Kalle
