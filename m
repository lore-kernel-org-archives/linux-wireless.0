Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web51411.mail.re2.yahoo.com ([206.190.39.152]:24720 "HELO
	web51411.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753317AbZJ0LJG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 07:09:06 -0400
Message-ID: <474000.96217.qm@web51411.mail.re2.yahoo.com>
References: <133e8d7e0910241155x4496b156p3c5d03450a71936a@mail.gmail.com>
Date: Tue, 27 Oct 2009 04:09:10 -0700 (PDT)
From: Joerg Pommnitz <pommnitz@yahoo.com>
Subject: AW: [PATCH] mac80211: fix for incorrect sequence number on hostapd  injected frames
To: =?iso-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>,
	linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Jouni Malinen <j@w1.fi>, Will Dyson <will.dyson@gmail.com>
In-Reply-To: <133e8d7e0910241155x4496b156p3c5d03450a71936a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just applied the patch. So far, everything looks fine.

Thanks
  Joerg

----- Ursprüngliche Mail ----

> Von: Björn Smedman <bjorn.smedman@venatech.se>
> An: linville@tuxdriver.com
> CC: linux-wireless@vger.kernel.org; Johannes Berg <johannes@sipsolutions.net>; Jouni Malinen <j@w1.fi>; Joerg Pommnitz <pommnitz@yahoo.com>; Will Dyson <will.dyson@gmail.com>
> Gesendet: Samstag, den 24. Oktober 2009, 20:55:09 Uhr
> Betreff: [PATCH] mac80211: fix for incorrect sequence number on hostapd  injected frames
> 
> When hostapd injects a frame, e.g. an authentication or association
> response, mac80211 looks for a suitable access point virtual interface
> to associate the frame with based on its source address. This makes it
> possible e.g. to correctly assign sequence numbers to the frames.
> 
> A small typo in the ethernet address comparison statement caused a
> failure to find a suitable ap interface. Sequence numbers on such
> frames where therefore left unassigned causing some clients
> (especially windows-based 11b/g clients) to reject them and fail to
> authenticate or associate with the access point. This patch fixes the
> typo in the address comparison statement.
> 
> Signed-off-by: Björn Smedman 

Tested-by: Joerg Pommnitz <pommnitz@yahoo.com>

> ---
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index db4bda6..eaa4118 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1445,7 +1445,7 @@ static void ieee80211_xmit(struct
> ieee80211_sub_if_data *sdata,
>                                 if (tmp_sdata->vif.type != NL80211_IFTYPE_AP)
>                                         continue;
>                                 if (compare_ether_addr(tmp_sdata->dev->dev_addr,
> -                                                      hdr->addr2)) {
> +                                                      hdr->addr2) == 0) {
>                                         dev_hold(tmp_sdata->dev);
>                                         dev_put(sdata->dev);
>                                         sdata = tmp_sdata;



      
