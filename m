Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:54707 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYLWFeW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 00:34:22 -0500
Received: by yw-out-2324.google.com with SMTP id 9so816880ywe.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 21:34:21 -0800 (PST)
Message-ID: <43e72e890812222127k60ade0f1u21263800f9374f52@mail.gmail.com> (sfid-20081223_063427_817569_F23C47DA)
Date: Mon, 22 Dec 2008 21:27:18 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Pavel Roskin" <proski@gnu.org>
Subject: Re: [PATCH] crda: use strerror() to report error code verbosely
Cc: linux-wireless@vger.kernel.org,
	"John W Linville" <linville@tuxdriver.com>
In-Reply-To: <20081223050006.3710.98311.stgit@ct.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081223050006.3710.98311.stgit@ct.roinet.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 22, 2008 at 9:00 PM, Pavel Roskin <proski@gnu.org> wrote:
> Signed-off-by: Pavel Roskin <proski@gnu.org>
> ---
>  crda.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/crda.c b/crda.c
> index afc5df1..fe2766b 100644
> --- a/crda.c
> +++ b/crda.c
> @@ -6,6 +6,7 @@
>
>  #include <errno.h>
>  #include <stdio.h>
> +#include <string.h>
>  #include <sys/mman.h>
>  #include <sys/stat.h>
>  #include <fcntl.h>
> @@ -297,7 +298,8 @@ int main(int argc, char **argv)
>        r = nl_send_auto_complete(nlstate.nl_handle, msg);
>
>        if (r < 0) {
> -               fprintf(stderr, "Failed to send regulatory request: %d\n", r);
> +               fprintf(stderr, "Failed to send regulatory request: %s\n",
> +                       strerror(-r));
>                goto cb_out;
>        }
>
> @@ -309,7 +311,7 @@ int main(int argc, char **argv)
>                r = nl_wait_for_ack(nlstate.nl_handle);
>                if (r < 0) {
>                        fprintf(stderr, "Failed to set regulatory domain: "
> -                               "%d\n", r);
> +                               "%s\n", strerror(-r));
>                        goto cb_out;
>                }
>        }

I've been trying to avoid string.h on crda.c, granted it only
increases the final crda binary by about 30 bytes, but do we really
need it? In fact it'd be nice to further trim crda further to save
even more space. Thoughts?

  Luis
