Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1903 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbYJEAh2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Oct 2008 20:37:28 -0400
Date: Sat, 4 Oct 2008 20:37:10 -0400
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 4/5] ath5k: Fix SREV reporting after SREV updates
Message-ID: <20081005003710.GA3222@hash.localnet> (sfid-20081005_023730_429923_DB43D327)
References: <20080928222444.GD21335@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080928222444.GD21335@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 29, 2008 at 01:24:44AM +0300, Nick Kossifidis wrote:
>  * Fix srev reporting during attach
> 
>  Changes-Licensed-under: ISC
>  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>

This now identifies my card as 5414, whereas ath5k used to call it 5424 
(mac srev 0xa3, phy 0x61).  

But, madwifi has:
 #define AR5K_SREV_VER_AR5424     0xa3 /* PCI-E */

It still works so not a major problem, but who's right?

> @@ -396,7 +396,11 @@ ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val)
>  	for (i = 0; i < ARRAY_SIZE(srev_names); i++) {
>  		if (srev_names[i].sr_type != type)
>  			continue;
> -		if ((val & 0xff) < srev_names[i + 1].sr_val) {
> +
> +		if ((val & 0xf0) == srev_names[i].sr_val)
> +			name = srev_names[i].sr_name;
> +
> +		if ((val & 0xff) == srev_names[i].sr_val) {
>  			name = srev_names[i].sr_name;
>  			break;
>  		}
> 

-- 
Bob Copeland %% www.bobcopeland.com

