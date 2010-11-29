Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:65370 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab0K2Vtz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Nov 2010 16:49:55 -0500
Received: by iwn5 with SMTP id 5so620995iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Nov 2010 13:49:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101126184155.GA2689@jm.kir.nu>
References: <20101126184155.GA2689@jm.kir.nu>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 29 Nov 2010 13:49:34 -0800
Message-ID: <AANLkTi=D5ynvBGNLQnTJmpuBQHySVdudTkM9LughnT-o@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Fix frame injection using non-AP vif
To: Jouni Malinen <jouni.malinen@atheros.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 26, 2010 at 10:41 AM, Jouni Malinen
<jouni.malinen@atheros.com> wrote:
> In order for frame injection to work properly for some use cases
> (e.g., finding the station entry and keys for encryption), mac80211
> needs to find the correct sdata entry. This works when the main vif
> is in AP mode, but commit a2c1e3dad516618cb0fbfb1a62c36d0b0744573a
> broke this particular use case for station main vif. While this type of
> injection is quite unusual operation, it has some uses and we should fix
> it. Do this by changing the monitor vif sdata selection to allow station
> vif to be selected instead of limiting it to just AP vifs. We still need
> to skip some iftypes to avoid selecting unsuitable vif for injection.
>
> Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
>
> ---
>  net/mac80211/tx.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> --- wireless-testing.orig/net/mac80211/tx.c     2010-11-26 20:21:02.000000000 +0200
> +++ wireless-testing/net/mac80211/tx.c  2010-11-26 20:36:22.000000000 +0200
> @@ -1595,7 +1595,12 @@ static void ieee80211_xmit(struct ieee80
>                                                list) {
>                                if (!ieee80211_sdata_running(tmp_sdata))
>                                        continue;
> -                               if (tmp_sdata->vif.type != NL80211_IFTYPE_AP)
> +                               if (tmp_sdata->vif.type ==
> +                                   NL80211_IFTYPE_MONITOR ||

Ah, for some reason I thought we were able to push frames as a monitor
all along, no wonder packetspammer didn't work, or should it?

  Luis
