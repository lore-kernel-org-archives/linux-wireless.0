Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:32949 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759114Ab2CGT0q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Mar 2012 14:26:46 -0500
Message-ID: <1331148403.2140.67.camel@joe2Laptop> (sfid-20120307_202650_548260_0406E824)
Subject: Re: [PATCH 03/12] ath6kl: alignment should match open parenthesis
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath6kl-devel@qualcomm.com, linux-wireless@vger.kernel.org
Date: Wed, 07 Mar 2012 11:26:43 -0800
In-Reply-To: <20120229171855.24264.64135.stgit@localhost6.localdomain6>
References: <20120229171525.24264.22062.stgit@localhost6.localdomain6>
	 <20120229171855.24264.64135.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-29 at 19:18 +0200, Kalle Valo wrote:
> Fix the issues which checkpatch found and were easy to fix. Especially
> callers of ath6kl_bmi_write() are tricky and that needs to be fixed
> separately.

Just a trivial note.

> diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
[]
> @@ -390,7 +390,7 @@ static bool ath6kl_is_valid_iftype(struct ath6kl *ar, enum nl80211_iftype type,
>  		return false;
>  
>  	if (ar->ibss_if_active || ((type == NL80211_IFTYPE_ADHOC) &&
> -	    ar->num_vif))
> +				   ar->num_vif))

I think this would be better as:

	if (ar->ibss_if_active ||
	    (type == NL80211_IFTYPE_ADHOC && ar->num_vif))

Bundling dependent tests on a single line is sensible.

