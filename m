Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54213 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789Ab1CRQNe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Mar 2011 12:13:34 -0400
Received: by yxs7 with SMTP id 7so1638784yxs.19
        for <linux-wireless@vger.kernel.org>; Fri, 18 Mar 2011 09:13:33 -0700 (PDT)
Message-ID: <4D8384A8.8000901@lwfinger.net>
Date: Fri, 18 Mar 2011 11:13:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
	stable@kernel.org
Subject: Re: [PATCH] rtlwifi: use correct argument order for memset in efuse.c
References: <1300463566-16689-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1300463566-16689-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/18/2011 10:52 AM, John W. Linville wrote:
> Reported-by: Al Viro<viro@ZenIV.linux.org.uk>
> Signed-off-by: John W. Linville<linville@tuxdriver.com>
> Cc: stable@kernel.org
> ---
>   drivers/net/wireless/rtlwifi/efuse.c |   14 +++++++-------
>   1 files changed, 7 insertions(+), 7 deletions(-)

ACK. My only question is whether 
http://marc.info/?l=linux-wireless&m=130038716529880&w=3 has precedence. 
Unfortunately, it went only to linux-wireless and not to Linville.

Let me know which one you plan to use.

Larry

>
> diff --git a/drivers/net/wireless/rtlwifi/efuse.c b/drivers/net/wireless/rtlwifi/efuse.c
> index 4f92cba..ef91905 100644
> --- a/drivers/net/wireless/rtlwifi/efuse.c
> +++ b/drivers/net/wireless/rtlwifi/efuse.c
> @@ -479,8 +479,8 @@ void rtl_efuse_shadow_map_update(struct ieee80211_hw *hw)
>   	struct rtl_efuse *rtlefuse = rtl_efuse(rtl_priv(hw));
>
>   	if (rtlefuse->autoload_failflag == true) {
> -		memset((void *)(&rtlefuse->efuse_map[EFUSE_INIT_MAP][0]), 128,
> -		       0xFF);
> +		memset((void *)(&rtlefuse->efuse_map[EFUSE_INIT_MAP][0]), 0xFF,
> +		       128);
>   	} else
>   		efuse_read_all_map(hw,&rtlefuse->efuse_map[EFUSE_INIT_MAP][0]);
>
> @@ -694,8 +694,8 @@ static int efuse_pg_packet_read(struct ieee80211_hw *hw, u8 offset, u8 *data)
>   	if (offset>  15)
>   		return false;
>
> -	memset((void *)data, PGPKT_DATA_SIZE * sizeof(u8), 0xff);
> -	memset((void *)tmpdata, PGPKT_DATA_SIZE * sizeof(u8), 0xff);
> +	memset((void *)data, 0xff, PGPKT_DATA_SIZE * sizeof(u8));
> +	memset((void *)tmpdata, 0xff, PGPKT_DATA_SIZE * sizeof(u8));
>
>   	while (bcontinual&&  (efuse_addr<  EFUSE_MAX_SIZE)) {
>   		if (readstate&  PG_STATE_HEADER) {
> @@ -862,7 +862,7 @@ static void efuse_write_data_case2(struct ieee80211_hw *hw, u16 *efuse_addr,
>
>   		tmp_word_cnts = efuse_calculate_word_cnts(tmp_pkt.word_en);
>
> -		memset((void *)originaldata, 8 * sizeof(u8), 0xff);
> +		memset((void *)originaldata, 0xff, 8 * sizeof(u8));
>
>   		if (efuse_pg_packet_read(hw, tmp_pkt.offset, originaldata)) {
>   			badworden = efuse_word_enable_data_write(hw,
> @@ -917,7 +917,7 @@ static int efuse_pg_packet_write(struct ieee80211_hw *hw,
>   	target_pkt.offset = offset;
>   	target_pkt.word_en = word_en;
>
> -	memset((void *)target_pkt.data, 8 * sizeof(u8), 0xFF);
> +	memset((void *)target_pkt.data, 0xFF, 8 * sizeof(u8));
>
>   	efuse_word_enable_data_read(word_en, data, target_pkt.data);
>   	target_word_cnts = efuse_calculate_word_cnts(target_pkt.word_en);
> @@ -1022,7 +1022,7 @@ static u8 efuse_word_enable_data_write(struct ieee80211_hw *hw,
>   	u8 badworden = 0x0F;
>   	u8 tmpdata[8];
>
> -	memset((void *)tmpdata, PGPKT_DATA_SIZE, 0xff);
> +	memset((void *)tmpdata, 0xff, PGPKT_DATA_SIZE);
>   	RT_TRACE(rtlpriv, COMP_EFUSE, DBG_LOUD,
>   		 ("word_en = %x efuse_addr=%x\n", word_en, efuse_addr));
>

