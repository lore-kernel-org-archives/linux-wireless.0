Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:45832 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750970AbeAVM5l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:57:41 -0500
Message-ID: <1516625859.2508.23.camel@sipsolutions.net> (sfid-20180122_135744_875626_0A71A354)
Subject: Re: [PATCH 3/4] mac80211: enable setting cqm config for AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: tamizhr@codeaurora.org
Cc: linux-wireless@vger.kernel.org, tamizhr@qti.qualcomm.com,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Date: Mon, 22 Jan 2018 13:57:39 +0100
In-Reply-To: <1516174276-16789-4-git-send-email-tamizhr@codeaurora.org>
References: <1516174276-16789-1-git-send-email-tamizhr@codeaurora.org>
         <1516174276-16789-4-git-send-email-tamizhr@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-17 at 13:01 +0530, tamizhr@codeaurora.org wrote:
> 
> +static void ieee80211_update_rssi_config(struct ieee80211_sub_if_data *sdata)
[...]
> +	/* if AP, always tell the driver by checking beacon status */
> +	if ((sdata->vif.type == NL80211_IFTYPE_AP ||
> +	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN ||
> +	     sdata->vif.type == NL80211_IFTYPE_P2P_GO) &&
> +	     !sdata->vif.bss_conf.enable_beacon)

nit: that line with !sdata should be indented one less, it doesn't
belong into the parenthesized expression.

Again though, this relies on a driver feature bit to not confuse the
driver.

johannes
