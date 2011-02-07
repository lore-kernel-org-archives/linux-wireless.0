Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753306Ab1BGPKE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 10:10:04 -0500
Date: Mon, 7 Feb 2011 16:08:58 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>, george0505@realtek.com,
	chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/6] rtlwifi: rtl8192ce: Refactor rtl8192ce/fw
Message-ID: <20110207150857.GE2319@redhat.com>
References: <4d4eec0f.et2vL5g5GiBl8wXm%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4d4eec0f.et2vL5g5GiBl8wXm%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 06, 2011 at 12:44:31PM -0600, Larry Finger wrote:
> +bool _rtl92c_cmd_send_packet(struct ieee80211_hw *hw,
> +			     struct sk_buff *skb)
> +{
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
> +	struct rtl8192_tx_ring *ring;
> +	struct rtl_tx_desc *pdesc;
> +	u8 own;
> +	unsigned long flags;
> +	struct sk_buff *pskb = NULL;
> +
> +	ring = &rtlpci->tx_ring[BEACON_QUEUE];
> +
> +	pskb = __skb_dequeue(&ring->queue);
> +	if (pskb)
> +		kfree_skb(pskb);
> +
> +	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);

I think __skb_dequeue(&ring->queue) should be also protected
by lock.
