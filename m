Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54982 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751437AbcJJJWC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Oct 2016 05:22:02 -0400
Message-ID: <1476091316.7895.6.camel@sipsolutions.net> (sfid-20161010_112205_229601_9CF4BDEF)
Subject: Re: [PATCH] Report scan_abort as part of iw phy
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Ola Olsson <ola.olsson@sonymobile.com>
Date: Mon, 10 Oct 2016 11:21:56 +0200
In-Reply-To: <1475934036-5981-1-git-send-email-ola1olsson@gmail.com> (sfid-20161008_154139_617958_B7F51579)
References: <1475934036-5981-1-git-send-email-ola1olsson@gmail.com>
         (sfid-20161008_154139_617958_B7F51579)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-10-08 at 15:40 +0200, Ola Olsson wrote:
> nl80211: abort_scan has not been reported under the 'Supported
> commands'
> category when calling iw phy. Add that.
> 
> Signed-off-by: Ola Olsson <ola.olsson@sonymobile.com>
> ---
>  net/wireless/nl80211.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 95d55d2..0bbce4f 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -1526,6 +1526,7 @@ static int nl80211_send_wiphy(struct
> cfg80211_registered_device *rdev,
>  		CMD(set_bitrate_mask, SET_TX_BITRATE_MASK);
>  		CMD(mgmt_tx, FRAME);
>  		CMD(mgmt_tx_cancel_wait, FRAME_WAIT_CANCEL);
> +		CMD(abort_scan, ABORT_SCAN);
> 

You can't add this here, it has to be inside the "state->split" if.

johannes
