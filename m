Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:51723 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab2GWQoc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jul 2012 12:44:32 -0400
Received: by gglu4 with SMTP id u4so5662613ggl.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Jul 2012 09:44:31 -0700 (PDT)
Date: Mon, 23 Jul 2012 12:42:50 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
Cc: linville@tuxdriver.com, jirislaby@gmail.com,
	johannes.berg@intel.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, nbd@nbd.name
Subject: Re: [ath5k-devel] [PATCH 2/2] ath5k: fix phy_init() to respect
 user txpower changes
Message-ID: <20120723164250.GA11893@localhost> (sfid-20120723_184435_855782_16932E51)
References: <1343059275-49590-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
 <1343059275-49590-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1343059275-49590-3-git-send-email-thomas@net.t-labs.tu-berlin.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 23, 2012 at 06:01:15PM +0200, Thomas Huehn wrote:
>  	/* Setup rate power table */
> -	ath5k_setup_rate_powertable(ah, txpower, &rate_info, ee_mode);
> +	ath5k_setup_rate_powertable(ah, ah->ah_txpower.txp_user_pwr, &rate_info, ee_mode);

txpower used to be .5 dB units -- is it still?

> -	ret = ath5k_hw_txpower(ah, channel, ah->ah_txpower.txp_cur_pwr ?
> -			ah->ah_txpower.txp_cur_pwr / 2 : AR5K_TUNE_MAX_TXPOWER);
> +	ret = ath5k_hw_txpower(ah, channel);
> +

Did this / 2 move elsewhere or was it wrong before?  Is txp_cur_pwr still
used for anything?

-- 
Bob Copeland %% www.bobcopeland.com
