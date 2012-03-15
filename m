Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:45285 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759854Ab2COJNc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Mar 2012 05:13:32 -0400
Received: by dadp12 with SMTP id p12so4554459dad.11
        for <linux-wireless@vger.kernel.org>; Thu, 15 Mar 2012 02:13:32 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 15 Mar 2012 14:43:32 +0530
Message-ID: <CAJwzM1=GYDoE5C4idMOHnY71HAM1O+Joc-Tw+ciWZwdGi8P3kg@mail.gmail.com> (sfid-20120315_101336_005861_9004C60F)
Subject: Compilation errors in module mac80211 with latest tree
From: Avinash Patil <avinashapatil@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

I am seeing compilation errors in module mac80211.

Here is output:
make modules SUBDIRS=net/mac80211
  CC [M]  net/mac80211/main.o
  CC [M]  net/mac80211/status.o
  CC [M]  net/mac80211/sta_info.o
  CC [M]  net/mac80211/wep.o
  CC [M]  net/mac80211/wpa.o
  CC [M]  net/mac80211/scan.o
  CC [M]  net/mac80211/offchannel.o
  CC [M]  net/mac80211/ht.o
  CC [M]  net/mac80211/agg-tx.o
  CC [M]  net/mac80211/agg-rx.o
  CC [M]  net/mac80211/ibss.o
  CC [M]  net/mac80211/work.o
  CC [M]  net/mac80211/iface.o
  CC [M]  net/mac80211/rate.o
  CC [M]  net/mac80211/michael.o
  CC [M]  net/mac80211/tkip.o
  CC [M]  net/mac80211/aes_ccm.o
  CC [M]  net/mac80211/aes_cmac.o
  CC [M]  net/mac80211/cfg.o
net/mac80211/cfg.c: In function ‘sta_apply_parameters’:
net/mac80211/cfg.c:769: error: implicit declaration of function
‘sta_info_move_state_checked’
make[1]: *** [net/mac80211/cfg.o] Error 1


When I searched markmail.org, it looks like Eliad Peller had removed
all instances of sta_info_move_state_checked and replaced with
sta_info_move_state. Has it reappeared because of some other
check-in/or some issue with my git setup?

Regards,
Avinash
