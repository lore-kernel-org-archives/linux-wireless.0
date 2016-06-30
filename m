Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59320 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853AbcF3Kyr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 06:54:47 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: fix potential null dereference bugs
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1465563164-783-1-git-send-email-me@bobcopeland.com>
To: Bob Copeland <me@bobcopeland.com>
CC: <linux-wireless@vger.kernel.org>,
	Bob Copeland <me@bobcopeland.com>, <ath10k@lists.infradead.org>
Message-ID: <fa78b1942cf2454898cc33b31a253b81@euamsexm01a.eu.qualcomm.com> (sfid-20160630_125501_889191_0FBBA988)
Date: Thu, 30 Jun 2016 12:54:40 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland <me@bobcopeland.com> wrote:
> Smatch warns about a number of cases in ath10k where a pointer is
> null-checked after it has already been dereferenced, in code involving
> ath10k private virtual interface pointers.
> 
> Fix these by making the dereference happen later.
> 
> Addresses the following smatch warnings:
> 
> drivers/net/wireless/ath/ath10k/mac.c:3651 ath10k_mac_txq_init() warn: variable dereferenced before check 'txq' (see line 3649)
> drivers/net/wireless/ath/ath10k/mac.c:3664 ath10k_mac_txq_unref() warn: variable dereferenced before check 'txq' (see line 3659)
> drivers/net/wireless/ath/ath10k/htt_tx.c:70 __ath10k_htt_tx_txq_recalc() warn: variable dereferenced before check 'txq->sta' (see line 52)
> drivers/net/wireless/ath/ath10k/htt_tx.c:740 ath10k_htt_tx_get_vdev_id() warn: variable dereferenced before check 'cb->vif' (see line 736)
> drivers/net/wireless/ath/ath10k/txrx.c:86 ath10k_txrx_tx_unref() warn: variable dereferenced before check 'txq' (see line 84)
> drivers/net/wireless/ath/ath10k/wmi.c:1837 ath10k_wmi_op_gen_mgmt_tx() warn: variable dereferenced before check 'cb->vif' (see line 1825)
> 
> Signed-off-by: Bob Copeland <me@bobcopeland.com>

Thanks, 1 patch applied to ath-next branch of ath.git:

a66cd733a729 ath10k: fix potential null dereference bugs

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9169669/

