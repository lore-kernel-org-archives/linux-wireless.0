Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:46484 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781Ab2HXGCM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Aug 2012 02:02:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Wei Yongjun <weiyj.lk@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "yongjun_wei@trendmicro.com.cn" <yongjun_wei@trendmicro.com.cn>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Thu, 23 Aug 2012 23:01:57 -0700
Subject: RE: [PATCH v2] mwifiex: use is_broadcast_ether_addr() instead of
 memcmp()
Message-ID: <477F20668A386D41ADCC57781B1F7043083B0BBBB6@SC-VEXCH1.marvell.com> (sfid-20120824_080217_370128_C49B78DF)
References: <CAPgLHd81cZS4K-wzcLycRTVF3pGy-S6=YR9UZ++Ot=6OXZp-5Q@mail.gmail.com>
In-Reply-To: <CAPgLHd81cZS4K-wzcLycRTVF3pGy-S6=YR9UZ++Ot=6OXZp-5Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using is_broadcast_ether_addr() instead of directly use
> memcmp() to determine if the ethernet address is broadcast
> address.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/sta_cmd.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
> index df3a33c..323b91b 100644
> --- a/drivers/net/wireless/mwifiex/sta_cmd.c
> +++ b/drivers/net/wireless/mwifiex/sta_cmd.c
> @@ -551,7 +551,6 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
>  	struct host_cmd_tlv_mac_addr *tlv_mac;
>  	u16 key_param_len = 0, cmd_size;
>  	int ret = 0;
> -	const u8 bc_mac[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
> 
>  	cmd->command = cpu_to_le16(HostCmd_CMD_802_11_KEY_MATERIAL);
>  	key_material->action = cpu_to_le16(cmd_action);
> @@ -593,7 +592,7 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
>  			/* set 0 when re-key */
>  			key_material->key_param_set.key[1] = 0;
> 
> -		if (0 != memcmp(enc_key->mac_addr, bc_mac, sizeof(bc_mac))) {
> +		if (!is_broadcast_ether_addr(enc_key->mac_addr)) {
>  			/* WAPI pairwise key: unicast */
>  			key_material->key_param_set.key_info |=
>  				cpu_to_le16(KEY_UNICAST);
> 

