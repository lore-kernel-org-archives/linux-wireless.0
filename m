Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from svenfoo.org ([82.94.215.22]:48375 "EHLO mail.zonque.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab1GLHwN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 03:52:13 -0400
From: Sven Neumann <s.neumann@raumfeld.com>
To: libertas-dev@lists.infradead.org
Cc: daniel@zonque.org, linux-wireless@vger.kernel.org
Subject: patch to fix potential problem with wiphy_update_regulatory
Date: Tue, 12 Jul 2011 09:43:58 +0200
Message-Id: <1310456639-16468-1-git-send-email-s.neumann@raumfeld.com> (sfid-20110712_095216_360328_0C05B5AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


While investigating the crashes I found that wiphy_update_regulatory
is from one place being called without the lock held that protects
the static variable it uses. I am sending you a patch that corrects
this issue. Unfortunately this change does not fix the crashes that
I reported. I am sending you the patch for review nevertheless.


Regards,
Sven

