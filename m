Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:37634 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730759AbeHNOVA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Aug 2018 10:21:00 -0400
Message-ID: <1534246392.3547.26.camel@sipsolutions.net> (sfid-20180814_133416_685913_D2729095)
Subject: Re: [PATCH v3 1/2] mac80211: invoke sw_scan if hw_scan returns EPERM
From: Johannes Berg <johannes@sipsolutions.net>
To: Sushant Kumar Mishra <sushant2k1513@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sanjay.konduri@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Date: Tue, 14 Aug 2018 13:33:12 +0200
In-Reply-To: <1533180646-8028-1-git-send-email-sushant2k1513@gmail.com> (sfid-20180802_055141_811857_426FAC5B)
References: <1533180646-8028-1-git-send-email-sushant2k1513@gmail.com>
         (sfid-20180802_055141_811857_426FAC5B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-08-02 at 09:00 +0530, Sushant Kumar Mishra wrote:
> From: Sanjay Kumar Koduri <sanjay.konduri@redpinesignals.com>
> 
> Currently, software scan in mac80211 is used by drivers, which don't
> implement hardware scan. However some drivers which have implemented
> hardware scan may also sometimes want to use software scan in mac80211.
> Such drivers can return '-EPERM' and ask mac80211 to fallback to
> software scan with this patch.
> 
> Signed-off-by: Sanjay Kumar konduri <sanjay.konduri@redpinesignals.com>
> Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
> Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
> ---
> changes in v3: Set SCAN_HW_CANCELLED bit, before SW_SCAN triggered.

I'm not convinced - why would you set that? It seems to me that drivers
might, for example, still do one band in hardware and the other in
software, or something like that? You might also run into the WARN_ON
here?

> @@ -686,6 +686,11 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
>  	if (local->ops->hw_scan) {
>  		WARN_ON(!ieee80211_prep_hw_scan(local));



>  		rc = drv_hw_scan(local, sdata, local->hw_scan_req);
> +		if (rc == -EPERM) {
> +			set_bit(SCAN_HW_CANCELLED, &local->scanning);
> +			__set_bit(SCAN_SW_SCANNING, &local->scanning);
> +			rc = ieee80211_start_sw_scan(local, sdata);
> +		}

Also, -EPERM is probably not a good idea - we might want to let the
driver propagate arbitrary return values up. There's precedent for using
a positive number (just the value 1) for such "special" behaviour, so I
think that'd be better.

Obviously this is also lacking documentation in mac80211.h one way or
the other.

johannes
