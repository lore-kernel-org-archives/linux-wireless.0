Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:9731 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754745AbZH0CJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 22:09:34 -0400
Subject: Re: [PATCH 4/4] ath5k: add hardware CCMP encyption support
From: Pavel Roskin <proski@gnu.org>
To: Bob Copeland <me@bobcopeland.com>
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <1251169233-24169-5-git-send-email-me@bobcopeland.com>
References: <1251169233-24169-1-git-send-email-me@bobcopeland.com>
	 <1251169233-24169-5-git-send-email-me@bobcopeland.com>
Content-Type: text/plain
Date: Wed, 26 Aug 2009 22:09:31 -0400
Message-Id: <1251338971.17295.17.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-08-24 at 23:00 -0400, Bob Copeland wrote:
> +	ah->ah_aes_support =
> +		(ee->ee_version >= AR5K_EEPROM_VERSION_5_0 &&
> +		 !AR5K_EEPROM_AES_DIS(ee->ee_misc5) &&
> +		 (ah->ah_mac_version > (AR5K_SREV_AR5212 >> 4) ||
> +		  (ah->ah_mac_version == (AR5K_SREV_AR5212 >> 4) &&
> +		   ah->ah_mac_revision >= (AR5K_SREV_AR5211 >> 4))));

The above use of ah->ah_mac_revision is clearly incorrect.  You are
comparing a revision with a symbol for a version.

I suggest that you use ah_mac_srev instead.  Before this patch,
ah_mac_revision was a write-only variable and was a good candidate for
removal.

The last three quoted lines are equivalent to (ah->ah_mac_srev >= 0x54)

-- 
Regards,
Pavel Roskin
