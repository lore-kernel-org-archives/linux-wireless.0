Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:50506 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964986Ab3GCTZb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 15:25:31 -0400
Date: Wed, 3 Jul 2013 21:28:13 +0200
From: Stanislaw Gruszka <stf_xl@wp.pl>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH 4/5] rt2x00: rt2800lib: introduce
 rt2800_eeprom_word_index helper
Message-ID: <20130703192813.GD2245@localhost.localdomain> (sfid-20130703_212535_145542_339A7E3F)
References: <1372269318-30233-1-git-send-email-juhosg@openwrt.org>
 <1372269318-30233-5-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372269318-30233-5-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 26, 2013 at 07:55:17PM +0200, Gabor Juhos wrote:
> Instead of assign the offset value to the
> enum directly use a new helper function to
> convert a rt2800_eeprom_word enum into an
> index of the rt2x00_dev->eeprom array.
> 
> The patch does not change the existing
> behaviour, but makes it possible to add
> support for three-chain devices which are
> using a different EEPROM layout.
> 
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>

I have two nit-picks, but they can be fixed later on top of your current
patches.

> +	if (WARN_ON(word >= EEPROM_WORD_COUNT)) {
> +		rt2x00_warn(rt2x00dev, "invalid EEPROM word %d\n", word);
> +		return 0;
> +	}

Since we take "enum rt2800_eeprom_word" as word argument, it can not
have different values than already listed, so this warning is not needed.

> +	map = rt2800_eeprom_map;
> +	index = map[word];
> +
> +	if (WARN_ON(word != EEPROM_CHIP_ID && index == 0)) {
> +		/* Index 0 is valid only for EEPROM_CHIP_ID.
> +		 * Otherwise it means that the offset of the
> +		 * given word is not initialized in the map,
> +		 * or that the field is not usable on the
> +		 * actual chipset.
> +		 */
> +		rt2x00_warn(rt2x00dev, "invalid access of EEPROM word %d\n",
> +			    word);

I prefer not to use WARN_ON() and rt2x00_warn() together, please use just
one of them, i.e:

WARN_ONCE(word != EEPROM_CHIP_ID && index == 0,
	  "invalid access of EEPROM word %d\n", word);

Stanislaw
