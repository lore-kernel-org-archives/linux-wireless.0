Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mr1.bfh.ch ([147.87.250.50]:36452 "EHLO mr1.bfh.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754973AbYEPNse (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 May 2008 09:48:34 -0400
From: Michael Bernhard <michael.bernhard@bfh.ch>
To: mcgrof@winlab.rutgers.edu
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] compat-2.6: Make it working with wireless-testing 2005-05-15
Date: Fri, 16 May 2008 15:48:42 +0200
Message-Id: <1210945725582-git-send-email-michael.bernhard@bfh.ch> (sfid-20080516_154839_315459_B5115365)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I'working under Ubuntu 7.10 with kernel version 2.6.22. I tried to get the
compat-wireless package running and had some problems this patch series
addresses. However, I don't know if this arises problems for kernel higher
than 2.6.22.

PATCH 1/3: Corrects the three failed hunks in compat/compat.diff.
PATCH 2/3: Adds some missing functions and macros.
PATCH 3/3: Enables iwlwifi build

There remaines one problem. In kernel version 2.6.22 the BIT() macro is
defined in include/linux/input.h. For iwlwifi which uses this header in
iwl-rfkill.h this gives a redefinition of BIT() which is defined in
include/linux/bitops.h now.
