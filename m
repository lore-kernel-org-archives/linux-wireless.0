Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f169.google.com ([74.125.82.169]:58706 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbaAQSwX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jan 2014 13:52:23 -0500
Received: by mail-we0-f169.google.com with SMTP id u57so4997991wes.14
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jan 2014 10:52:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1389909758-6807-1-git-send-email-chaitanya.mgit@gmail.com>
References: <1389909758-6807-1-git-send-email-chaitanya.mgit@gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Sat, 18 Jan 2014 00:22:02 +0530
Message-ID: <CABPxzYKwscRHAEEKs-y377Fa4rRLQBOp=5iUnVhYn+wjeTeG0A@mail.gmail.com> (sfid-20140117_195227_138589_010A7A42)
Subject: Re: [PATCH] cfg80211: Do not call CRDA when using internal regulatory database
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: Chaitanya T K <chaitanya.mgit@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 17, 2014 at 3:32 AM, Chaitanya T K <chaitanya.mgit@gmail.com> wrote:
>
> When using internal regulatory data base kconfig option
> do not try to call crda, this complely defeats the
> purposes of enabling internal regulatory db.
>
> Signed-off-by: Chaitanya T K <chaitanya.mgit@gmail.com>
>
> ---
>  net/wireless/reg.c |   29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
>
> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
> index 7d20d84..1cb0f99 100644
> --- a/net/wireless/reg.c
> +++ b/net/wireless/reg.c
> @@ -454,16 +454,16 @@ static void reg_regdb_search(struct work_struct *work)
>
>  static DECLARE_WORK(reg_regdb_work, reg_regdb_search);
>
> -static void reg_regdb_query(const char *alpha2)
> +static int reg_regdb_query(const char *alpha2)
>  {
>         struct reg_regdb_search_request *request;
>
>         if (!alpha2)
> -               return;
> +               return -1;
>
>         request = kzalloc(sizeof(struct reg_regdb_search_request), GFP_KERNEL);
>         if (!request)
> -               return;
> +               return -1;
>
I guess the return values must be 1 so that in case of failure
we ignore the reg update. Will wait for sometime for other
comments and send V2.
