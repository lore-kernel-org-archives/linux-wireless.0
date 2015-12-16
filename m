Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:39026 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbbLPS1n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 13:27:43 -0500
Subject: Re: [PATCH] ath10k: add modparam 'hw_csum' to make HW checksum
 configurable
To: Peter Oh <poh@qca.qualcomm.com>, ath10k@lists.infradead.org
References: <1450290051-15593-1-git-send-email-poh@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <5671AD10.70004@openwrt.org> (sfid-20151216_192746_585349_FDE7A89E)
Date: Wed, 16 Dec 2015 19:27:28 +0100
MIME-Version: 1.0
In-Reply-To: <1450290051-15593-1-git-send-email-poh@qca.qualcomm.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2015-12-16 19:20, Peter Oh wrote:
> Some hardwares such as QCA988X and QCA99X0 doesn't have
> capability of checksum offload when frame formats are not
> suitable for it such as Mesh frame.
> Hence add a module parameter, hw_csum, to make checksum offload
> configurable during module registration time.
> 
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>
How about instead of inventing yet another crappy module parameter, you
call skb_checksum_help() in the driver in cases where the hardware is
unable to offload the checksum calculation.

That way the user has to worry about less driver specific hackery ;)

- Felix
