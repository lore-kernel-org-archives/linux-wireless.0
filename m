Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36110 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752152AbcHYWaA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Aug 2016 18:30:00 -0400
Received: by mail-wm0-f51.google.com with SMTP id q128so257048015wma.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2016 15:29:59 -0700 (PDT)
Subject: Re: [PATCH] nl80211: Fix unfiltered GET_INTERFACE dumps
To: Denis Kenzior <denkenz@gmail.com>, linux-wireless@vger.kernel.org
References: <1472157884-3174-1-git-send-email-denkenz@gmail.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <210adf6d-287c-f836-8e2c-78f42de94dee@broadcom.com> (sfid-20160826_003003_669094_0C351B64)
Date: Thu, 25 Aug 2016 23:35:11 +0200
MIME-Version: 1.0
In-Reply-To: <1472157884-3174-1-git-send-email-denkenz@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25-08-16 22:44, Denis Kenzior wrote:
> dump_wiphy_parse only assigns filter_wiphy if one of the supported
> NL80211 attributes is present.  So for unfiltered dumps, filter_wiphy
> was always initialized to 0, and only interface 0 was dumped.
> 
> This was introduced in commit 2d75da13fbb957e955d212555b91101cef36f0ce.
> 
> Reported-by: Arend Van Spriel <arend.vanspriel@broadcom.com>

Actually sent a patch for this issue a little earlier. I should have
Cc'ed you explicitly, I guess.

Regards,
Arend

> Signed-off-by: Denis Kenzior <denkenz@gmail.com>
> ---
>  net/wireless/nl80211.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index 95d55d2..ddc994a 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -2534,6 +2534,7 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
>  		struct nl80211_dump_wiphy_state state = {};
>  		int ret;
>  
> +		state.filter_wiphy = -1;
>  		ret = nl80211_dump_wiphy_parse(skb, cb, &state);
>  		if (ret)
>  			return ret;
> 
