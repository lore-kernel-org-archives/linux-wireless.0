Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:36753 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbcBVWsu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 17:48:50 -0500
Received: by mail-io0-f178.google.com with SMTP id l127so193897760iof.3
        for <linux-wireless@vger.kernel.org>; Mon, 22 Feb 2016 14:48:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456180974-21062-1-git-send-email-greearb@candelatech.com>
References: <1456180974-21062-1-git-send-email-greearb@candelatech.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 23 Feb 2016 09:48:30 +1100
Message-ID: <CAGRGNgWPv89sWV9wtXPBpothJrebRJ+d6a8-TnDU0o-p6ZkAmA@mail.gmail.com> (sfid-20160222_234854_183195_E091A88F)
Subject: Re: [PATCH] mac80211: Let VHT work on 2.4Ghz
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

On Tue, Feb 23, 2016 at 9:42 AM,  <greearb@candelatech.com> wrote:
> From: Ben Greear <greearb@candelatech.com>
>
> ath10k supports VHT on 2.4Ghz band.
> If supplicant and hostapd and radio think
> VHT should be allowed, then kernel should let them
> try.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>
> ---
>  net/mac80211/mlme.c | 16 ----------------
>  net/mac80211/util.c | 13 +------------
>  net/mac80211/vht.c  | 15 ---------------
>  3 files changed, 1 insertion(+), 43 deletions(-)
>
> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
> index f8eb0f8..cabe16f 100644
> --- a/net/mac80211/util.c
> +++ b/net/mac80211/util.c
> @@ -1604,17 +1603,7 @@ static int ieee80211_build_preq_ies_band(struct ieee80211_local *local,
>                 *offset = noffset;
>         }
>
> -       /* Check if any channel in this sband supports at least 80 MHz */
> -       for (i = 0; i < sband->n_channels; i++) {
> -               if (sband->channels[i].flags & (IEEE80211_CHAN_DISABLED |
> -                                               IEEE80211_CHAN_NO_80MHZ))
> -                       continue;
> -
> -               have_80mhz = true;
> -               break;
> -       }
> -
> -       if (sband->vht_cap.vht_supported && have_80mhz && !disable_vht) {
> +       if (sband->vht_cap.vht_supported && /*have_80mhz &&*/ !disable_vht) {

Do you want to actually remove have_80mhz here? We do have git history
if this needs to be put back.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
