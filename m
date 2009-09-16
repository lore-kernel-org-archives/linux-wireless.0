Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx73.mail.ru ([94.100.176.87]:58724 "EHLO mx73.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964AbZIOXEJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2009 19:04:09 -0400
Received: from mx40.mail.ru (mx40.mail.ru [94.100.176.54])
	by mx73.mail.ru (mPOP.Fallback_MX) with ESMTP id 1328D688A1F
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2009 03:04:08 +0400 (MSD)
Received: from [94.242.37.174] (port=7907 helo=zhubr.mshome.net)
	by mx40.mail.ru with asmtp
	id 1Mnh3g-000Gbz-00
	for linux-wireless@vger.kernel.org; Wed, 16 Sep 2009 03:03:36 +0400
Date: Wed, 16 Sep 2009 03:09:52 +0300
From: Nikolai ZHUBR <zhubr@mail.ru>
Message-ID: <174470396.20090916030952@mail.ru>
To: linux-wireless@vger.kernel.org
Subject: cfg80211 and rfkill_backport question.
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello people,

I'm trying to use compat-wireless-2009-09-14 for kernel 2.6.25.20.
It all compiles fine but inserting cfg80211 fails complaining about
symbols exported from rfkill_backport not being found, and inserting 
rfkill_backport first also fails complaining about symbols exported
from cfg80211, kind of circular dependancy:

cfg80211.ko:
0001b570 T dev_set_name
.....
.....
         U backport_rfkill_blocked

rfkill_backport.ko:
         U dev_set_name
.........
......
000010a8 T backport_rfkill_blocked

How is this supposed to work? 

I'm compiling for openwrt 8.09.1, mips platform, if it matters, and the
box for building openwrt is opensuse 10.3.

Thank you!

Nikolai ZHUBR

(Please CC me, I'm not subscribed)


