Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43919 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab1AUGox (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 01:44:53 -0500
Received: by yxt3 with SMTP id 3so436858yxt.19
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 22:44:53 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19769.11058.386641.473164@gargle.gargle.HOWL>
Date: Fri, 21 Jan 2011 12:14:02 +0530
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [RFC/WIP 30/33] ath9k_htc: Fix host RX initialization
In-Reply-To: <20110121063059.GA20058@vasanth-laptop>
References: <19768.63373.791952.897019@gargle.gargle.HOWL>
	<20110121063059.GA20058@vasanth-laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vasanthakumar Thiagarajan wrote:
> I think we need to take care a bug in reg AR_STA_ID1 configuration.
> During hw reset, operating mode is set in AR_STA_ID1 but right after
> it's overwritten. See the following code segment in
> ath9k_hw_reset().
> 
>  ath9k_hw_set_operating_mode(ah, ah->opmode);
> 
>  ENABLE_REGWRITE_BUFFER(ah);
> 
>  REG_WRITE(ah, AR_STA_ID0, get_unaligned_le32(common->macaddr));
>  REG_WRITE(ah, AR_STA_ID1, get_unaligned_le16(common->macaddr + 4)
>                   | macStaId1
>                   | AR_STA_ID1_RTS_USE_DEF
>                   | (ah->config.
>                      ack_6mb ? AR_STA_ID1_ACKCTS_6MB : 0)
>                   | ah->sta_id1_defaults);
> 
> 
> Existing code works because we configure the opmode again through
> ath9k_htc_opmode_init() after reset. 

Looks like I changed this, see commit 6819d57f07440a8f9540967d9212a70e9c98eceb
But yes, opmode_init() in both ath9k and ath9k_htc takes care of this.
I'll fix this.

Sujith
