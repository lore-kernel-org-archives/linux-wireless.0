Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57725 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab2HMPm1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2012 11:42:27 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20521.8077.412278.460752@gargle.gargle.HOWL> (sfid-20120813_174230_465101_5086A2E2)
Date: Mon, 13 Aug 2012 21:08:53 +0530
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>
Subject: [RFC 3/3] ath9k_htc: Remove interface combination specific checks
In-Reply-To: <1344871392-6642-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1344871392-6642-1-git-send-email-mohammed@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan wrote:
> -	if (priv->nvifs >= ATH9K_HTC_MAX_VIF) {
> -		mutex_unlock(&priv->mutex);
> -		return -ENOBUFS;
> -	}
> -
> -	if (priv->num_ibss_vif ||
> -	    (priv->nvifs && vif->type == NL80211_IFTYPE_ADHOC)) {
> -		ath_err(common, "IBSS coexistence with other modes is not allowed\n");
> -		mutex_unlock(&priv->mutex);
> -		return -ENOBUFS;
> -	}
> -
> -	if (((vif->type == NL80211_IFTYPE_AP) ||
> -	     (vif->type == NL80211_IFTYPE_ADHOC)) &&
> -	    ((priv->num_ap_vif + priv->num_ibss_vif) >= ATH9K_HTC_MAX_BCN_VIF)) {
> -		ath_err(common, "Max. number of beaconing interfaces reached\n");
> -		mutex_unlock(&priv->mutex);
> -		return -ENOBUFS;
> -	}
> -

Looks okay.

Sujith
