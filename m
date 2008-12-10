Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:45553 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751730AbYLJEaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Dec 2008 23:30:11 -0500
Message-ID: <493F45C9.6010703@lwfinger.net> (sfid-20081210_053027_471385_D4219374)
Date: Tue, 09 Dec 2008 22:30:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, ath5k-devel@lists.ath5k.org
Subject: Re: [PATCH] ath5k: fix endianness of bitwise ops when installing
 mic
References: <20081210040538.GA11810@hash.localnet>
In-Reply-To: <20081210040538.GA11810@hash.localnet>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bob Copeland wrote:
> Fix these bugs found by sparse:
> 
>     ath5k/pcu.c:1102:21: warning: restricted __le32 degrades to integer
>     ath5k/pcu.c:1102:13: warning: incorrect type in assignment (different base types)
>     ath5k/pcu.c:1102:13:    expected restricted __le32 <noident>
>     ath5k/pcu.c:1102:13:    got unsigned int
>     ath5k/pcu.c:1104:20: warning: restricted __le32 degrades to integer
>     ath5k/pcu.c:1104:13: warning: incorrect type in assignment (different base types)
>     ath5k/pcu.c:1104:13:    expected restricted __le32 <noident>
>     ath5k/pcu.c:1104:13:    got unsigned int
> 
> Changes-licensed-under: ISC
> 
> Reported-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Bob Copeland <me@bobcopeland.com>
> ---
>  drivers/net/wireless/ath5k/pcu.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath5k/pcu.c b/drivers/net/wireless/ath5k/pcu.c
> index dabe422..0cac05c 100644
> --- a/drivers/net/wireless/ath5k/pcu.c
> +++ b/drivers/net/wireless/ath5k/pcu.c
> @@ -1099,9 +1099,9 @@ int ath5k_hw_set_key(struct ath5k_hw *ah, u16 entry,
>  
>  		if (ah->ah_combined_mic) {
>  			key_v[0] = rxmic[0];
> -			key_v[1] = (txmic[0] >> 16) & 0xffff;
> +			key_v[1] = cpu_to_le32(le32_to_cpu(txmic[0]) >> 16);

Is it certain that txmic[0] will not sign extend with the >> 16 operation? Is
that why you dropped the mask with 0xffff?

Larry

