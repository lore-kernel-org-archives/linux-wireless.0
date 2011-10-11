Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5597 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977Ab1JKL0D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 07:26:03 -0400
Message-ID: <4E942747.8050906@qca.qualcomm.com> (sfid-20111011_132608_475647_E9F72408)
Date: Tue, 11 Oct 2011 14:23:51 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix null skb dereference in ath6kl_rx()
References: <20111006113232.24700.12168.stgit@localhost6.localdomain6>
In-Reply-To: <20111006113232.24700.12168.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/06/2011 02:32 PM, Kalle Valo wrote:
> smatch found that skb might be null in some cases in ath6kl_rx():
> 
> ath6kl/txrx.c +1252 ath6kl_rx(222) error: potential null derefence 'skb'.
> 
> This will happen when ath6kl is in AP mode and two clients send traffic
> to each other.

Applied to ath6kl.git.

Kalle
