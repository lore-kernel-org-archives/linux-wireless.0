Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48321 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab1AGCdd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 21:33:33 -0500
Received: by wyb28 with SMTP id 28so17003915wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jan 2011 18:33:32 -0800 (PST)
Subject: Re: [PATCH 1/3] ath9k: Decrease skb size to fit into one page.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	greearb@candelatech.com, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net
In-Reply-To: <1294367080.2704.46.camel@edumazet-laptop>
References: <1294361165-15308-1-git-send-email-greearb@candelatech.com>
	 <201101070205.00886.chunkeey@googlemail.com>
	 <1294363427.2704.23.camel@edumazet-laptop>
	 <AANLkTinQ42y9Tu=Ugb92-R+56BP4U+cDBzd4tQQCES1W@mail.gmail.com>
	 <1294366072.2704.32.camel@edumazet-laptop>
	 <AANLkTi=+F_O1_2c07zLEGVDSAkuA2_MwghwRQK9pHMN7@mail.gmail.com>
	 <1294367080.2704.46.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 03:33:28 +0100
Message-ID: <1294367608.2704.47.camel@edumazet-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Le vendredi 07 janvier 2011 à 03:24 +0100, Eric Dumazet a écrit :

> Given IEEE80211_MAX_MPDU_LEN is more than 3840, and skb shinfo adds more
> than 256 bytes, I can assert rx_bufsize is greater than 4096 : order-1

On 64bit arches :

sizeof(struct skb_shared_info) = 0x198 = 408



