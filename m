Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:49237 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096AbZKWCLO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2009 21:11:14 -0500
Received: by gxk26 with SMTP id 26so4445381gxk.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2009 18:11:20 -0800 (PST)
Message-ID: <4B09EF44.3050804@lwfinger.net>
Date: Sun, 22 Nov 2009 20:11:16 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Question about mac80211 callback
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

I tried to figure this out from the code, but I kept getting lost.

When a computer goes into hibernation, which of the mac80211 callback routines
are called, and which ones on the following resume? The problem arises due to
the problem in Bug #14267. The routine to check the hardware status of the
RFKILL switch is being entered with b43_status() returning 0, thus the hardware
switch is not checked. If we do not check for that condition, then we get a
machine fault on PPC. I would like to be able to track this problem down. I've
already entered two bad patches in this area.

Thanks,

Larry
