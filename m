Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49752 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754668AbcDALsb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2016 07:48:31 -0400
Message-ID: <1459511308.3342.0.camel@sipsolutions.net> (sfid-20160401_134834_556640_F209A8B1)
Subject: Re: [PATCH] Prevent unnecessary iteration in __handle_cmd
From: Johannes Berg <johannes@sipsolutions.net>
To: Sunil Shahu <shshahu@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 01 Apr 2016 13:48:28 +0200
In-Reply-To: <1459499461-4422-1-git-send-email-shshahu@gmail.com> (sfid-20160401_103119_737984_577FA87E)
References: <1459499461-4422-1-git-send-email-shshahu@gmail.com>
	 (sfid-20160401_103119_737984_577FA87E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-04-01 at 14:01 +0530, Sunil Shahu wrote:
> Break the loop after matching sectcmd is found. Remove redundant
> variable copying.
> 
> Signed-off-by: Sunil Shahu <shshahu@gmail.com>
> ---
>  iw.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> diff --git a/iw.c b/iw.c
> index 0f511d9..73ae347 100644
> --- a/iw.c
> +++ b/iw.c
> @@ -376,11 +376,9 @@ static int __handle_cmd(struct nl80211_state
> *state, enum id_input idby,
>  		if (match && sectcmd->idby != command_idby)
>  			continue;
>  		if (strcmp(sectcmd->name, section) == 0)
> -			match = sectcmd;
> +			break;
>  	}
>  
> -	sectcmd = match;
> -	match = NULL;
> 
I don't think this works - what if you reach the end of the loop?

johannes
