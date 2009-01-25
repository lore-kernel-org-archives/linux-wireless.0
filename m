Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:50509 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbZAYQlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 11:41:11 -0500
Received: by rv-out-0506.google.com with SMTP id g9so306665rvb.5
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2009 08:41:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090124081223.50440@gmx.net>
References: <20090124081223.50440@gmx.net>
Date: Sun, 25 Jan 2009 11:41:10 -0500
Message-ID: <b6c5339f0901250841r22635bd7q40532891293a6744@mail.gmail.com> (sfid-20090125_174135_417236_1268693A)
Subject: Re: [PATCH] ath5k: Set TSF fix
From: Bob Copeland <bcopeland@gmail.com>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 24, 2009 at 3:12 AM, Alina Friedrichsen <x-alina@gmx.net> wrote:
>  {
>        ATH5K_TRACE(ah->ah_sc);
>
> -       ath5k_hw_reg_write(ah, 0x00000000, AR5K_TSF_L32);
> -       ath5k_hw_reg_write(ah, (tsf64 >> 32) & 0xffffffff, AR5K_TSF_U32);
>        ath5k_hw_reg_write(ah, tsf64 & 0xffffffff, AR5K_TSF_L32);
> +       ath5k_hw_reg_write(ah, (tsf64 >> 32) & 0xffffffff, AR5K_TSF_U32);
>  }

Perhaps there is an internal latch on this pair; that may explain why
you need to write low->high order.

However, you don't need to write (tsf64 >> 32) & 0xffffffff; it's
unsigned so the mask is unnecessary.

-- 
Bob Copeland %% www.bobcopeland.com
