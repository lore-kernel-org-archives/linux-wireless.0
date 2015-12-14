Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:44021 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932194AbbLNVfI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 16:35:08 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1a8als-0004NL-Ip
	for linux-wireless@vger.kernel.org; Mon, 14 Dec 2015 22:35:04 +0100
Received: from 216.239.45.89 ([216.239.45.89])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 22:35:04 +0100
Received: from kyan by 216.239.45.89 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2015 22:35:04 +0100
To: linux-wireless@vger.kernel.org
From: Kan Yan <kyan@chromium.org>
Subject: Re: [PATCH v7] Add new mac80211 driver mwlwifi.
Date: Mon, 14 Dec 2015 21:32:03 +0000 (UTC)
Message-ID: <loom.20151214T222202-611@post.gmane.org> (sfid-20151214_223513_145601_0F1D8264)
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Lin <dlin@...> writes:

> +static inline struct sk_buff *mwl_tx_do_amsdu(struct mwl_priv *priv,
> +					      int desc_num,
> ...
> +		amsdu_pkts = (struct sk_buff_head *)
> +			kmalloc(sizeof(*amsdu_pkts), GFP_KERNEL);
> +		if (!amsdu_pkts) {

Should GFP_ATOMIC be used here instead of GFP_KERNEL? This function could be
called in interrupt context.

