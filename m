Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f178.google.com ([209.85.218.178]:55668 "EHLO
	mail-bw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569AbZCJMrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2009 08:47:49 -0400
Received: by bwz26 with SMTP id 26so1558242bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2009 05:47:46 -0700 (PDT)
Message-ID: <49B66170.5000103@gmail.com> (sfid-20090310_134752_163851_643EEE52)
Date: Tue, 10 Mar 2009 13:47:44 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Subject: Re: [PATCH 3/3] ath5k: Add tx power calibration support
References: <20090310103735.GD3341@makis>
In-Reply-To: <20090310103735.GD3341@makis>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10.3.2009 11:37, Nick Kossifidis wrote:
>   * Add tx power calibration support
>   * Add a few tx power limits
>   * Hardcode default power to 12.5dB
>   * Disable TPC for now
...
> diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
> index f7c424d..d9f483b 100644
> --- a/drivers/net/wireless/ath5k/base.c
> +++ b/drivers/net/wireless/ath5k/base.c
> @@ -521,6 +521,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
>   		    IEEE80211_HW_NOISE_DBM;
>
>   	hw->wiphy->interface_modes =
> +		BIT(NL80211_IFTYPE_AP)|
>   		BIT(NL80211_IFTYPE_STATION) |
>   		BIT(NL80211_IFTYPE_ADHOC) |
>   		BIT(NL80211_IFTYPE_MESH_POINT);

Is this a typo or wrongly amended commit :)?
