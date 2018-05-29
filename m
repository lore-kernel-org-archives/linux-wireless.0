Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:59260 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932404AbeE2JRP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 May 2018 05:17:15 -0400
Message-ID: <1527585428.6955.7.camel@sipsolutions.net> (sfid-20180529_112024_533951_93B340C9)
Subject: Re: [PATCH] mac80211_hwsim: add error check to call to
 rhashtable_init
From: Johannes Berg <johannes@sipsolutions.net>
To: Colin King <colin.king@canonical.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 29 May 2018 11:17:08 +0200
In-Reply-To: <20180529091412.8530-1-colin.king@canonical.com>
References: <20180529091412.8530-1-colin.king@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-05-29 at 10:14 +0100, Colin King wrote:
> 
> @@ -3573,7 +3573,9 @@ static int __init init_mac80211_hwsim(void)
>  	hwsim_wq = alloc_workqueue("hwsim_wq", 0, 0);
>  	if (!hwsim_wq)
>  		return -ENOMEM;
> -	rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
> +	err = rhashtable_init(&hwsim_radios_rht, &hwsim_rht_params);
> +	if (err)
> +		return err;

That's missing a workqueue free, but I can fix that while applying if
you prefer.

johannes
