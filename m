Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:37492 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374AbbF3VwJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 17:52:09 -0400
Received: by wicgi11 with SMTP id gi11so28978736wic.0
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2015 14:52:08 -0700 (PDT)
Date: Tue, 30 Jun 2015 23:52:05 +0200
From: Michel von Czettritz <michel.von.czettritz@gmail.com>
To: gregkh@linux.com
Cc: Jes.Sorensen@redhat.com, Larry.Finger@lwfinger.net,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] staging: rtl8723au: fix/clean up two functions
Message-ID: <cover.1435700714.git.michel.von.czettritz@gmail.com> (sfid-20150630_235214_638672_7E761ED9)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialy fixing a sparse warning, resulted in 3 small patches cleaning
rtl8723a_set_rssi_cmd an rtl8723a_set_raid_cmd up a bit.

Both functions now avoid implicit casts, return actual values, and
rtl8723a_set_rssi_cmd cannot write in unallocated memory any more.

Michel von Czettritz (3):
  staging: rtl8723au: adjust function param, u8* to u32*
  staging: rtl8723au: fix "incorrect type in assignment"
  staging: rtl8723au: function no longer discards return value

 drivers/staging/rtl8723au/hal/odm.c              |  2 +-
 drivers/staging/rtl8723au/hal/rtl8723a_cmd.c     | 18 ++++++++----------
 drivers/staging/rtl8723au/include/rtl8723a_cmd.h |  2 +-
 3 files changed, 10 insertions(+), 12 deletions(-)

-- 
2.4.5

