Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:57721 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbaIBMAB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Sep 2014 08:00:01 -0400
Received: by mail-ie0-f182.google.com with SMTP id rd18so7559945iec.13
        for <linux-wireless@vger.kernel.org>; Tue, 02 Sep 2014 05:00:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1398137975-14275-3-git-send-email-mcgrof@do-not-panic.com>
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
	<1398137975-14275-3-git-send-email-mcgrof@do-not-panic.com>
Date: Tue, 2 Sep 2014 14:00:00 +0200
Message-ID: <CAGXE3d8yq_-EwacqXi2fMHC=KLU-6n=11U2wrYvpfwd++WryCg@mail.gmail.com> (sfid-20140902_140007_538677_BF847652)
Subject: Re: [PATCH 2/2] cfg80211: fix processing world regdomain when non modular
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	lkml20140418@newton.leun.net, Arik Nemtsov <arik@wizery.com>,
	linux@eikelenboom.it, "Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

On Tue, Apr 22, 2014 at 5:39 AM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> This allows processing of the last regulatory request when
> we determine its still pending. Without this if a regulatory
> request failed to get processed by userspace we wouldn't
> be able to re-process it later. An example situation that can
> lead to an unprocessed last_request is enabling cfg80211 to
> be built-in to the kernel, not enabling CFG80211_INTERNAL_REGDB
> and the CRDA binary not being available at the time the udev
> rule that kicks of CRDA triggers.
>
> In such a situation we want to let some cfg80211 triggers
> eventually kick CRDA for us again. Without this if the first
> cycle attempt to kick off CRDA failed we'd be stuck without
> the ability to change process any further regulatory domains.
>
> cfg80211 will trigger re-processing of the regulatory queue
> whenever schedule_work(&reg_work) is called, currently this
> happens when:
>
>   * suspend / resume
>   * disconnect
>   * a beacon hint gets triggered (non DFS 5 GHz AP found)
>   * a regulatory request gets added to the queue
>
> We don't have any specific opportunistic late boot triggers
> to address a late mount of where CRDA resides though, adding
> that should be done separately through another patch.
> Without an opportunistic fix then this fix relies at least
> one of the triggeres above to happen.
>
> Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
> Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
> ---
>  net/wireless/reg.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 081c571..625c41e 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -1912,7 +1912,7 @@ static void reg_process_pending_hints(void)
>
>         /* When last_request->processed becomes true this will be rescheduled */
>         if (lr && !lr->processed) {
> -               REG_DBG_PRINT("Pending regulatory request, waiting for it to be processed...\n");
> +               reg_process_hint(lr);
>                 return;
>         }
>

This change created a race in my setup (ar9344 based AP with two ath9k devices):
Sometimes during boot the following happens:

...
[    6.190000] ath: Country alpha2 being used: US
...
[    6.210000] ath: Country alpha2 being used: US
...
[    6.240000] cfg80211: Calling CRDA for country: US
[    6.240000] cfg80211: Calling CRDA for country: US
[    6.240000] cfg80211: Current regulatory domain intersected:
[    6.240000] cfg80211:  DFS Master region: unset
[    6.240000] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp), (dfs_cac_time)
[    6.240000] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(N/A, 2000 mBm), (N/A)
[    6.240000] cfg80211:   (2457000 KHz - 2472000 KHz @ 15000 KHz),
(N/A, 2000 mBm), (N/A)
[    6.240000] cfg80211:   (5170000 KHz - 5250000 KHz @ 80000 KHz),
(N/A, 1700 mBm), (N/A)
[    6.240000] cfg80211:   (5250000 KHz - 5330000 KHz @ 80000 KHz),
(N/A, 2000 mBm), (0 s)
[    6.240000] cfg80211:   (5735000 KHz - 5835000 KHz @ 80000 KHz),
(N/A, 2000 mBm), (N/A)
[    6.240000] cfg80211:   (57240000 KHz - 63720000 KHz @ 2160000
KHz), (N/A, 0 mBm), (N/A)
...

CRDA (or in my case the internal regdb) is called twice for country
code US by two different devices.
In this case the second request came in before the first one was
completely processed and the first
request will be re-processed (due to this patch) leading to an
intersected regdomain (US with US :) ).

Reverting this patch fixes this race for me but I think you had some
good reasons to do this patch.

Any ideas?

Thanks,
Helmut
