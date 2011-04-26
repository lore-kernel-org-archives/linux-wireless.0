Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63761 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756450Ab1DZUzd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2011 16:55:33 -0400
Received: by iwn34 with SMTP id 34so845472iwn.19
        for <linux-wireless@vger.kernel.org>; Tue, 26 Apr 2011 13:55:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303849642-9014-1-git-send-email-arik@wizery.com>
References: <1303849642-9014-1-git-send-email-arik@wizery.com>
Date: Tue, 26 Apr 2011 22:55:32 +0200
Message-ID: <BANLkTim45NHT3o2mB7Ofb9KvqBDrGjJcaw@mail.gmail.com> (sfid-20110426_225536_669113_D4439222)
Subject: Re: [PATCH] mac80211: report MIC failure for truncated packets in AP mode
From: Christian Lamparter <chunkeey@googlemail.com>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 26, 2011 at 10:27 PM, Arik Nemtsov <arik@wizery.com> wrote:
> MIC failure notifications for packets too short to contain a key index
> are currently ignored in AP-mode. Fix the check to only ignore packets
> with an existing non-zero key index.
>
> The wl12xx chip always truncates packets with a failed MIC and requires
> this change to operate correctly in AP-mode.
>
> No such check is made in STA mode. Therefore its relatively safe to assume
> there's no other HW that relies on the current code to avoid spurious
> MIC failures with correct yet truncated packets.
>
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
>  net/mac80211/rx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
> index a864890..875fc3c 100644
> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -2391,7 +2391,7 @@ static void ieee80211_rx_michael_mic_report(struct ieee80211_hdr *hdr,
>        if (!ieee80211_has_protected(hdr->frame_control))
>                return;
>
> -       if (rx->sdata->vif.type == NL80211_IFTYPE_AP && keyidx) {
> +       if (rx->sdata->vif.type == NL80211_IFTYPE_AP && keyidx > 0) {
>                /*
>                 * APs with pairwise keys should never receive Michael MIC
>                 * errors for non-zero keyidx because these are reserved for
> --
wait! Since you seem able to trigger MIC events frequently, could you
please test if the following patch:

<http://www.spinics.net/lists/linux-wireless/msg67571.html>

<a little more info:http://www.spinics.net/lists/linux-wireless/msg67461.html>

would help in your case as well?

Regards,
     Christian
