Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:33190 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab0GBT5w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 15:57:52 -0400
Received: from wpaz13.hot.corp.google.com (wpaz13.hot.corp.google.com [172.24.198.77])
	by smtp-out.google.com with ESMTP id o62Jvpog020512
	for <linux-wireless@vger.kernel.org>; Fri, 2 Jul 2010 12:57:52 -0700
Received: from iwn8 (iwn8.prod.google.com [10.241.68.72])
	by wpaz13.hot.corp.google.com with ESMTP id o62JvoWY020822
	for <linux-wireless@vger.kernel.org>; Fri, 2 Jul 2010 12:57:51 -0700
Received: by iwn8 with SMTP id 8so4609491iwn.11
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jul 2010 12:57:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1278094401.15412.27.camel@jlt3.sipsolutions.net>
References: <AANLkTilV1t1737ciSPyyETeBEcN_QXsYxgEwpZIIucR2@mail.gmail.com>
	<1278091743.15412.17.camel@jlt3.sipsolutions.net>
	<AANLkTikfegnc1gAwIUiZKaMeDoUYOFqK8eSc6_3wUggm@mail.gmail.com>
	<1278094401.15412.27.camel@jlt3.sipsolutions.net>
Date: Fri, 2 Jul 2010 12:57:50 -0700
Message-ID: <AANLkTikWA9YeoTgYWrpE5J7RW3BJGu2LPqP-iBIdAUHs@mail.gmail.com>
Subject: Re: [PATCH 2.6.34] mac80211: Fix auth retries if AP sends temporary
	deauth
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>,
	Jiri Benc <jbenc@suse.cz>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sure enough, your patch works well.  The end effect is correct, in
that despite the reception of the DEAUTH, we are successfully able to
process a successful auth response on the second try.  Do I take it
that this change will make it upstream since this is the case?  Have a
happy wedding, and no git merge until after the ceremony! :-)

--
Paul

On Fri, Jul 2, 2010 at 11:13 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2010-07-02 at 11:09 -0700, Paul Stewart wrote:
> Can you try the patch below instead of yours? I'll explain it a bit more
> later, but my church wedding ceremony is tomorrow :)
>
> johannes
>
> --- wireless-testing.orig/net/wireless/mlme.c   2010-07-02 20:12:19.000000000 +0200
> +++ wireless-testing/net/wireless/mlme.c        2010-07-02 20:12:43.000000000 +0200
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
