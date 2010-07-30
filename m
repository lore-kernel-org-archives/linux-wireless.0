Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926Ab0G3EFq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jul 2010 00:05:46 -0400
Subject: [wt PATCH 0/5] libertas: make association work again
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Jul 2010 23:07:14 -0700
Message-ID: <1280470034.14523.4.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series makes libertas actually associate with APs after the
cfg80211 conversion.  There was a pretty big TODO where if cfg80211
didn't pass in the BSSID of the AP to associate with, then libertas
would fail because the firmware really, really, really wants a BSSID.
So lets do a scan to find that BSSID.  The other notable change is
a fix to make sure all supported rates are included in the firmware's
association request, lack of which caused some APs to deny the attempt.


Dan Williams (5):
  libertas: get the right # of scanned BSSes
  libertas: better scan response debugging
  libertas: better association request debugging
  libertas: fix association with some APs by using extended rates
  libertas: scan before assocation if no BSSID was given

 drivers/net/wireless/libertas/cfg.c  |  275 ++++++++++++++++++++++++++--------
 drivers/net/wireless/libertas/dev.h  |    5 +
 drivers/net/wireless/libertas/main.c |    1 +
 3 files changed, 219 insertions(+), 62 deletions(-)


