Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83568C636CC
	for <linux-wireless@archiver.kernel.org>; Wed, 15 Feb 2023 17:38:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjBORh7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 15 Feb 2023 12:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjBORh6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Feb 2023 12:37:58 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A492CFF8
        for <linux-wireless@vger.kernel.org>; Wed, 15 Feb 2023 09:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=zd92LPo7R+krbsALRLGyUaaTkdnACGv/4SBRzWXgf3U=;
        t=1676482677; x=1677692277; b=cGeY19paoNQFiUhgRxHFWPJxxiNSi34/s5cXgUzsVo/B1xZ
        GnV5MjKAPq3T+tD5XPdhsmg85IRJOO3yu0xtf104TvYJuNPfLauTzhOlAKfQwn/p1i1WtyKFdK0YV
        /BYXi9m4xathUjiPxGSOHHqgopdThtKU2gK/70UkEvac66noSk8+ESAQbk/YGfx+3bPJ5WpNL+3Cq
        MUn9HZ0d4tWkL+uuXCYMEmHMxxVicpTbyyz7jyL7DdBOe5K2rB/Pwj1h2tPKANfUIsA9pm1d6JV8G
        i3zbcoRchD8lGRbM+nP+uVeE29Lhgp6cWEseCQwoju0BeCYoBkx3AE81eLMguW7Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pSLj6-00D9MO-13;
        Wed, 15 Feb 2023 18:37:52 +0100
Message-ID: <3dbd12c5c46b28c36504a0ebaf7d3b13bc2f141e.camel@sipsolutions.net>
Subject: Re: [PATCH v3 3/3] wifi: ath11k: add support to enable/disable BSS
 color collision detection
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Rameshkumar Sundaram <quic_ramess@quicinc.com>,
        ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 15 Feb 2023 18:37:51 +0100
In-Reply-To: <20230201065638.25990-4-quic_ramess@quicinc.com>
References: <20230201065638.25990-1-quic_ramess@quicinc.com>
         <20230201065638.25990-4-quic_ramess@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2023-02-01 at 12:26 +0530, Rameshkumar Sundaram wrote:
> Enable/Disable BSS color collision detection based on user
> configuration of collision detection and BSS color feature
> itself.
>=20
> Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.1.0.1-01228-QCAHKSWPL_SILICONZ-1
>=20
> Signed-off-by: Rameshkumar Sundaram <quic_ramess@quicinc.com>
> ---
>  drivers/net/wireless/ath/ath11k/mac.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless=
/ath/ath11k/mac.c
> index 9e923ecb0891..6d5290996d9f 100644
> --- a/drivers/net/wireless/ath/ath11k/mac.c
> +++ b/drivers/net/wireless/ath/ath11k/mac.c
> @@ -3112,6 +3112,7 @@ static void ath11k_mac_op_bss_info_changed(struct i=
eee80211_hw *hw,
>  	u8 rateidx;
>  	u32 rate;
>  	u32 ipv4_cnt;
> +	bool color_collision_detect;
> =20
>  	mutex_lock(&ar->conf_mutex);
> =20
> @@ -3370,10 +3371,12 @@ static void ath11k_mac_op_bss_info_changed(struct=
 ieee80211_hw *hw,
> =20
>  	if (changed & BSS_CHANGED_HE_BSS_COLOR) {

You never set this flag in the prior change, and it also doesn't even
*mean* the BSS color _detection_ changed ..??

johannes

