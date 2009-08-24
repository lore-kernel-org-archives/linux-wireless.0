Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44563 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbZHXUPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2009 16:15:13 -0400
Date: Mon, 24 Aug 2009 16:00:19 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Kiran Divekar <kirandivekar@gmail.com>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] libertas: add NULL check on return value of
	get_zeroed_page
Message-ID: <20090824200019.GD8998@tuxdriver.com>
References: <1fe543780908230952v5738f6bck943627d0de6c1383@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1fe543780908230952v5738f6bck943627d0de6c1383@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 23, 2009 at 10:22:22PM +0530, Kiran Divekar wrote:
> From fb132b536facfbdc47a24afe538c50662d16b3ad Mon Sep 17 00:00:00 2001
> From: Kiran Divekar <kirandivekar@gmail.com>
> Date: Sun, 23 Aug 2009 22:05:21 +0530
> Subject: [PATCH] add NULL check on return value of get_zeroed_page
> 
> Most of the places in debugfs.c are missing a NULL check on the return value of
> get_zeroed_page API call. Added required NULL check at appropriate places.
> 
> Signed-off-by: Kiran Divekar <kirandivekar@gmail.com>

#1 -- Don't post the output of git format-patch directly like this.  Use git
	send-email instead.

> ---
>  drivers/net/wireless/libertas/debugfs.c |   28 ++++++++++++++++++++++++++++
>  1 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/debugfs.c
> b/drivers/net/wireless/libertas/debugfs.c
> index 811ffc3..893a55c 100644
> --- a/drivers/net/wireless/libertas/debugfs.c
> +++ b/drivers/net/wireless/libertas/debugfs.c
> @@ -45,6 +45,8 @@ static ssize_t lbs_dev_info(struct file *file, char
> __user *userbuf,
>         unsigned long addr = get_zeroed_page(GFP_KERNEL);
>         char *buf = (char *)addr;
>         ssize_t res;
> +       if (!buf)
> +               return -ENOMEM;
> 
>         pos += snprintf(buf+pos, len-pos, "state = %s\n",
>                                 szStates[priv->connect_status]);

#2 -- Don't use an MUA that alters whitespace in the message.

Feel free to repost...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
