Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33140 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbbF3M3i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 08:29:38 -0400
Received: by ieqy10 with SMTP id y10so10986354ieq.0
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2015 05:29:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1838270231.63341435666635059.JavaMail.weblogic@ep2mlwas06c>
References: <1838270231.63341435666635059.JavaMail.weblogic@ep2mlwas06c>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 30 Jun 2015 22:29:18 +1000
Message-ID: <CAGRGNgVvugS6G19E-_B01+WQS4t9SzcYpudH6kiw1tXLPus41A@mail.gmail.com> (sfid-20150630_142941_889532_5E048F0A)
Subject: Re: [PATCH] iw: Static analyser fixes
To: amit.khatri@samsung.com
Cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Rahul Jain <rahul.jain@samsung.com>,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Amit,

On Tue, Jun 30, 2015 at 10:17 PM, Amit Khatri <amit.khatri@samsung.com> wrote:
> Hi Johannes,
>
> Subject: [PATCH] iw: Static analyser fixes
>
> Signed-off-by: Amit Khatri <amit.khatri@samsung.com>
> Signed-off-by: Rahul Jain <rahul.jain@samsung.com>
> ---
>  cqm.c   | 2 ++
>  event.c | 6 +++++-
>  iw.c    | 2 +-
>  scan.c  | 2 ++
>  4 files changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/event.c b/event.c
> index f73e078..06d236b 100644
> --- a/event.c
> +++ b/event.c
> @@ -49,8 +49,10 @@ static void print_frame(struct print_event_args *args, struct nlattr *attr)
>         char macbuf[6*3];
>         uint16_t tmp;
>
> -       if (!attr)
> +       if (!attr) {
>                 printf(" [no frame]");
> +               goto out;
> +       }
>
>         frame = nla_data(attr);
>         len = nla_len(attr);
> @@ -97,6 +99,8 @@ static void print_frame(struct print_event_args *args, struct nlattr *attr)
>         for (i = 0; i < len; i++)
>                 printf(" %.02x", frame[i]);
>         printf("]");
> + out:
> +       ;  /*empty statement to avoid compiler error */

Er, why not just return in the if (!attr) block?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
