Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 620B2C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 14:20:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3000A2084D
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 14:20:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AgX6rDSr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfCYOUW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 10:20:22 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39291 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfCYOUW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 10:20:22 -0400
Received: by mail-wm1-f68.google.com with SMTP id t124so9263645wma.4;
        Mon, 25 Mar 2019 07:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7cUqakoGwW9v2V+piiFQS3g8t87PA5xNvW5kZqir9uA=;
        b=AgX6rDSr1NxOEoBGnEuR05Z5RhyEzjC839L5eQxHkHukx2E7cChdNC+d0rybL6E1Dx
         k1OQGb/Q0qghZHzh2zWaLH9JkEfv0rMcJARK/a7asrAebzQZtVX3gLaPB1EkMg0FDS8K
         Q/S+qsnCfWof4ME+SUrW8KH2j0p7TYmdzZf3xfaNnCNufcreFQYeSlyuvwaZ5MwBcPjJ
         byalfieVD+2rjHCCtFxlaCaAwgpu9bAZQCAlMR9h4TVM8nQe6e5C+B6c61C+Tg7uLs1L
         XXY4fGSZ85gP9TLiFIIz/1Zm76vUTPEv5nsHhJzZjAI9rUlb07pnuot3sCHopf4Zf+pO
         lbKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7cUqakoGwW9v2V+piiFQS3g8t87PA5xNvW5kZqir9uA=;
        b=h5eWv9SyksRW/mUtw2LVHbtMUkxLj0fD9l7hsAREgmKZvhAmjsbQRNOTewC+ofIWyC
         0+hC7rEHFWQDRMMqZEcLRe++p8puwTCb1PLEUWdLxYyG0BrDoa5jMHZST59t6J/u2+6G
         6tn5yclKjznj3AftELOQY7B/vpXjvHG0m08i977GYNW9GQ9AxoKyNOIxGTsppHZAEaq5
         bblRRxZDX2BqQ6b7a9zeP/JlNzPY56YU4fI7jho5tokQRA4GXSN8hhlXe2OK4DAmsyi/
         EBMeeVHHiXSJeNMdkTos0v7p0PzMcGfOn0U7aqM07Smf0rKx8C8sYk+USWmDkEKPnRGT
         mv2Q==
X-Gm-Message-State: APjAAAUCPWGHY6dP3qRAFTXXKlc9L+MFHgizDgkypQFkCIT08eyUOqad
        ejp8R4JTPjaAaQzcGUmpQno=
X-Google-Smtp-Source: APXvYqzowF1ICCpiNoLPRrwzK5kNhmqFO7Xuw4fwKhmp1cQ4+uXY0cP2fIy2Y6Lbbr+nSfoCjW9xYQ==
X-Received: by 2002:a7b:c7d0:: with SMTP id z16mr12222967wmk.136.1553523619602;
        Mon, 25 Mar 2019 07:20:19 -0700 (PDT)
Received: from debian64.daheim (p4FD09746.dip0.t-ipconnect.de. [79.208.151.70])
        by smtp.gmail.com with ESMTPSA id 13sm2941499wmf.23.2019.03.25.07.20.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Mar 2019 07:20:18 -0700 (PDT)
Received: from localhost.daheim ([127.0.0.1] helo=debian64.localnet)
        by debian64.daheim with esmtp (Exim 4.92)
        (envelope-from <chunkeey@gmail.com>)
        id 1h8QSI-0006ww-Fs; Mon, 25 Mar 2019 15:20:02 +0100
From:   Christian Lamparter <chunkeey@gmail.com>
To:     Arnd Bergmann <arnd@arndb.de>, Kalle Valo <kvalo@codeaurora.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless: carl9170: fix clang build warning
Date:   Mon, 25 Mar 2019 15:20:02 +0100
Message-ID: <10158331.jkizvXajyz@debian64>
In-Reply-To: <20190325124354.1413529-1-arnd@arndb.de>
References: <20190325124354.1413529-1-arnd@arndb.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Monday, March 25, 2019 1:43:44 PM CET Arnd Bergmann wrote:
> clang fails to eliminate some dead code with always-taken branches
> when CONFIG_PROFILE_ANNOTATED_BRANCHES is set, leading to a false-positive
> warning:
> 
> drivers/net/wireless/ath/carl9170/mac.c:522:3: error: variable 'power' is used uninitialized whenever 'if' condition is
>       false [-Werror,-Wsometimes-uninitialized]
>                 BUG_ON(1);
>                 ^~~~~~~~~
> 
> Change both instances of BUG_ON(1) in carl9170 to the simpler BUG()
> to avoid the warning.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Heh, I added these "default:" cases back in the day to make gcc
shut-up about "switch is missing cases" warnings. And now I
guess it's clangs time to complain. (-; 

Especially the "default case" in carl9170_rx_untie_data is hilarious.
Since all the possible cases (just 4!) have been addressed and the
"default" is deadcode. I think gcc did not consider the
AR9170_RX_STATUS_MPDU mask in the 
| switch (mac_status & AR9170_RX_STATUS_MPDU) {

statement. However I'll be waiting for the day until the deadcode
elimination warnings will show up.

Anyway,

Acked-by: Christian Lamparter <chunkeey@gmail.com>

Regards,
Christian

> ---
>  drivers/net/wireless/ath/carl9170/mac.c | 2 +-
>  drivers/net/wireless/ath/carl9170/rx.c  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/mac.c b/drivers/net/wireless/ath/carl9170/mac.c
> index 7d4a72dc98db..b2eeb9fd68d2 100644
> --- a/drivers/net/wireless/ath/carl9170/mac.c
> +++ b/drivers/net/wireless/ath/carl9170/mac.c
> @@ -519,7 +519,7 @@ int carl9170_set_mac_tpc(struct ar9170 *ar, struct ieee80211_channel *channel)
>  		power = ar->power_5G_leg[0] & 0x3f;
>  		break;
>  	default:
> -		BUG_ON(1);
> +		BUG();
>  	}
>  
>  	power = min_t(unsigned int, power, ar->hw->conf.power_level * 2);
> diff --git a/drivers/net/wireless/ath/carl9170/rx.c b/drivers/net/wireless/ath/carl9170/rx.c
> index 8e154f6364a3..23ab8a80c18c 100644
> --- a/drivers/net/wireless/ath/carl9170/rx.c
> +++ b/drivers/net/wireless/ath/carl9170/rx.c
> @@ -795,7 +795,7 @@ static void carl9170_rx_untie_data(struct ar9170 *ar, u8 *buf, int len)
>  		break;
>  
>  	default:
> -		BUG_ON(1);
> +		BUG();
>  		break;
>  	}
>  
> 




