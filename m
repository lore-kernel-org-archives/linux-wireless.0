Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:47018 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932779AbbI3XQg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Sep 2015 19:16:36 -0400
Date: Thu, 1 Oct 2015 09:16:13 +1000
From: James Cameron <quozl@laptop.org>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iw: Memory leak in error condition
Message-ID: <20150930231613.GC20220@us.netrek.org> (sfid-20151001_011649_203990_1FB3CDCC)
References: <CABAco3AMgZSv9kCYkE6yQDcDE0+-7rA4ZzYazxSqAS99LHHMGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABAco3AMgZSv9kCYkE6yQDcDE0+-7rA4ZzYazxSqAS99LHHMGQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 01, 2015 at 01:01:18AM +0200, Ola Olsson wrote:
> >From 5239e8e9aa79a131b716398efbf7a1203decbd9b Mon Sep 17 00:00:00 2001
> From: Ola Olsson <ola.olsson@sonymobile.com>
> Date: Thu, 1 Oct 2015 00:43:06 +0200
> Subject: [PATCH] iw: Memory leak in error condition Signed-off-by: Ola
>  Olsson <ola.olsson@sonymobile.com>
> 
> ---
>  scan.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/scan.c b/scan.c
> index e959c1b..f248981 100644
> --- a/scan.c
> +++ b/scan.c
> @@ -446,6 +446,8 @@ static int handle_scan(struct nl80211_state *state,
>         if (ies || meshid) {
>                 tmpies = (unsigned char *) malloc(ies_len + meshid_len);
>                 if (!tmpies)
> +                       free(ies);
> +                       free(meshid);
>                         goto nla_put_failure;

Braces?  { }


>                 if (ies) {
>                         memcpy(tmpies, ies, ies_len);
> -- 
> 1.7.9.5
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
James Cameron
http://quozl.linux.org.au/
