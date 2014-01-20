Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from AShevkov.infinet.ru ([91.191.225.92]:59447 "EHLO
	ashevkov.infinet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaATGCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jan 2014 01:02:41 -0500
Date: Mon, 20 Jan 2014 12:02:04 +0600
From: Alex Hacker <hacker@epn.ru>
To: Sujith Manoharan <sujith@msujith.org>
Cc: John Linville <linville@tuxdriver.com>,
	ath9k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: [ath9k-devel] [PATCH] ath9k: Fix IQ calibration
Message-ID: <20140120060204.GB5929@infinet.ru> (sfid-20140120_070302_642334_BB708753)
References: <1389686117-9014-1-git-send-email-sujith@msujith.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1389686117-9014-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

On Tue, Jan 14, 2014 at 01:25:17PM +0530, Sujith Manoharan wrote:
> +	if (i2_p_q2_a0_d1 > 0x1000)
> +		i2_p_q2_a0_d1 = -((0x1fff - i2_p_q2_a0_d1) + 1);

While the 'i2_p_q2_a0_d1 = (iq_res[2] & 0xfff)' the condition
'i2_p_q2_a0_d1 > 0x1000' is always false.

Regards,
Alex.
