Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:55554 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021Ab2DRMte (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 08:49:34 -0400
Date: Wed, 18 Apr 2012 14:49:26 +0200 (CEST)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Message-ID: <1767379567.11525.1334753366056.JavaMail.root@idefix> (sfid-20120418_144937_413759_3B918C39)
In-Reply-To: <175652671.10926.1334750163349.JavaMail.root@idefix>
Subject: [BUG] compat-wireless: hard crash unloading mac80211
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Working with the April tarballs of compat-wireless, my system freezes upon unloading of mac80211.

System:
  * Linux 2.6.35-22-generic #35-Ubuntu SMP Sat Oct 16 20:45:36 UTC 2010 x86_64 GNU/Linux
  * gcc (Ubuntu/Linaro 4.4.4-14ubuntu5) 4.4.5

To reproduce in a freshly unpacked source tree:
  ./scripts/driver-select ath9k && make
  sudo modprobe led-class
  sudo insmod compat/compat.ko
  sudo insmod net/wireless/cfg80211.ko
  sudo insmod net/mac80211/mac80211.ko

  sudo sync
  sudo rmmod mac80211.ko


My system immediately crashes, i.e. reboots or freezes. No crash dump or any other info to narrow down the issue.

The last working release for me was 2012-03-18, while I tested the 04-03, 04-09, and 04-15 to crash.


Any ideas?

