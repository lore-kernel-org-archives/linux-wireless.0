Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49436 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342Ab1FTBKL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2011 21:10:11 -0400
Received: by iwn6 with SMTP id 6so783927iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2011 18:10:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1308352468-8926-1-git-send-email-bzhao@marvell.com>
References: <1308352468-8926-1-git-send-email-bzhao@marvell.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 20 Jun 2011 11:09:51 +1000
Message-ID: <BANLkTi=3cQkhEOkSb08A=8VLrqzkwXJEhw@mail.gmail.com> (sfid-20110620_031015_643742_9806E0FF)
Subject: Re: [PATCH] mwifiex: remove casts of void pointers
To: Bing Zhao <bzhao@marvell.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Joe Perches <joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bing,

Good work!

There's one minor issue I've seen:

On Sat, Jun 18, 2011 at 09:14, Bing Zhao <bzhao@marvell.com> wrote:
> diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
> index 8af3a78..d5c987a 100644
> --- a/drivers/net/wireless/mwifiex/sta_cmd.c
> +++ b/drivers/net/wireless/mwifiex/sta_cmd.c
> @@ -300,7 +291,7 @@ static int mwifiex_cmd_tx_power_cfg(struct host_cmd_ds_command *cmd,
>                                  sizeof(struct mwifiex_types_power_group) +
>                                  pg_tlv->length);
>                } else {
> -                       memmove(cmd_txp_cfg, data_buf,
> +                       memmove(cmd_txp_cfg, txp,
>                                sizeof(struct host_cmd_ds_txpwr_cfg));

this could be replace with

memmove(cmd_txp_cfg, txp, sizeof(*txp));

I think (I might be wrong about the argument to sizeof().)


Also, there are a number of functions touched by this patch that
return a value through the former *data_buf parameter. Is it possible
to refactor them to return the value directly? This would make the
function flow a lot cleaner and easier to follow.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
