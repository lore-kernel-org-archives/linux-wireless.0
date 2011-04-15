Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:33540 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab1DOGhk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 02:37:40 -0400
Received: by pxi2 with SMTP id 2so1393307pxi.10
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 23:37:40 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19879.59459.480384.309998@gargle.gargle.HOWL>
Date: Fri, 15 Apr 2011 12:10:03 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k_htc: Cleanup HTC debugfs
In-Reply-To: <1302848033-7072-2-git-send-email-rmanoharan@atheros.com>
References: <1302848033-7072-1-git-send-email-rmanoharan@atheros.com>
	<1302848033-7072-2-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> +	priv->debug.debugfs_phy = debugfs_create_dir("ath9k_htc",
> +					     priv->hw->wiphy->debugfsdir);

KBUILD_MODNAME can be used.

> +	debugfs_create_file("debug", S_IRUSR, priv->debug.debugfs_phy,
> +				priv, &fops_debug);
>  

S_IWUSR.

>  static void ath9k_deinit_priv(struct ath9k_htc_priv *priv)
>  {
> -	ath9k_htc_exit_debug(priv->ah);
>  	ath9k_hw_deinit(priv->ah);
>  	kfree(priv->ah);
>  	priv->ah = NULL;
> @@ -150,6 +149,10 @@ static void ath9k_deinit_device(struct ath9k_htc_priv *priv)
>  {
>  	struct ieee80211_hw *hw = priv->hw;
>  
> +	if (priv->debug.debugfs_phy) {
> +		debugfs_remove_recursive(priv->debug.debugfs_phy);
> +		priv->debug.debugfs_phy = NULL;
> +	}

It would be consistent to have this chunk of code in ath9k_htc_exit_debug().

Sujith
