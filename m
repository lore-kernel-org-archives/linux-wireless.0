Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49141 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbaKKOYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 09:24:02 -0500
Message-ID: <54621BFF.7080709@openwrt.org> (sfid-20141111_152410_762202_607EA6F9)
Date: Tue, 11 Nov 2014 15:23:59 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>,
	John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 4/6] ath9k: Fix high tx power in multi-chain mode
References: <1415689644-29693-1-git-send-email-sujith@msujith.org> <1415689644-29693-5-git-send-email-sujith@msujith.org>
In-Reply-To: <1415689644-29693-5-git-send-email-sujith@msujith.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2014-11-11 08:07, Sujith Manoharan wrote:
> From: Miaoqing Pan <miaoqing@qca.qualcomm.com>
> 
> For multi-chain chips, if the thermometer is switched off for a chain
> which can be disabled by software(e.g tx_chainmask=0x1), the measured tx
> power is about 5dB higher than target power.
> 
> Set thermometer on for all chains to fix this issue.
That doesn't seem right to me. ah->caps.tx_chainmask is not altered
based on software antenna configuration.

- Felix
