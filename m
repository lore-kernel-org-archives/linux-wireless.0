Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:12462 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbYHGW7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 18:59:46 -0400
Received: by an-out-0708.google.com with SMTP id d40so119673and.103
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2008 15:59:45 -0700 (PDT)
Message-ID: <43e72e890808071559k207a34e3we21cb2633f5e248d@mail.gmail.com> (sfid-20080808_005949_977560_9E891E98)
Date: Thu, 7 Aug 2008 15:59:45 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/2] mac80211: change number of pre-assoc scans
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org,
	"Ron Rindjunsky" <ron.rindjunsky@intel.com>
In-Reply-To: <1218149447-28968-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1218149447-28968-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 7, 2008 at 3:50 PM, Tomas Winkler <tomas.winkler@intel.com> wrote:
> From: Ron Rindjunsky <ron.rindjunsky@intel.com>
>
> This patch fixes noticed problem in noisy environments of 50+ APs
> that scan fails to find the requested AP on first try, which
> leads to connection refusal. second scan has empirically proven to fix
> this problem in almost all cases.
>
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Signed-off-by: Esti Kummer <ester.kummer@intel.com>
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
>  net/mac80211/ieee80211_i.h |    4 +++-
>  net/mac80211/mlme.c        |    9 +++++++--
>  2 files changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
> index d19f67e..f71785e 100644
> --- a/net/mac80211/ieee80211_i.h
> +++ b/net/mac80211/ieee80211_i.h
> @@ -369,7 +369,9 @@ struct ieee80211_if_sta {
>
>        struct sk_buff_head skb_queue;
>
> -       int auth_tries, assoc_tries;
> +       int assoc_scan_tries; /* number of scans done pre-association */
> +       int auth_tries; /* retries for auth req */
> +       int assoc_tries; /* retries for assoc req */

This last variable seems unused.

> @@ -3544,7 +3548,8 @@ static int ieee80211_sta_config_auth(struct net_device *dev,
>                ieee80211_sta_reset_auth(dev, ifsta);
>                return 0;
>        } else {
> -               if (ifsta->state != IEEE80211_STA_MLME_AUTHENTICATE) {
> +               if (ifsta->assoc_scan_tries < IEEE80211_ASSOC_SCANS_MAX_TRIES) {
> +                       ifsta->assoc_scan_tries++;
>                        if (ifsta->flags & IEEE80211_STA_AUTO_SSID_SEL)
>                                ieee80211_sta_start_scan(dev, NULL, 0);
>                        else

Interesting, is there a race then?

  Luis
