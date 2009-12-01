Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:57215 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752827AbZLAJ2k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 04:28:40 -0500
Subject: Re: Panic in iwl3945 driver
From: Zhu Yi <yi.zhu@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1259620526.6559.34.camel@maxim-laptop>
References: <1259167780.4072.2.camel@maxim-laptop>
	 <1259280022.3991.12.camel@maxim-laptop>
	 <1259596551.4090.0.camel@maxim-laptop>  <1259617333.4653.91.camel@rc-desk>
	 <1259620526.6559.34.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 17:28:44 +0800
Message-ID: <1259659724.12157.110.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-12-01 at 06:35 +0800, Maxim Levitsky wrote:
> 0x000000000001668e <iwl3945_rx_reply_tx+302>:	lea    0x38(%r8),%rdi
> 0x0000000000016692 <iwl3945_rx_reply_tx+306>:	lea    0x4f(%r8),%rax

When this happened, from your previous post, r8 is 0x0 and rdi is 0x38.
Since "info" is %rdi (see below), this means
txq->txb[txq->q.read_ptr].skb[0], aka. r8 is 0.

> 	rate_idx = iwl3945_hwrate_to_plcp_idx(tx_resp->rate);
> 
> 0x0000000000016696 <iwl3945_rx_reply_tx+310>:	movb   $0x0,0x9(%rdi)        <---------- RIP
> 0x000000000001669a <iwl3945_rx_reply_tx+314>:	movb   $0x0,0xc(%rdi)
> 0x000000000001669e <iwl3945_rx_reply_tx+318>:	movb   $0x0,0xf(%rdi)
> 0x00000000000166a2 <iwl3945_rx_reply_tx+322>:	movb   $0x0,0x12(%rdi)
> 0x00000000000166a6 <iwl3945_rx_reply_tx+326>:	movb   $0x0,0x15(%rdi)

This equals to below code in ieee80211_tx_info_clear_status(). "info" is
%rdi, which is 0x38. That matches NULL pointer dereference at 0x41 in
your oops header.

	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++)
                info->status.rates[i].count = 0;

I guess there is a race for txq->q.read_ptr somewhere. Haven't checked
though.

Thanks,
-yi

