Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f171.google.com ([209.85.223.171]:40723 "EHLO
	mail-iw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758300AbZLIWhi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 17:37:38 -0500
Received: by iwn1 with SMTP id 1so4941078iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 09 Dec 2009 14:37:45 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1260389724-2392-1-git-send-email-linville@tuxdriver.com>
References: <1260389724-2392-1-git-send-email-linville@tuxdriver.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 10 Dec 2009 09:37:25 +1100
Message-ID: <646765f40912091437y22d322c6m295cff07a95c4ebe@mail.gmail.com>
Subject: Re: [PATCH] wireless: update old static regulatory domain rules
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 10, 2009 at 07:15, John W. Linville <linville@tuxdriver.com> wrote:
> Update "US" and "JP" for current rules, and replace "EU" rules with the
> world roaming domain (since it was only a pseudo-domain anyway).
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
>  net/wireless/reg.c |   75 +++++++++++++++++----------------------------------
>  1 files changed, 25 insertions(+), 50 deletions(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index c01470e..baa898a 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -206,15 +179,17 @@ static const struct ieee80211_regdomain *static_regdom(char *alpha2)
>                return &us_regdom;
>        if (alpha2[0] == 'J' && alpha2[1] == 'P')
>                return &jp_regdom;
> +       /* Use world roaming rules for "EU", since it was a pseudo
> +          domain anyway... */
>        if (alpha2[0] == 'E' && alpha2[1] == 'U')
> -               return &eu_regdom;
> -       /* Default, as per the old rules */
> -       return &us_regdom;
> +               return &world_regdom;
> +       /* Default, world roaming rules */
> +       return &world_regdom;
>  }

Is the if statement for the "EU" regdom really necessary (except as
documentation) as we're returning &world_regdom by default?

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
