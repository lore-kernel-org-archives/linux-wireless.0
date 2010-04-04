Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serv4.vsi.ru ([80.82.32.19]:45754 "EHLO serv4.vsi.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab0DDTqa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Apr 2010 15:46:30 -0400
Date: Sun, 4 Apr 2010 23:45:49 +0400
From: =?KOI8-R?Q?=EC=C5=C4=CF=D7=D3=CB=C9=C8_=EE=C9=CB=CF=CC=C1=CA_=F7=C1?=
	 =?KOI8-R?Q?=CC=C5=D2=D8=C5=D7=C9=DE?= <nledovskih@mail.ru>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix ieee80211_meshconf_ie::meshconf_cap type
 to be u16
Message-Id: <20100404234549.9fba2292.nledovskih@mail.ru>
In-Reply-To: <1270375964-23668-1-git-send-email-jcmvbkbc@gmail.com>
References: <1270375964-23668-1-git-send-email-jcmvbkbc@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun,  4 Apr 2010 14:12:44 +0400
Max Filippov <jcmvbkbc@gmail.com> wrote:

> According to the current 802.11s draft mesh capability field
> is 16 bits wide.
> 
> Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
> ---
>  include/linux/ieee80211.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
> index 1998495..910b4bc 100644
> --- a/include/linux/ieee80211.h
> +++ b/include/linux/ieee80211.h
> @@ -604,7 +604,7 @@ struct ieee80211_meshconf_ie {
>  	u8 meshconf_synch;
>  	u8 meshconf_auth;
>  	u8 meshconf_form;
> -	u8 meshconf_cap;
> +	u16 meshconf_cap;
>  } __attribute__ ((packed));
>  
>  /**
> -- 
> 1.6.2.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

May be it should be:

struct ieee80211_meshconf_ie {
        u32 meshconf_psel;
        u32 meshconf_pmetric;
        u32 meshconf_congest;
        u32 meshconf_synch;
        u32 meshconf_auth;
        u8 meshconf_form;
        u16 meshconf_cap;
} __attribute__ ((packed));

-- 
Best regards, Nick.
