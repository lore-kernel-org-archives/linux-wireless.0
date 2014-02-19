Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 0.mx.nanl.de ([217.115.11.12]:42019 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbaBSMN2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Feb 2014 07:13:28 -0500
Received: from mail-qc0-f174.google.com (mail-qc0-f174.google.com [209.85.216.174])
	by mail.nanl.de (Postfix) with ESMTPSA id 7AAB246063
	for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 12:13:18 +0000 (UTC)
Received: by mail-qc0-f174.google.com with SMTP id x13so272990qcv.19
        for <linux-wireless@vger.kernel.org>; Wed, 19 Feb 2014 04:13:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140219103717.GA3284@markyou.marvell.com>
References: <20140219103717.GA3284@markyou.marvell.com>
From: Jonas Gorski <jogo@openwrt.org>
Date: Wed, 19 Feb 2014 13:12:56 +0100
Message-ID: <CAOiHx==5geqrnqQyp6y_GoAZC0adWPzq8vXo1fPVA_t9Uhs-ww@mail.gmail.com> (sfid-20140219_131331_316637_DC9628C2)
Subject: Re: [PATCH 1/3] mwl8k: Adding support to access BBP registers
To: Yogesh Ashok Powar <yogeshp@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Nishant Sarmukadam <nishants@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 19, 2014 at 11:37 AM, Yogesh Ashok Powar
<yogeshp@marvell.com> wrote:
> Adding AP firmware command to access BBP
> regs. This will be used for retrieving
> different counters CCA/RX needed for ACS
>
> Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
> Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
> ---
>  drivers/net/wireless/mwl8k.c | 40 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
>
> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
> index 4987c3f..159125e 100644
> --- a/drivers/net/wireless/mwl8k.c
> +++ b/drivers/net/wireless/mwl8k.c
> @@ -2987,6 +2988,45 @@ static int mwl8k_cmd_set_pre_scan(struct ieee80211_hw *hw)
>  }
>
>  /*
> + * CMD_BBP_REG_ACCESS.
> + */
> +struct mwl8k_cmd_bbp_reg_access {
> +       struct mwl8k_cmd_pkt header;
> +       __le16 action;
> +       __le16 offset;
> +       u8 value;
> +       u8 rsrv[3];
> +} __packed;
> +
> +static int
> +mwl8k_cmd_bbp_reg_access(struct ieee80211_hw *hw,
> +                        u16 action,
> +                        u16 offset,
> +                        u8 *value)
> +{
> +       struct mwl8k_cmd_bbp_reg_access *cmd;
> +       int rc;
> +
> +       cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
> +       if (cmd == NULL)
> +               return -ENOMEM;
> +
> +       cmd->header.code = cpu_to_le16(MWL8K_CMD_BBP_REG_ACCESS);
> +       cmd->header.length = cpu_to_le16(sizeof(*cmd));
> +       cmd->action = cpu_to_le16(action);
> +       cmd->offset = cpu_to_le16(offset);
> +
> +       rc = mwl8k_post_cmd(hw, &cmd->header);
> +
> +       if (!rc)
> +               *value = cmd->value;
> +       else
> +               *value = 0;
> +
> +       return rc;

You don't free the allocated cmd anywhere, so you are leaking memory
on every call.


Regards
Jonas
