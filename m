Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f176.google.com ([209.85.220.176]:35877 "EHLO
        mail-qk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751517AbdEBShr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 May 2017 14:37:47 -0400
Received: by mail-qk0-f176.google.com with SMTP id u75so124865088qka.3
        for <linux-wireless@vger.kernel.org>; Tue, 02 May 2017 11:37:47 -0700 (PDT)
Subject: Re: [PATCH] cfg80211: fix multi scheduled scan kernel-doc
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170502073340.13002-1-johannes@sipsolutions.net>
Cc: Johannes Berg <johannes.berg@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1aff52bf-2e88-cb79-40f4-923478237fdd@broadcom.com> (sfid-20170502_203814_192559_262ED2FE)
Date: Tue, 2 May 2017 20:37:44 +0200
MIME-Version: 1.0
In-Reply-To: <20170502073340.13002-1-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2-5-2017 9:33, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Replace @results_wk with @report_results, which was missed
> in an earlier patch between revisions thereof.

Fixed it yesterday, but did not send it out yet. Here the commit message
I came up with if you want to reuse it.

    cfg80211: fix documentation warnings in struct
cfg80211_sched_scan_request

    The documentation for cfg80211_sched_scan_request was not properly
    updated with changes related to multi-scheduled scan support.

Regardless your decision here is my ...

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Fixes: b34939b98369 ("cfg80211: add request id to cfg80211_sched_scan_*() api")
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  include/net/cfg80211.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index 6e90f1a4950f..561989142f34 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -1666,7 +1666,7 @@ struct cfg80211_bss_select_adjust {
>   * 	(others are filtered out).
>   *	If ommited, all results are passed.
>   * @n_match_sets: number of match sets
> - * @results_wk: worker for processing results notification.
> + * @report_results: indicates that results were reported for this request
>   * @wiphy: the wiphy this was for
>   * @dev: the interface
>   * @scan_start: start time of the scheduled scan
> 
