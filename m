Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([204.127.217.104]:35211 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbZENXVI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 19:21:08 -0400
Message-ID: <4A0CA749.6080906@lwfinger.net>
Date: Thu, 14 May 2009 18:20:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>,
	Stefano Brivio <stefano.brivio@polimi.it>,
	Michael Buesch <mb@bu3sch.de>,
	Broadcom Linux <bcm43xx-dev@lists.berlios.de>
Subject: [PATCH 0/2] b43legacy - remove unnecessary MMIO references in the
 hot path and fix locking problem.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The first of these two patches is by Stefano Brivio and removes extra MMIO
references in the interrupt routine. I am submitting it on Stefano's behalf
because I was able to test it, and his patch touches the routine that patch 2 fixes.

The second patch fixes a locking problem introduced by commit
abb1d2bca0fc429c136747a64e675dd4d8906f36 "mac80211: unify config_interface and
bss_info_changed". After that patch was applied, b43legacy would lock the system
upon booting.


