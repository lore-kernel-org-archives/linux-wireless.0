Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f177.google.com ([209.85.160.177]:43581 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193AbbAHIGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 03:06:53 -0500
Received: by mail-yk0-f177.google.com with SMTP id 9so638806ykp.8
        for <linux-wireless@vger.kernel.org>; Thu, 08 Jan 2015 00:06:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420672721-8400-1-git-send-email-andy.shevchenko@gmail.com>
References: <1420672721-8400-1-git-send-email-andy.shevchenko@gmail.com>
Date: Thu, 8 Jan 2015 10:06:52 +0200
Message-ID: <CAHp75Vc=mzubGFeSa08UXVmWerW8oJbrn01F6umdPO2m9ZhK=A@mail.gmail.com> (sfid-20150108_090656_432948_8914DF3E)
Subject: Re: [PATCH v1] libertas: avoid potential null-pointer dereference
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 8, 2015 at 1:18 AM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> We have to check pointer before dereferencing it.

It seems it's correct in initial form. Discard this and sorry for noise.

>
> Reported-by: Andrey Karpov <karpov@viva64.com>
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> ---
>  drivers/net/wireless/libertas/cfg.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/libertas/cfg.c b/drivers/net/wireless/libertas/cfg.c
> index 34f09ef..1d335e6 100644
> --- a/drivers/net/wireless/libertas/cfg.c
> +++ b/drivers/net/wireless/libertas/cfg.c
> @@ -1109,7 +1109,7 @@ static int lbs_associate(struct lbs_private *priv,
>         size_t len, resp_ie_len;
>         int status;
>         int ret;
> -       u8 *pos = &(cmd->iebuf[0]);
> +       u8 *pos;
>         u8 *tmp;
>
>         lbs_deb_enter(LBS_DEB_CFG80211);
> @@ -1138,6 +1138,8 @@ static int lbs_associate(struct lbs_private *priv,
>         cmd->listeninterval = cpu_to_le16(MRVDRV_DEFAULT_LISTEN_INTERVAL);
>         cmd->capability = cpu_to_le16(bss->capability);
>
> +       pos = cmd->iebuf;
> +
>         /* add SSID TLV */
>         rcu_read_lock();
>         ssid_eid = ieee80211_bss_get_ie(bss, WLAN_EID_SSID);
> --
> 1.8.3.101.g727a46b
>



-- 
With Best Regards,
Andy Shevchenko
