Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756174Ab1GKXXB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2011 19:23:01 -0400
Subject: Re: [PATCH] libertas: fix errors in functions accessing module
 registers
From: Dan Williams <dcbw@redhat.com>
To: Olivier Sobrie <olivier@sobrie.be>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Date: Mon, 11 Jul 2011 18:26:24 -0500
In-Reply-To: <1310209025-16516-1-git-send-email-olivier@sobrie.be>
References: <1310209025-16516-1-git-send-email-olivier@sobrie.be>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1310426786.3122.4.camel@dcbw.foobar.com> (sfid-20110712_012305_883360_A5123E22)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-07-09 at 12:57 +0200, Olivier Sobrie wrote:
> Problems located in the two functions lbs_set_reg() and lbs_get_reg():
> - The offset field of struct cmd_ds_reg_access was not filled in
> - The test on the return code of lbs_cmd_with_response() in function
>   lbs_get_reg() was inverted
> 
> Signed-off-by: Olivier Sobrie <olivier@sobrie.be>

Acked-by: Dan Williams <dcbw@redhat.com>

> ---
>  drivers/net/wireless/libertas/cmd.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
> index 71c8f3f..3e8123c 100644
> --- a/drivers/net/wireless/libertas/cmd.c
> +++ b/drivers/net/wireless/libertas/cmd.c
> @@ -873,6 +873,7 @@ int lbs_get_reg(struct lbs_private *priv, u16 reg, u16 offset, u32 *value)
>  	memset(&cmd, 0, sizeof(cmd));
>  	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
>  	cmd.action = cpu_to_le16(CMD_ACT_GET);
> +	cmd.offset = cpu_to_le16(offset);
>  
>  	if (reg != CMD_MAC_REG_ACCESS &&
>  	    reg != CMD_BBP_REG_ACCESS &&
> @@ -882,7 +883,7 @@ int lbs_get_reg(struct lbs_private *priv, u16 reg, u16 offset, u32 *value)
>  	}
>  
>  	ret = lbs_cmd_with_response(priv, reg, &cmd);
> -	if (ret) {
> +	if (!ret) {
>  		if (reg == CMD_BBP_REG_ACCESS || reg == CMD_RF_REG_ACCESS)
>  			*value = cmd.value.bbp_rf;
>  		else if (reg == CMD_MAC_REG_ACCESS)
> @@ -915,6 +916,7 @@ int lbs_set_reg(struct lbs_private *priv, u16 reg, u16 offset, u32 value)
>  	memset(&cmd, 0, sizeof(cmd));
>  	cmd.hdr.size = cpu_to_le16(sizeof(cmd));
>  	cmd.action = cpu_to_le16(CMD_ACT_SET);
> +	cmd.offset = cpu_to_le16(offset);
>  
>  	if (reg == CMD_BBP_REG_ACCESS || reg == CMD_RF_REG_ACCESS)
>  		cmd.value.bbp_rf = (u8) (value & 0xFF);


