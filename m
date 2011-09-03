Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:41947 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752017Ab1ICUVY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Sep 2011 16:21:24 -0400
Subject: Re: [PATCH 3/3] b43: LCN-PHY: load TX gain table on init
From: Joe Perches <joe@perches.com>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
In-Reply-To: <1315076463-11222-4-git-send-email-zajec5@gmail.com>
References: <1315076463-11222-1-git-send-email-zajec5@gmail.com>
	 <1315076463-11222-4-git-send-email-zajec5@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 03 Sep 2011 13:21:22 -0700
Message-ID: <1315081282.1773.19.camel@Joe-Laptop> (sfid-20110903_222131_328570_C91254CA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-09-03 at 21:01 +0200, Rafał Miłecki wrote:
> Values and ops were taken from MMIO dump of wl. struct was copied from
> brcmsmac.
[]
> diff --git a/drivers/net/wireless/b43/tables_phy_lcn.c b/drivers/net/wireless/b43/tables_phy_lcn.c
[]
> +const struct b43_lcntab_tx_gain_tbl_entry
> +		b43_lcntab_tx_gain_tbl_2ghz_ext_pa_rev0[] = {

128 entries follow...

> +	{ 0x03, 0x00, 0x1f, 0x0, 0x48 },
[etc]
> +	{ 0x03, 0x00, 0x01, 0x0, 0x39 },
> +};

> +void b43_phy_lcn_load_tx_gain_tab(struct b43_wldev *dev,
> +			const struct b43_lcntab_tx_gain_tbl_entry *gain_table)

Are there multiple gain tables?

> +{
> +	u32 i;
> +	u32 val;
> +
> +	u16 pa_gain = 0x70;
> +	if (dev->dev->bus_sprom->boardflags_lo & B43_BFL_FEM)
> +		pa_gain = 0x10;
> +
> +	for (i = 0; i < 128; i++) {

Can this be a fixed table and ARRAY_SIZE?



