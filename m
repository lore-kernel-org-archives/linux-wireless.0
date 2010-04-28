Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:36131 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125Ab0D1NP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Apr 2010 09:15:28 -0400
From: <ext-saravanan.dhanabal@nokia.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 28 Apr 2010 15:12:40 +0200
Subject: RE: [RFC PATCH 1/1] mac80211: Disable cfg80211 assoc timeout warning
Message-ID: <04BB8F4F2843A24294353CA037CA5B585DAF132911@NOK-EUMSG-01.mgdnok.nokia.com>
References: <1272275367-7532-1-git-send-email-ext-saravanan.dhanabal@nokia.com>,<1272275586.3619.13.camel@jlt3.sipsolutions.net>
In-Reply-To: <1272275586.3619.13.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK. Please let me know about that fix after testing, so that I could follow it up.

-saravanan d.
________________________________________
From: ext Johannes Berg [johannes@sipsolutions.net]
Sent: Monday, April 26, 2010 12:53 PM
To: Dhanabal Saravanan (EXT-Sasken/Tampere)
Cc: linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH 1/1] mac80211: Disable cfg80211 assoc timeout warning

On Mon, 2010-04-26 at 12:49 +0300, Saravanan Dhanabal wrote:
> While the association response is queued and yet to be
> processed, if the interface goes down, ieee80211_stop
> marks work queue items as IEEE80211_WORK_ABORT. This
> creates assoc timeout warnings which are actually caused
> by if down. Those warnings could be avoided, since they
> are not beacuse of association response.
>
> This patch disables assoc timeout warnings if interface is
> not running.

I don't think this is the right fix, we just debated exactly this
problem too.

The right fix would be to make mac80211 kill the association work when
deauthentication is requested. We're testing that fix right now.

johannes

> Signed-off-by: Saravanan Dhanabal <ext-saravanan.dhanabal@nokia.com>
> ---
>  net/wireless/mlme.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
> index 0855f0d..a3ab86c 100644
> --- a/net/wireless/mlme.c
> +++ b/net/wireless/mlme.c
> @@ -337,7 +337,7 @@ void cfg80211_send_assoc_timeout(struct net_device *dev, const u8 *addr)
>               }
>       }
>
> -     WARN_ON(!done);
> +     WARN_ON(netif_running(dev) && !done);
>
>       wdev_unlock(wdev);
>  }


