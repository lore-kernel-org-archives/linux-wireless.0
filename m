Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:61699 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab1LUPbW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 10:31:22 -0500
Received: by pbdu13 with SMTP id u13so3047311pbd.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 07:31:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324479072-8242-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1324479072-8242-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Wed, 21 Dec 2011 16:31:21 +0100
Message-ID: <CAGXE3d-Ntrz7WUXMKBHP2oyX1YBFvqyDHU96x9xGb__C=O8Mtw@mail.gmail.com> (sfid-20111221_163125_545910_33CB9416)
Subject: Re: [RFC] mac80211: fix scan state machine
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Wed, Dec 21, 2011 at 3:51 PM, Mohammed Shafi Shajakhan
<mohammed@qca.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> when we run high bandwidth UDP traffic and we trigger a scan, the scan
> state machine seems to be looping in SUSPEND->RESUME->DECISION->SUSPEND
> and SET_CHANNEL seems to be never called as 'tx_empty' is never true
> while running UDP traffic. fix this by settting SET_CHANNEL state when
> we get into RESUME state.

Your analysis looks correct to me. Previously (before the
simplification patches)
the logic to always scan at least one channel was put in scan_state_decision but
maybe it makes sense to have it in scan_state_resume.

So, to me the patch looks good.

Helmut

> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> ---
>  net/mac80211/scan.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> index 2c5041c..2908e56 100644
> --- a/net/mac80211/scan.c
> +++ b/net/mac80211/scan.c
> @@ -625,7 +625,7 @@ static void ieee80211_scan_state_resume(struct ieee80211_local *local,
>        local->leave_oper_channel_time = jiffies;
>
>        /* advance to the next channel to be scanned */
> -       local->next_scan_state = SCAN_DECISION;
> +       local->next_scan_state = SCAN_SET_CHANNEL;
>  }
>
>  void ieee80211_scan_work(struct work_struct *work)
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
