Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3708 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbZFGPIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2009 11:08:36 -0400
Date: Sun, 7 Jun 2009 11:07:55 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Tobias Doerffel <tobias.doerffel@gmail.com>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: added cfg80211 based rfkill
	support
Message-ID: <20090607150755.GA19635@hash.localnet>
References: <1244374833-11987-1-git-send-email-tobias.doerffel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1244374833-11987-1-git-send-email-tobias.doerffel@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 07, 2009 at 01:40:33PM +0200, Tobias Doerffel wrote:
> +/*
> + * Read RFKILL GPIO configuration from eeprom
> + */
> +void ath5k_eeprom_read_rfkill(struct ath5k_hw *ah, u16 *gpio, u8 *polarity)
> +{
> +	u16 data;
> +
> +	ath5k_hw_eeprom_read(ah, AR5K_EEPROM_RFKILL_GPIO_SEL, &data);
> +	*gpio = AR5K_REG_MS(data, AR5K_EEPROM_RFKILL_GPIO_SEL);
> +
> +	ath5k_hw_eeprom_read(ah, AR5K_EEPROM_RFKILL_POLARITY, &data);
> +	*polarity = AR5K_REG_MS(data, AR5K_EEPROM_RFKILL_POLARITY);
> +}

ath5k_eeprom_init_header already reads these values and stuffs them
in the ath5k_eeprom_info struct - you can just use them from there.
Otherwise, mod Johanne's comment, looks great!  Thanks for handling
this.

-- 
Bob Copeland %% www.bobcopeland.com

