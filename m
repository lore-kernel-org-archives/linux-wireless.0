Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:38480 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422959AbXCBG1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2007 01:27:01 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HN1Ck-0002wR-A0
	for linux-wireless@vger.kernel.org; Fri, 02 Mar 2007 01:25:22 -0500
Subject: Assertion failed in ieee80211softmac_wx_get_rate
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Cc: bcm43xx-dev@lists.berlios.de
Content-Type: text/plain
Date: Fri, 02 Mar 2007 01:26:59 -0500
Message-Id: <1172816819.26330.12.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

If I load bcm43xx and run iwconfig without bringing the interface up,
I'm getting this in the kernel log:

SoftMAC: ASSERTION FAILED (0)
at: /home/proski/src/linux-2.6/net/ieee80211/softmac/ieee80211softmac_wx.c:306:ieee80211softmac_wx_get_rate()

It's an x86 system with the 2.6.20 kernel (actually, it's the master
branch from the mb repository, which is wireless-dev before the 2.6.21
switchover plus broadcom fixes).

The assert assures that the interface has a valid tx rate.  But since
the interface has never been up, the rate has not been assigned.

Either softmac should tolerate rate 0, at least when the interface is
down, or it should initialize the rate much earlier, perhaps in
alloc_ieee80211softmac().

I can test another tree, e.g. wireless-2.6, if there are chances that
the problem has been fixed.

-- 
Regards,
Pavel Roskin

