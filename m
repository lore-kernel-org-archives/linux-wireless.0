Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:43148 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1LSRE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 12:04:57 -0500
Received: from smtp4-g21.free.fr (smtp4-g21.free.fr [212.27.42.4])
	by smtpfb2-g21.free.fr (Postfix) with ESMTP id 05403CB2CF7
	for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 18:04:52 +0100 (CET)
Received: from [192.168.108.17] (unknown [213.36.7.13])
	by smtp4-g21.free.fr (Postfix) with ESMTP id 4C0CF4C84BC
	for <linux-wireless@vger.kernel.org>; Mon, 19 Dec 2011 18:04:09 +0100 (CET)
Subject: Race in ieee80211_register_hw()
From: Maxime Bizon <mbizon@freebox.fr>
Reply-To: mbizon@freebox.fr
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Mon, 19 Dec 2011 18:04:08 +0100
Message-ID: <1324314248.6069.112.camel@sakura.staff.proxad.net> (sfid-20111219_180500_295801_20E8D326)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi all,

I'm using udev/sysfs to detect when a new phy becomes available, and
then immediately open it.

When I insmod the wifi card module driver, it works most of the times,
but sometimes I get this:

ieee80211 phy0: Failed to initialize rate control algorithm


I noticed that ieee80211_register_hw() first registers the PHY, which
makes it available to userspace, then does subsequent config calls on
it. ieee80211_init_rate_ctrl_alg then fails since local->open_count is
not zero.

This is easy to reproduce by adding an msleep() after wiphy_register()

What lock should I use to surround the whole registration process ?

-- 
Maxime


