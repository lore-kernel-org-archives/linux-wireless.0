Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:59312 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2F0HrY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 03:47:24 -0400
Received: by yenl2 with SMTP id l2so663809yen.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 00:47:23 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 27 Jun 2012 14:47:23 +0700
Message-ID: <CA+i8gKLOirMGrNRPiCGb4yfSAG2Jeh33SFRpUJ=5VX9-P3C+4Q@mail.gmail.com> (sfid-20120627_094759_223471_0857E44D)
Subject: wireless-testing: commit fad29cd leads to kernel build failure
From: Emmanuel Benisty <benisty.e@gmail.com>
To: linux-wireless@vger.kernel.org, c_manoha@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The following commit breaks wireless-testing kernel build:

commit fad29cd2f59949581050a937786c2c9bc78b2f04
Author: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Date:   Mon Jun 25 13:54:22 2012 +0530

    ath9k: Fix lockdep splat

    Cancel the MCI work only when MCI is actually enabled.

It fails with:

  CC [M]  drivers/net/wireless/ath/ath9k/main.o
drivers/net/wireless/ath/ath9k/main.c: In function '__ath_cancel_work':
drivers/net/wireless/ath/ath9k/main.c:155:23: error: 'struct
ath_softc' has no member named 'mci_work'
make[5]: *** [drivers/net/wireless/ath/ath9k/main.o] Error 1

Thanks+regards.
