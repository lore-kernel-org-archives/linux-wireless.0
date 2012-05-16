Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26418 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966982Ab2EPKe2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 06:34:28 -0400
Message-ID: <4FB382AA.9030902@qca.qualcomm.com> (sfid-20120516_123431_531708_0F2B0D08)
Date: Wed, 16 May 2012 13:34:18 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Naveen Singh <navesing@qca.qualcomm.com>
Subject: Re: [PATCH] ath6kl: Include match ssid list in scheduled scan
References: <1337164140-16098-1-git-send-email-kvalo@qca.qualcomm.com>
In-Reply-To: <1337164140-16098-1-git-send-email-kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2012 01:29 PM, Kalle Valo wrote:

> +			if ((match_set[i].ssid.ssid_len ==
> +			     ssid_list[j].ssid.ssid_len) &&
> +			    (!memcmp(ssid_list[j].ssid.ssid,
> +				     match_set[i].ssid.ssid,
> +				     match_set[i].ssid.ssid_len))) {
> +				ssid_list[j].flag |= MATCH_SSID_FLAG;
> +				ssid_found = true;
> +				break;
> +			}

Do we have a function like ieee80211_is_same_ssid()? I didn't find
anything like that after a quick search.

I noticed that wlcore had a similar code like we have here. A common
function in cfg80211.h/ieee80211.h for comparing ssids would be nice and
less error prone.

Kalle
