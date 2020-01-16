Return-Path: <SRS0=LENq=3F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 778DCC33CB6
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 12:59:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 581CA2087E
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 12:59:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbgAPM72 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jan 2020 07:59:28 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:55164 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726688AbgAPM71 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jan 2020 07:59:27 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1is4jz-00C8Ha-5U; Thu, 16 Jan 2020 13:59:15 +0100
Message-ID: <d9e0af66e2d8cb26ef595e1a2133f55567f4b5e0.camel@sipsolutions.net>
Subject: Re: [PATCH -next] mac80111: fix build error without
 CONFIG_ATH11K_DEBUGFS
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Chen Zhou <chenzhou10@huawei.com>, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 16 Jan 2020 13:59:13 +0100
In-Reply-To: <20200116125155.166749-1-chenzhou10@huawei.com>
References: <20200116125155.166749-1-chenzhou10@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-01-16 at 20:51 +0800, Chen Zhou wrote:
> If CONFIG_ATH11K_DEBUGFS is n, build fails:
> 
> drivers/net/wireless/ath/ath11k/debugfs_sta.c: In function ath11k_dbg_sta_open_htt_peer_stats:
> drivers/net/wireless/ath/ath11k/debugfs_sta.c:416:4: error: struct ath11k has no member named debug
>   ar->debug.htt_stats.stats_req = stats_req;
>       ^~
> and many more similar messages.
> 
> Select ATH11K_DEBUGFS under config MAC80211_DEBUGFS to fix this.

Heh, no. You need to find a way in ath11 to fix this.

johannes

