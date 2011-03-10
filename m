Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59128 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751368Ab1CJFWy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 00:22:54 -0500
Received: by wwa36 with SMTP id 36so1540685wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 21:22:53 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimm0umg3rZDwYU4KGLbaCQgAA_QKCpoY9NiscLT@mail.gmail.com>
References: <AANLkTimm0umg3rZDwYU4KGLbaCQgAA_QKCpoY9NiscLT@mail.gmail.com>
Date: Thu, 10 Mar 2011 10:52:53 +0530
Message-ID: <AANLkTimNs9DzhX=_=qAw_uZ5doxQnZ=9mOhcVcTUaCt5@mail.gmail.com>
Subject: Re: [PATCH] mac80211: do not enable ps if 802.1x controlled port is unblocked
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Jason Young <a.young.jason@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 10, 2011 at 8:26 AM, Jason Young <a.young.jason@gmail.com> wrote:
> If dynamic_ps is disabled, enabling power save before the 4-way
> handshake completes may delay the station from being authorized to
> send/receive traffic, i.e. increase roaming times. It may also result in
> a failed 4-way handshake depending on the AP's timing requirements and
> beacon interval, and the station's listen interval.
>
> To fix this, prevent power save from being enabled while the station
> isn't authorized and recalculate power save whenever the station's
> authorized state changes.
>
> Signed-off-by: Jason Young <a.young.jason@gmail.com>
> ---
>  net/mac80211/cfg.c  |    3 +++
>  net/mac80211/mlme.c |   37 ++++++++++++++++++++++++++++++++-----
>  2 files changed, 35 insertions(+), 5 deletions(-)
>
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 7b701dc..6a7bdeb 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -834,6 +834,9 @@ static int ieee80211_change_station(struct wiphy *wiphy,
>
>        rcu_read_unlock();
>
> +       if (params->sta_flags_mask & BIT(NL80211_STA_FLAG_AUTHORIZED))
> +               ieee80211_recalc_ps(local, -1);
> +
>        return 0;
>  }
>
> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index cc984bd..64d92d5 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -613,6 +613,37 @@ static void ieee80211_change_ps(struct
> ieee80211_local *local)

Patch fails to apply in the above line.  Please correct the newline
error. I think you had manually modified the patch for 80 char limit
after creating it. It is not necessary and you can send it as it is.

Vivek.
