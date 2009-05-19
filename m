Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f123.google.com ([209.85.216.123]:36991 "EHLO
	mail-px0-f123.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbZESWsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 18:48:25 -0400
Received: by pxi29 with SMTP id 29so62861pxi.33
        for <linux-wireless@vger.kernel.org>; Tue, 19 May 2009 15:48:26 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 19 May 2009 15:22:29 -0700
Message-ID: <43e72e890905191522j37fb71das9289ef580b9e6ff5@mail.gmail.com>
Subject: ath9k oops - in ath_get_rate+0x468 - Fatal exception in interrupt
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I was able to get this oops from my home laptop this morning using
master-2009-05-18 with ath9k on 5 GHz with WPA2 with an 11n AP, HT40
set. I was able to reproduce twice by using wpa_supplicant on the
interface, and then manually generating a scan. The oops would happen
immediately. I figured I'd take it up at the office but I haven't been
able to reproduce. So here are the pictures for those interested. This
indicates there was an oops while in_interrupt().

I was unable to pull anything out of the laptop through netconsole.
The only way I was able to capture the oops was through
CONFIG_FB_VESA=y and a high vesa fb resolution. Its as good as it
gets. According to gdb with my local ath9k.ko (it should be a bit
different than my home machine's) ath_get_rate+0x468 translates to:

(gdb) l *(ath_get_rate+0x468)
0x202f8 is in ath_get_rate (drivers/net/wireless/ath/ath9k/rc.c:744).
739             }
740
741             if (rate > (ath_rc_priv->rate_table_size - 1))
742                     rate = ath_rc_priv->rate_table_size - 1;
743
744             ASSERT((rate_table->info[rate].valid &&
745                     (ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)) ||
746                    (rate_table->info[rate].valid_single_stream &&
747                     !(ath_rc_priv->ht_cap & WLAN_RC_DS_FLAG)));

This seems familiar, I believe I had run into it last but last time I
looked I didn't see where this could have been caused. I'm inclined to
lift this assert, leave a WARN and use the lowest rate for now.

IIRC last I checked my hunch on this was that we don't protect the
private RC data nor do we provide an API for this to drivers. Not sure
what is best here. Johannes -- is this related to the RX race you were
mentioning?

http://bombadil.infradead.org/~mcgrof/oops-img/2009-05-19/01.jpg
http://bombadil.infradead.org/~mcgrof/oops-img/2009-05-19/02.jpg
http://bombadil.infradead.org/~mcgrof/oops-img/2009-05-19/03.jpg
http://bombadil.infradead.org/~mcgrof/oops-img/2009-05-19/04.jpg

  Luis
