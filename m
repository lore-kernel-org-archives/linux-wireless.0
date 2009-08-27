Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:57106 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbZH0M6L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 08:58:11 -0400
Received: by ewy2 with SMTP id 2so1155686ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 05:58:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090827023000.21926.90867.stgit@mj.roinet.com>
References: <20090827023000.21926.90867.stgit@mj.roinet.com>
Date: Thu, 27 Aug 2009 15:58:11 +0300
Message-ID: <40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix uninitialized value use in
	ath5k_eeprom_read_turbo_modes()
From: Nick Kossifidis <mickflemm@gmail.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/27 Pavel Roskin <proski@gnu.org>:
> The `val' variable in ath5k_eeprom_read_turbo_modes() is used
> uninitialized.  gcc 4.4.1 with -fno-inline-functions-called-once reports
> it:
>
> eeprom.c: In function 'ath5k_eeprom_read_turbo_modes':
> eeprom.c:441: warning: 'val' may be used uninitialized in this function
>
> Comparing the code to the Atheros HAL, it's clear that the split between
> ath5k_eeprom_read_modes() and ath5k_eeprom_read_turbo_modes() was
> incorrect.
>
> The Atheros HAL reads both turbo and non-turbo data from EEPROM in one
> function.  Some turbo mode parameters are derived from the same EEPROM
> values as non-turbo parameters, just from different bits.
>
> Merge ath5k_eeprom_read_turbo_modes() into ath5k_eeprom_read_modes() to
> fix the warning.  The actual values and offsets have been cross-checked
> against Atheros HAL.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Current code works fine (i 've checked it against various cards),
there is nothing wrong
with having another function for reading turbo modes, i find it's
cleaner that way.

Just change

u16 val;

to

u16 val = 0;

and it should be fine.


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
