Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:63057 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBMTNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 14:13:40 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: implement drv_get_tsf for ibss merging
References: <1392197844-1223-1-git-send-email-yeohchunyeow@gmail.com>
Date: Thu, 13 Feb 2014 21:13:35 +0200
In-Reply-To: <1392197844-1223-1-git-send-email-yeohchunyeow@gmail.com>
	(Chun-Yeow Yeoh's message of "Wed, 12 Feb 2014 17:37:24 +0800")
Message-ID: <87r4767rmo.fsf@kamboji.qca.qualcomm.com> (sfid-20140213_201344_234246_7DB47ED1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chun-Yeow Yeoh <yeohchunyeow@gmail.com> writes:

> Implement the get TSF by simply returning 0 so that IBSS
> merging is happening. Otherwise, IBSS nodes that have similar
> SSID naming won't merge. This is simply fooling the mac80211
> that the TSF in the received beacon is higher than the local TSF.
>
> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>

Yeah, this extremely ugly but don't really know any better way to handle
this now.

> +static u64 ath10k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
> +{
> +	struct ath10k *ar = hw->priv;
> +	u64 tsf;
> +
> +	mutex_lock(&ar->conf_mutex);
> +	/* FIXME: Return 0 for time being. Need to figure out whether FW has
> +	 * the API to fetch 64-bit TSF
> +	 */
> +	tsf = 0;
> +	mutex_unlock(&ar->conf_mutex);
> +
> +	return tsf;
> +}

But why do you need to take conf_mutex? Isn't this enough:

+static u64 ath10k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
+{
+       /*
+        * FIXME: Return 0 for time being. Need to figure out whether FW
+        * has the API to fetch 64-bit TSF
+        */
+
+       return 0;
+}

-- 
Kalle Valo
