Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34121 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757967AbbEaG6u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 May 2015 02:58:50 -0400
Received: by wgv5 with SMTP id 5so91103070wgv.1
        for <linux-wireless@vger.kernel.org>; Sat, 30 May 2015 23:58:48 -0700 (PDT)
Message-ID: <556AB128.3050909@gmail.com> (sfid-20150531_085854_538022_FD189F46)
Date: Sun, 31 May 2015 08:58:48 +0200
From: Arend van Spriel <aspriel@gmail.com>
MIME-Version: 1.0
To: Chaitanya T K <chaitanya.mgit@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] cfg80211: Don't re-use the skb for larger NL messages.
References: <1433028494-9665-1-git-send-email-chaitanya.mgit@gmail.com>
In-Reply-To: <1433028494-9665-1-git-send-email-chaitanya.mgit@gmail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31-05-15 01:28, Chaitanya T K wrote:
> cfg80211 reuses the skb before asking for a fresh on from genl framework, 
> this works efficiently for smaller messages but NLM_F_DUMP is normally 
> used to transport larger data normally > PAGE_SIZE, so if the message 
> occupies more than GOODSIZE its better to ask for a new, saves couple
> of hanshakes with the driver.
> 
> This improves the time to get the DUMP response across to user space.
> Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
> ---
> V2: no new line, so commit log was cut off. Updated now.
> ---
>  net/wireless/nl80211.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> index c264eff..152bd0c 100644
> --- a/net/wireless/nl80211.c
> +++ b/net/wireless/nl80211.c
> @@ -7636,6 +7636,10 @@ static int nl80211_testmode_dump(struct sk_buff *skb,
>  		}
>  
>  		genlmsg_end(skb, hdr);
> +
> +		/* Don't re-use skb, when we know nla_put fails*/

After reading the commit message this comment is not clear to me. Maybe
it is just me ;-)

> +		if (skb->len > NLMSG_GOODSIZE / 2)

This definitely does not match the description in the commit message:
'message occupies more than GOODSIZE' != (skb->len > NLMSG_GOODSIZE / 2)

Regards,
Arend

> +			break;
>  	}
>  
>  	err = skb->len;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
