Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.35]:35256 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709Ab0GMPFB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Jul 2010 11:05:01 -0400
Received: from hpaq12.eem.corp.google.com (hpaq12.eem.corp.google.com [172.25.149.12])
	by smtp-out.google.com with ESMTP id o6DF4xla022136
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jul 2010 08:04:59 -0700
Received: from iwn41 (iwn41.prod.google.com [10.241.68.105])
	by hpaq12.eem.corp.google.com with ESMTP id o6DF4wbW001042
	for <linux-wireless@vger.kernel.org>; Tue, 13 Jul 2010 08:04:58 -0700
Received: by iwn41 with SMTP id 41so2426486iwn.16
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jul 2010 08:04:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1278938803.5870.24.camel@jlt3.sipsolutions.net>
References: <AANLkTilV1t1737ciSPyyETeBEcN_QXsYxgEwpZIIucR2@mail.gmail.com>
	<1278091743.15412.17.camel@jlt3.sipsolutions.net>
	<AANLkTikfegnc1gAwIUiZKaMeDoUYOFqK8eSc6_3wUggm@mail.gmail.com>
	<1278094401.15412.27.camel@jlt3.sipsolutions.net>
	<AANLkTikWA9YeoTgYWrpE5J7RW3BJGu2LPqP-iBIdAUHs@mail.gmail.com>
	<1278938803.5870.24.camel@jlt3.sipsolutions.net>
Date: Tue, 13 Jul 2010 08:04:57 -0700
Message-ID: <AANLkTinkTGci2B-r4DCAlnZlhGXJ9vb78D-n2pNjLqn2@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: ignore spurious deauth
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As stated in the other thread, this patch solves the issue I was
running into.  Thanks!

--
Paul

On Mon, Jul 12, 2010 at 5:46 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Ever since mac80211/drivers are no longer
> fully in charge of keeping track of the
> auth status, trying to make them do so will
> fail. Instead of warning and reporting the
> deauthentication to userspace, cfg80211 must
> simply ignore it so that spurious
> deauthentications, e.g. before starting
> authentication, aren't seen by userspace as
> actual deauthentications.
>
> Cc: stable@kernel.org
> Reported-by: Paul Stewart <pstew@google.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/mlme.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> --- wireless-testing.orig/net/wireless/mlme.c   2010-07-12 14:34:22.000000000 +0200
> +++ wireless-testing/net/wireless/mlme.c        2010-07-12 14:42:27.000000000 +0200
> @@ -44,10 +44,10 @@ void cfg80211_send_rx_auth(struct net_de
>                }
>        }
>
> -       WARN_ON(!done);
> -
> -       nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
> -       cfg80211_sme_rx_auth(dev, buf, len);
> +       if (done) {
> +               nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
> +               cfg80211_sme_rx_auth(dev, buf, len);
> +       }
>
>        wdev_unlock(wdev);
>  }
>
>
>
