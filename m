Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:59666 "EHLO
	mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbaJPUi3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2014 16:38:29 -0400
Received: by mail-oi0-f42.google.com with SMTP id a141so3319577oig.29
        for <linux-wireless@vger.kernel.org>; Thu, 16 Oct 2014 13:38:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1413385042-17903-1-git-send-email-sujith@msujith.org>
References: <1413385042-17903-1-git-send-email-sujith@msujith.org>
Date: Thu, 16 Oct 2014 23:38:28 +0300
Message-ID: <CANUX_P02O-JSQkVvBCg6L9jf8wPyzPv8O_qsZa+prTJJx+20UA@mail.gmail.com> (sfid-20141016_223833_924218_CB57E4A1)
Subject: Re: [PATCH] cfg80211: Warn once for delayed scan completion
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 15, 2014 at 5:57 PM, Sujith Manoharan <sujith@msujith.org> wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> Scan completion for drivers that use HW scanning
> causes a warning to be hit if the interface has been
> removed. Since cfg80211 ensures that both use-after-free
> and scheduling a new scan doesn't happen in this case,
> WARN_ON_ONCE can be used. With ath9k this warning is seen
> many times when multi-channel-concurrency is enabled.
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>

It is not really my business, but how come this happen with ath9k?
The scan should be cancelled before the interface is removed. You mean
that the scan cancellation is
asynchronous and the notification of the cancellation termination can
come after the cfg80211 has removed
the interface?

> ---
>  net/wireless/core.c | 2 +-
>  net/wireless/scan.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/wireless/core.c b/net/wireless/core.c
> index f52a4cd..2be08e8 100644
> --- a/net/wireless/core.c
> +++ b/net/wireless/core.c
> @@ -931,7 +931,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
>         case NETDEV_DOWN:
>                 cfg80211_update_iface_num(rdev, wdev->iftype, -1);
>                 if (rdev->scan_req && rdev->scan_req->wdev == wdev) {
> -                       if (WARN_ON(!rdev->scan_req->notified))
> +                       if (WARN_ON_ONCE(!rdev->scan_req->notified))
>                                 rdev->scan_req->aborted = true;
>                         ___cfg80211_scan_done(rdev, false);
>                 }
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index bda39f1..c0fc0b3 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -239,7 +239,7 @@ void __cfg80211_scan_done(struct work_struct *wk)
>  void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
>  {
>         trace_cfg80211_scan_done(request, aborted);
> -       WARN_ON(request != wiphy_to_rdev(request->wiphy)->scan_req);
> +       WARN_ON_ONCE(request != wiphy_to_rdev(request->wiphy)->scan_req);
>
>         request->aborted = aborted;
>         request->notified = true;
> --
> 2.1.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
