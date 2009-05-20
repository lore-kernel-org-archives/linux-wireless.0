Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:37054 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593AbZETIEJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2009 04:04:09 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 May 2009 01:04:11 -0700
Date: Wed, 20 May 2009 13:33:04 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@Atheros.com>
Subject: Re: ath9k oops - in ath_get_rate+0x468 - Fatal exception in
	interrupt
Message-ID: <20090520080303.GA16219@vasanth-laptop>
References: <43e72e890905191522j37fb71das9289ef580b9e6ff5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <43e72e890905191522j37fb71das9289ef580b9e6ff5@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 20, 2009 at 03:52:29AM +0530, Luis R. Rodriguez wrote:
 
> (gdb) l *(ath_get_rate+0x468)
> 0x202f8 is in ath_get_rate (drivers/net/wireless/ath/ath9k/rc.c:744).
> 739             }
> 740
> 741             if (rate > (ath_rc_priv->rate_table_size - 1))
> 742                     rate = ath_rc_priv->rate_table_size - 1;
> 743
> 744             ASSERT((rate_table->info[rate].valid &&
> 745                     (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)) ||
> 746                    (rate_table->info[rate].valid_single_stream &&
> 747                     !(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)));
> 

Most probably we are using wrong rate table at this moment. This is
possible only when we failt during channel set after completing the
scan. Can you please confirm if you are seeing failures during channel
set after changing this assert into warning?.

Vasanth
