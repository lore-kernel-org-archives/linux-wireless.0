Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42692 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978Ab3LQUo4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:44:56 -0500
Message-ID: <52B0B7BC.9020307@openwrt.org> (sfid-20131217_214638_477548_126D96ED)
Date: Tue, 17 Dec 2013 21:44:44 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 4/4] ath9k: Fix AR9330 external reset
References: <1387303608-31356-1-git-send-email-sujith@msujith.org> <1387303608-31356-5-git-send-email-sujith@msujith.org>
In-Reply-To: <1387303608-31356-5-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-12-17 19:06, Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> The external SoC reset for AR9330 is required only when a
> beacon stuck is seen, so do not check all the TX queues
> for pending frames.
In my tests, the external reset helped with getting Tx DMA un-stuck as
well, even if no beacons are enabled. I think we should keep the tx
pending check.

- Felix
