Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:60925 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754841AbYDZPZq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Apr 2008 11:25:46 -0400
Received: by wa-out-1112.google.com with SMTP id m16so6682137waf.23
        for <linux-wireless@vger.kernel.org>; Sat, 26 Apr 2008 08:25:45 -0700 (PDT)
Message-ID: <1ba2fa240804260825qcae5777qddd2d1e91a0277dc@mail.gmail.com> (sfid-20080426_172604_795906_4CB85248)
Date: Sat, 26 Apr 2008 18:25:45 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH RFT] tkip: fix iv32 calculation in ieee80211_get_tkip_key()
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1209081653.12561.50.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1209081653.12561.50.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 25, 2008 at 3:00 AM, Pavel Roskin <proski@gnu.org> wrote:
> Signed-off-by: Pavel Roskin <proski@gnu.org>
>  ---
>  It's a side product of testing a sparse patch by Linus Torvalds.
>  Compile tested only.
>
>   net/mac80211/tkip.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)
>
>
>  diff --git a/net/mac80211/tkip.c b/net/mac80211/tkip.c
>  index dddbfd6..b9ecd65 100644
>  --- a/net/mac80211/tkip.c
>  +++ b/net/mac80211/tkip.c
>  @@ -231,9 +231,9 @@ void ieee80211_get_tkip_key(struct ieee80211_key_conf *keyconf,
>         iv16 = data[hdr_len] << 8;
>         iv16 += data[hdr_len + 2];
>         iv32 = data[hdr_len + 4] +
>  -               (data[hdr_len + 5] >> 8) +
>  -               (data[hdr_len + 6] >> 16) +
>  -               (data[hdr_len + 7] >> 24);
>  +               (data[hdr_len + 5] << 8) +
>  +               (data[hdr_len + 6] << 16) +
>  +               (data[hdr_len + 7] << 24);
>
>   #ifdef CONFIG_TKIP_DEBUG
>         printk(KERN_DEBUG "TKIP encrypt: iv16 = 0x%04x, iv32 = 0x%08x\n",
>
>

We've tested TKIP code well and I'm not sure we wouldn't pay attention
to such mistake.
Tomas

>  Regards,
>  Pavel Roskin
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
