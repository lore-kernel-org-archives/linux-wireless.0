Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5988 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbbHSLUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 07:20:46 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Make fw stats prints specific to firmware version
References: <1436342781-16086-1-git-send-email-c_mpubbi@qti.qualcomm.com>
Date: Wed, 19 Aug 2015 14:20:39 +0300
In-Reply-To: <1436342781-16086-1-git-send-email-c_mpubbi@qti.qualcomm.com>
	(Manikanta Pubbisetty's message of "Wed, 8 Jul 2015 13:36:21 +0530")
Message-ID: <87a8tna5iw.fsf@kamboji.qca.qualcomm.com> (sfid-20150819_132208_241580_1790B40A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com> writes:

> Currently fw stats printing in ath10k is common to all firmware
> versions. Eventually we end up printing the stats which are not
> intended to be printed. For example, we might print stats of 10.2.4
> in 10.2, additional stats will have the value of zeros and this
> might lead to confusion.
>
> The patch makes debug stats prints fw specific by adding a new member
> in wmi_ops.
>
> Signed-off-by: Manikanta Pubbisetty <c_mpubbi@qti.qualcomm.com>

kbuild found quite a few warnings:

>> drivers/built-in.o:(.rodata+0x7ca10): undefined reference to `ath10k_debug_10x_fw_stats_fill'
   drivers/built-in.o:(.rodata+0x7cb30): undefined reference to `ath10k_debug_10x_fw_stats_fill'
   drivers/built-in.o:(.rodata+0x7cc50): undefined reference to `ath10k_debug_10x_fw_stats_fill'
>> drivers/built-in.o:(.rodata+0x7cd70): undefined reference to `ath10k_debug_fw_stats_fill'
   drivers/built-in.o:(.rodata+0x7ced0): undefined reference to `ath10k_debug_fw_stats_fill'

   drivers/net/wireless/ath/ath10k/debug.c: In function 'ath10k_debug_fw_pdev_base_stats_fill':
>> drivers/net/wireless/ath/ath10k/debug.c:2045:16: error: 'ATH10K_FW_STATS_BUF_SIZE' undeclared (first use in this function)
     int buf_len = ATH10K_FW_STATS_BUF_SIZE;
                   ^
   drivers/net/wireless/ath/ath10k/debug.c:2045:16: note: each undeclared identifier is reported only once for each function it appears in
   drivers/net/wireless/ath/ath10k/debug.c: In function 'ath10k_debug_fw_pdev_extra_stats_fill':
   drivers/net/wireless/ath/ath10k/debug.c:2076:16: error: 'ATH10K_FW_STATS_BUF_SIZE' undeclared (first use in this function)
     int buf_len = ATH10K_FW_STATS_BUF_SIZE;
                   ^
   drivers/net/wireless/ath/ath10k/debug.c: In function 'ath10k_debug_fw_pdev_tx_stats_fill':
   drivers/net/wireless/ath/ath10k/debug.c:2098:16: error: 'ATH10K_FW_STATS_BUF_SIZE' undeclared (first use in this function)
     int buf_len = ATH10K_FW_STATS_BUF_SIZE;
                   ^
   drivers/net/wireless/ath/ath10k/debug.c: In function 'ath10k_debug_fw_pdev_rx_stats_fill':
   drivers/net/wireless/ath/ath10k/debug.c:2159:16: error: 'ATH10K_FW_STATS_BUF_SIZE' undeclared (first use in this function)
     int buf_len = ATH10K_FW_STATS_BUF_SIZE;
                   ^
   drivers/net/wireless/ath/ath10k/debug.c: In function 'ath10k_debug_fw_vdev_stats_fill_common':
   drivers/net/wireless/ath/ath10k/debug.c:2203:16: error: 'ATH10K_FW_STATS_BUF_SIZE' undeclared (first use in this function)
     int buf_len = ATH10K_FW_STATS_BUF_SIZE;
                   ^
   drivers/net/wireless/ath/ath10k/debug.c: In function 'ath10k_debug_fw_peer_stats_fill_common':
   drivers/net/wireless/ath/ath10k/debug.c:2264:16: error: 'ATH10K_FW_STATS_BUF_SIZE' undeclared (first use in this function)
     int buf_len = ATH10K_FW_STATS_BUF_SIZE;
                   ^
   drivers/net/wireless/ath/ath10k/debug.c: At top level:
>> drivers/net/wireless/ath/ath10k/debug.c:2278:6: error: redefinition of 'ath10k_debug_fw_stats_fill'
    void ath10k_debug_fw_stats_fill(struct ath10k *ar,
         ^
   In file included from drivers/net/wireless/ath/ath10k/debug.c:24:0:
   drivers/net/wireless/ath/ath10k/debug.h:138:1: note: previous definition of 'ath10k_debug_fw_stats_fill' was here
    ath10k_debug_fw_stats_fill(struct ath10k *ar,
    ^
   drivers/net/wireless/ath/ath10k/debug.c: In function 'ath10k_debug_fw_stats_fill':
   drivers/net/wireless/ath/ath10k/debug.c:2283:16: error: 'ATH10K_FW_STATS_BUF_SIZE' undeclared (first use in this function)
     int buf_len = ATH10K_FW_STATS_BUF_SIZE;
                   ^
>> drivers/net/wireless/ath/ath10k/debug.c:2299:2: error: implicit declaration of function 'ath10k_debug_fw_stats_num_peers' [-Werror=implicit-function-declaration]
     num_peers = ath10k_debug_fw_stats_num_peers(&fw_stats->peers);
     ^
>> drivers/net/wireless/ath/ath10k/debug.c:2300:2: error: implicit declaration of function 'ath10k_debug_fw_stats_num_vdevs' [-Werror=implicit-function-declaration]
     num_vdevs = ath10k_debug_fw_stats_num_vdevs(&fw_stats->vdevs);
     ^
   drivers/net/wireless/ath/ath10k/debug.c: At top level:
>> drivers/net/wireless/ath/ath10k/debug.c:2335:6: error: redefinition of 'ath10k_debug_10x_fw_stats_fill'
    void ath10k_debug_10x_fw_stats_fill(struct ath10k *ar,
         ^
   In file included from drivers/net/wireless/ath/ath10k/debug.c:24:0:
   drivers/net/wireless/ath/ath10k/debug.h:145:1: note: previous definition of 'ath10k_debug_10x_fw_stats_fill' was here
    ath10k_debug_10x_fw_stats_fill(struct ath10k *ar,
    ^
   drivers/net/wireless/ath/ath10k/debug.c: In function 'ath10k_debug_10x_fw_stats_fill':
   drivers/net/wireless/ath/ath10k/debug.c:2340:25: error: 'ATH10K_FW_STATS_BUF_SIZE' undeclared (first use in this function)
     unsigned int buf_len = ATH10K_FW_STATS_BUF_SIZE;
                            ^
   cc1: some warnings being treated as errors

> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -6225,6 +6225,7 @@ static const struct wmi_ops wmi_ops = {
>  	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
>  	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
>  	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
> +	.fw_stats_fill = ath10k_debug_fw_stats_fill,
>  	/* .gen_bcn_tmpl not implemented */
>  	/* .gen_prb_tmpl not implemented */
>  	/* .gen_p2p_go_bcn_ie not implemented */
> @@ -6289,6 +6290,7 @@ static const struct wmi_ops wmi_10_1_ops = {
>  	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
>  	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
>  	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
> +	.fw_stats_fill = ath10k_debug_10x_fw_stats_fill,
>  	/* .gen_bcn_tmpl not implemented */
>  	/* .gen_prb_tmpl not implemented */
>  	/* .gen_p2p_go_bcn_ie not implemented */
> @@ -6354,6 +6356,7 @@ static const struct wmi_ops wmi_10_2_ops = {
>  	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
>  	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
>  	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
> +	.fw_stats_fill = ath10k_debug_10x_fw_stats_fill,
>  };
>  
>  static const struct wmi_ops wmi_10_2_4_ops = {
> @@ -6414,6 +6417,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
>  	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
>  	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
>  	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
> +	.fw_stats_fill = ath10k_debug_10x_fw_stats_fill,
>  	/* .gen_bcn_tmpl not implemented */
>  	/* .gen_prb_tmpl not implemented */
>  	/* .gen_p2p_go_bcn_ie not implemented */

I don't really like the idea of wmi_ops directly pointing to debug.c.
What if all the filler functions would be moved to corresponding wmi*.c
files instead (and renamed to ath10k_wmi_*_fw_stats_fill)?

-- 
Kalle Valo
