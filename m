Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36218 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1DOHGj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 03:06:39 -0400
Received: by pzk9 with SMTP id 9so823897pzk.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Apr 2011 00:06:39 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19879.61197.320878.312101@gargle.gargle.HOWL>
Date: Fri, 15 Apr 2011 12:39:01 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 2/2] ath9k_htc: Cleanup HTC debugfs
In-Reply-To: <1302850733-23388-2-git-send-email-rmanoharan@atheros.com>
References: <1302850733-23388-1-git-send-email-rmanoharan@atheros.com>
	<1302850733-23388-2-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> +	if (priv->debug.debugfs_phy) {
> +		debugfs_remove_recursive(priv->debug.debugfs_phy);
> +		priv->debug.debugfs_phy = NULL;
> +	}

Any reason why this is not in ath9k_htc_exit_debug() ?
It doesn't matter much, but it does make the code more consistent...

Sujith
