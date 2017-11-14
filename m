Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:42682 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754400AbdKNM6S (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 07:58:18 -0500
Message-ID: <1510664296.2030.22.camel@sipsolutions.net> (sfid-20171114_135822_705688_F71094C6)
Subject: Re: [RFC] cfg80211: Implement Multiple BSSID capability in scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, Peng Xu <pxu@qti.qualcomm.com>,
        Sara Sharon <sara.sharon@intel.com>
Date: Tue, 14 Nov 2017 13:58:16 +0100
In-Reply-To: <1509554358-10473-1-git-send-email-jouni@qca.qualcomm.com>
References: <1509554358-10473-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> +			if (tmp_old[0] == WLAN_EID_VENDOR_SPECIFIC) {
> +				if (!memcmp(tmp_old + 2, tmp + 2, 5)) {
> +					/* same vendor ie, copy from new ie */
> +					memcpy(pos, tmp, tmp[1] + 2);
> +					pos += tmp[1] + 2;
> +				} else {
> +					memcpy(pos, tmp_old, tmp_old[1] + 2);
> +					pos += tmp_old[1] + 2;

This seems really strange. What's 5? Should it be 4, so you have
OUI+subelement ID?

johannes
