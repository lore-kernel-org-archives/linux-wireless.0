Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41412 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab2FYTXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 15:23:47 -0400
Cc: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	"Rajkumar Manoharan" <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20456.40340.61005.543469@gargle.gargle.HOWL> (sfid-20120625_212351_716528_9439966A)
Date: Mon, 25 Jun 2012 22:49:16 +0530
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Subject: [PATCH v3 01/10] ath9k_hw: Add register definitions for WoW support
In-Reply-To: <1340633579-7514-2-git-send-email-mohammed@qca.qualcomm.com>
References: <1340633579-7514-1-git-send-email-mohammed@qca.qualcomm.com>
	<1340633579-7514-2-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> 
> *MAC WoW registers
> 
> back-off shift, MAC interrupt enable, magic packet enable,
> pattern match enable, aifs, slot wait period, keep alive
> frame failure count, beacon fail enable, beacon timeout,
> keep alive timeout, auto keep alive disable,
> keep alive fail disable and their corresponding
> status registers. keep alive frame delay,
> pattern end/byte offsets, transmit buffers for
> keep alive frames and storing the user patterns
> 
> *Power Management Control registers
> 
> pme_d3cold_vaux, host_pme_enable, aux_pwr_detect,
> power_state_mask, wow_pme_clear

The commit log could be trimmed to just say "various WoW registers".

> +/* AR_WOW_PATTERN register values */
> +#define AR_WOW_BACK_OFF_SHIFT(x)	((x & 0xf) << 28) /* in usecs */
> +#define AR_WOW_MAC_INTR_EN		0x00040000
> +#define AR_WOW_MAGIC_EN			0x00010000
> +#define AR_WOW_PATTERN_EN(x)		(x & 0xff)
> +#define AR_WOW_PAT_FOUND_SHIFT	8
> +#define AR_WOW_PATTERN_FOUND(x)		(x & (0xff << AR_WOW_PAT_FOUND_SHIFT))
> +#define AR_WOW_PATTERN_FOUND_MASK	((0xff) << AR_WOW_PAT_FOUND_SHIFT)
> +#define AR_WOW_MAGIC_PAT_FOUND		0x00020000
> +#define AR_WOW_MAC_INTR			0x00080000
> +#define AR_WOW_KEEP_ALIVE_FAIL		0x00100000
> +#define AR_WOW_BEACON_FAIL		0x00200000
> +
> +#define AR_WOW_STATUS(x)		(x & (AR_WOW_PATTERN_FOUND_MASK | \
> +					      AR_WOW_MAGIC_PAT_FOUND	| \
> +					      AR_WOW_KEEP_ALIVE_FAIL	| \
> +					      AR_WOW_BEACON_FAIL))
> +#define AR_WOW_CLEAR_EVENTS(x)		(x & ~(AR_WOW_PATTERN_EN(0xff) | \
> +					       AR_WOW_MAGIC_EN | \
> +					       AR_WOW_MAC_INTR_EN | \
> +					       AR_WOW_BEACON_FAIL | \
> +					       AR_WOW_KEEP_ALIVE_FAIL))
> +

Indentation is off in many places, please fix it.

Sujith
