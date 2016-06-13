Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:38279 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbcFMFj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2016 01:39:58 -0400
Received: by mail-wm0-f46.google.com with SMTP id m124so63187511wme.1
        for <linux-wireless@vger.kernel.org>; Sun, 12 Jun 2016 22:39:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1465563164-783-1-git-send-email-me@bobcopeland.com>
References: <1465563164-783-1-git-send-email-me@bobcopeland.com>
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 13 Jun 2016 07:39:56 +0200
Message-ID: <CA+BoTQkg+uea_YzUgrVBPhA8uRxNpd29Kd1y1tvt0a-JyOSLQw@mail.gmail.com> (sfid-20160613_074004_402825_22006851)
Subject: Re: [PATCH] ath10k: fix potential null dereference bugs
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 June 2016 at 14:52, Bob Copeland <me@bobcopeland.com> wrote:
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

FWIW all of these are false positives. I think this was already
pointed out some time ago. The drv_priv stuff is merely an offset (see
how ieee80211_vif and ieee80211_sta are defined) and the according
structure is always checked beforehand.


Michał
