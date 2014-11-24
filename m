Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21935 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055AbaKXPMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 10:12:54 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath10k: Fix shared WEP
References: <1416796657-24657-1-git-send-email-sujith@msujith.org>
	<1416796657-24657-2-git-send-email-sujith@msujith.org>
Date: Mon, 24 Nov 2014 17:12:47 +0200
In-Reply-To: <1416796657-24657-2-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Mon, 24 Nov 2014 08:07:35 +0530")
Message-ID: <87lhn0639s.fsf@kamboji.qca.qualcomm.com> (sfid-20141124_161257_584374_8242C1F3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> When static keys are used in shared WEP, when a
> station is associated, message 3 is sent with an
> encrypted payload. But, for subsequent
> authentications that are triggered without a
> deauth, the auth frame is decrypted by the HW.
>
> To handle this, check if the WEP keys have already
> been set for the peer and if so, mark the
> frame as decrypted. This scenario can happen
> when a station changes its default TX key and initiates
> a new authentication sequence.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

[...]

> +bool ath10k_mac_is_peer_wep_key_set(struct ath10k *ar, const u8 *addr,
> +				    u8 keyidx)
> +{
> +	struct ath10k_peer *peer;
> +	int i;
> +
> +	/* We don't know which vdev this peer belongs to,
> +	 * since WMI doesn't give us that information.
> +	 *
> +	 * FIXME: multi-bss needs to be handled.
> +	 */
> +	peer = ath10k_peer_find(ar, 0, addr);
> +	if (!peer)
> +		return false;

This requires that data_lock is taken, right? If yes, can you document
that with lockdep_assert_held(), please?

> +static void ath10k_wmi_handle_wep_reauth(struct ath10k *ar,
> +					 struct sk_buff *skb,
> +					 struct ieee80211_rx_status *status)
> +{
> +	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +	unsigned int hdrlen;
> +	bool peer_key;
> +	u8 *addr, keyidx;

Some kind of comment to document what this workaround is about would be
good to have. For example, the first paragraph from the commit log
sounds perfect.

> +
> +	if (!ieee80211_is_auth(hdr->frame_control) ||
> +	    !ieee80211_has_protected(hdr->frame_control))
> +		return;
> +
> +	hdrlen = ieee80211_hdrlen(hdr->frame_control);
> +	if (skb->len < (hdrlen + IEEE80211_WEP_IV_LEN))
> +		return;
> +
> +	keyidx = skb->data[hdrlen + 3] >> 6;

No magic numbers, please. I didn't find anything for IV internals from
ieee80211.h, not sure if we should add them there or just use ath10k
internal defines.

> +	addr = ieee80211_get_SA(hdr);
> +
> +	spin_lock_bh(&ar->data_lock);
> +	peer_key = ath10k_mac_is_peer_wep_key_set(ar, addr, keyidx);
> +	spin_unlock_bh(&ar->data_lock);
> +
> +	if (peer_key) {
> +		ath10k_dbg(ar, ATH10K_DBG_MAC,
> +			   "wep key present for peer: %pM\n", addr);

"mac wep key present for peer %pM"

-- 
Kalle Valo
