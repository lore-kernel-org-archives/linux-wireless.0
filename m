Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47565 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755285AbbJHJh0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2015 05:37:26 -0400
Message-ID: <1444297044.2131.16.camel@sipsolutions.net> (sfid-20151008_113729_465279_3F7C3D87)
Subject: Re: [PATCH] iw: Memory leak in error condition
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>, James Cameron <quozl@laptop.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 08 Oct 2015 11:37:24 +0200
In-Reply-To: <CABAco3Dd7urHu+y7J8TKYOXgh1QjRDvAp_Rs=q_gsU3f6Oum8Q@mail.gmail.com> (sfid-20151001_012741_497176_47BF5EB7)
References: <CABAco3AMgZSv9kCYkE6yQDcDE0+-7rA4ZzYazxSqAS99LHHMGQ@mail.gmail.com>
	 <20150930231613.GC20220@us.netrek.org>
	 <CABAco3Dd7urHu+y7J8TKYOXgh1QjRDvAp_Rs=q_gsU3f6Oum8Q@mail.gmail.com>
	 (sfid-20151001_012741_497176_47BF5EB7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-10-01 at 01:27 +0200, Ola Olsson wrote:
> Oh yes! :)
> Suddenly valgrind was happy as well.
> 
> From 2724dd259f2bf61a2b7c85a70a70fd640a583453 Mon Sep 17 00:00:00 
> 2001
> From: Ola Olsson <ola.olsson@sonymobile.com>
> Date: Thu, 1 Oct 2015 00:43:06 +0200
> Subject: [PATCH] iw: Memory leak in error condition Signed-off-by: 
> Ola Olsson
>  <ola.olsson@sonymobile.com>

This got picked up as a new patch by patchwork, but please resend.

As I mentioned on the other patch, you have whitespace issues (tabs
replaced by space, so the patch doesn't apply)

Also, on this particular patch you forgot the Signed-off-by.

Please also reword the subject to indicate that you fixed something, it
seems a bit strange to me to write just "memory leak" :)

Your "MHZ" patch also has the same whitespace issues, while the if.h
patch applied fine (though it wasn't changing any indented code, so
whitespace wouldn't have mattered)

Please resend this patch, the return values one and the MHz one.

Thanks,
johannes

> ---
>  scan.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/scan.c b/scan.c
> index e959c1b..f3441a7 100644
> --- a/scan.c
> +++ b/scan.c
> @@ -445,8 +445,11 @@ static int handle_scan(struct nl80211_state 
> *state,
> 
>         if (ies || meshid) {
>                 tmpies = (unsigned char *) malloc(ies_len + 
> meshid_len);
> -               if (!tmpies)
> +               if (!tmpies) {
> +                       free(ies);
> +                       free(meshid);
>                         goto nla_put_failure;
> +               }
>                 if (ies) {
>                         memcpy(tmpies, ies, ies_len);
>                         free(ies);
