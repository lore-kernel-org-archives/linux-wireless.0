Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:38755 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbZGEAlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 20:41:53 -0400
Received: by gxk26 with SMTP id 26so4967766gxk.13
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jul 2009 17:41:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A4FA224.40006@openwrt.org>
References: <1246726795-3934-1-git-send-email-me@bobcopeland.com>
	 <1246726795-3934-6-git-send-email-me@bobcopeland.com>
	 <4A4FA224.40006@openwrt.org>
Date: Sat, 4 Jul 2009 20:41:56 -0400
Message-ID: <b6c5339f0907041741w2fe6c6aaifda6f005e7313c66@mail.gmail.com>
Subject: Re: [PATCH 5/5] ath5k: write PCU registers on initial reset
From: Bob Copeland <me@bobcopeland.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>>       }
>> -     ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
>> +     ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan == NULL);
>
> Shouldn't this be chan != NULL? I'd assume that chan is NULL the first
> time and change_channel thus should be false to initialize all the
> registers.

Yup, it should... I could swear I tested it, must've gotten lucky.

Thanks for the catch.

-- 
Bob Copeland %% www.bobcopeland.com
