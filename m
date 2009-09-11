Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:50259 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724AbZIKBmB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 21:42:01 -0400
Received: by vws33 with SMTP id 33so467951vws.33
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2009 18:42:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1252632895-11914-4-git-send-email-lrodriguez@atheros.com>
References: <1252632895-11914-1-git-send-email-lrodriguez@atheros.com>
	 <1252632895-11914-4-git-send-email-lrodriguez@atheros.com>
Date: Thu, 10 Sep 2009 21:42:03 -0400
Message-ID: <b6c5339f0909101842t74479b34heaf0628d1a3b7edb@mail.gmail.com>
Subject: Re: [PATCH 3/4] ath5k: define ath_common ops
From: Bob Copeland <bcopeland@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org, devel@linuxdriverproject.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 10, 2009 at 9:34 PM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
>  static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
>  {
> -       return ioread32(ah->ah_iobase + reg);
> +       return ath5k_hw_common(ah)->ops->read(ah, reg);
>  }

Is there any way we can do this without two pointer dereferences for every
read and write?  I have a feeling this is going to make certain operations
(e.g. loading initvals during reset) really suck.

-- 
Bob Copeland %% www.bobcopeland.com
