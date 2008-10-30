Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:43770 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753004AbYJ3AtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 20:49:20 -0400
Message-ID: <49090486.3050103@lwfinger.net> (sfid-20081030_014924_937484_6016085E)
Date: Wed, 29 Oct 2008 17:49:10 -0700
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: htl10@users.sourceforge.net
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
Subject: [RFC/RFT PATCH 0/6] rtl8187: Reduce delays to reduce startup time
References: <838057.50079.qm@web23102.mail.ird.yahoo.com> <49088F7D.8020102@lwfinger.net>
In-Reply-To: <49088F7D.8020102@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current version of the rtl8187 driver contains a large number of msleep()
commands that cause initialization to take a long time. This series of patches
include revisions that were found by looking at the latest version of the
vendor's driver (rtl8187B_linux_26.1036.0708.2008), and others that were found
to be OK with testing.

To keep each of the patches relatively small, these changes are split into 6
parts. The changes in them are as follows:

1. Remove all delays of greater than 1 sec.
2. Remove the msleep(1) that immediately follow calls to rtl8225_write_phy_ofdm().
3. Remove the msleep(1) that immediately follow calls to rtl8225_write_phy_cck().
4. Remove the msleep(1) that immediately follow calls to rtl8225_write().
5. Remove the nsleep() calls from rtl8187_write_phy(), rtl8225_write_bitbang(),
and rtl8225_write_8051().
6. Remove the msleep(10) that preceeds a channel change.

Before these changes, routine rtl8187b_init_hw() took 15.82 sec to execute. It
now takes 3.76 sec.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

