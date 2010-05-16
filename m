Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:43956 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804Ab0EPUmT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 May 2010 16:42:19 -0400
Received: by gyg13 with SMTP id 13so1815100gyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 16 May 2010 13:42:18 -0700 (PDT)
MIME-Version: 1.0
From: Weedy <weedy2887@gmail.com>
Date: Sun, 16 May 2010 16:41:58 -0400
Message-ID: <AANLkTimltZSc8dJPPBCibcGDaOPcQRU_5kSbenIAdi_6@mail.gmail.com>
Subject: ath5k past 2.6.30 breaks monitor mode (and thus the aircrack suite)
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Running airodump on ubuntus 2.6.30 kernel works as expected. The
2.6.32 kernel shipped in lucid never sees data packets.

I have narrowed it down to channel hopping. modprobing the driver and
starting mon0 on a fixed channel works as expected, but allowing
airodump to channel hop breaks the interface until the driver is
reset.

I wrote a script to download and build compat wireless starting from
2009-01-01 (granted everything fails until half way through october),
but every version that is successfully installed also show the same
bug.

Further instructions welcome.
