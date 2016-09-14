Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43465 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753197AbcINJyg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 05:54:36 -0400
Message-ID: <1473846871.4423.14.camel@sipsolutions.net> (sfid-20160914_115440_254574_79A823CB)
Subject: Re: [PATCH 2/2] mwifiex: parse WMM IEs from hostapd for mwifiex AP
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>, linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Avinash Patil <patila@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Frank Huang <frankh@marvell.com>
Date: Wed, 14 Sep 2016 11:54:31 +0200
In-Reply-To: <1357174561-28898-2-git-send-email-bzhao@marvell.com> (sfid-20130103_015637_973661_B4551387)
References: <1357174561-28898-1-git-send-email-bzhao@marvell.com>
         <1357174561-28898-2-git-send-email-bzhao@marvell.com>
         (sfid-20130103_015637_973661_B4551387)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Obviously this is a very old patch, but I was just looking at users of
cfg80211_find_vendor_ie() and realized you have a bug here:

> +	vendor_ie = cfg80211_find_vendor_ie(WLAN_OUI_MICROSOFT,
> +					    WLAN_OUI_TYPE_MICROSOFT_
> WMM,
> +					    params->beacon.tail,
> +					    params-
> >beacon.tail_len);
> +	if (vendor_ie) {
> +		wmm_ie = (struct ieee_types_header *)vendor_ie;
> +		memcpy(&bss_cfg->wmm_info, wmm_ie + 1,
> +		       sizeof(bss_cfg->wmm_info));
> +		priv->wmm_enabled = 1;

You need to check that the vendor_ie is actually long enough.

johannes
