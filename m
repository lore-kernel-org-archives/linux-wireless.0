Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58960 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1FHUD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2011 16:03:56 -0400
Received: by pzk9 with SMTP id 9so408027pzk.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Jun 2011 13:03:56 -0700 (PDT)
Date: Wed, 8 Jun 2011 23:03:32 +0300
From: Dan Carpenter <error27@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath6kl: fix crash when interface is closed but scan
 is ongoing
Message-ID: <20110608200332.GC4069@shale.localdomain> (sfid-20110608_220401_921660_9A883FF4)
References: <20110608114240.32208.31805.stgit@localhost6.localdomain6>
 <20110608115501.32208.82264.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110608115501.32208.82264.stgit@localhost6.localdomain6>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 08, 2011 at 02:55:01PM +0300, Kalle Valo wrote:
> -        /* Translate data to cfg80211 mgmt format */
> -	if (ar->arWmi)
            ^^^^^^^^^
	You removed this check on purpose?  Is this only NULL when
	the scan is canceled?

> -		wmi_iterate_nodes(ar->arWmi, ar6k_cfg80211_scan_node, ar->wdev->wiphy);
> +    if (!ar->scan_request)
> +	    return;
> +
> +    if ((status == A_ECANCELED) || (status == A_EBUSY)) {
> +	    cfg80211_scan_done(ar->scan_request, true);
> +	    goto out;
> +    }
> +
> +    /* Translate data to cfg80211 mgmt format */
> +    wmi_iterate_nodes(ar->arWmi, ar6k_cfg80211_scan_node, ar->wdev->wiphy);

regards,
dan carpenter
