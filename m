Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:38803 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754509AbcCJIoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 03:44:17 -0500
Received: by mail-wm0-f43.google.com with SMTP id l68so18497861wml.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2016 00:44:16 -0800 (PST)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH v2 0/7] mwifiex: cleanups 
Date: Thu, 10 Mar 2016 09:44:04 +0100
Message-Id: <1457599451-13910-1-git-send-email-afenkart@gmail.com> (sfid-20160310_094420_902686_CEA15224)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

v2:
- addressed issues from review
- race-condition issue discussed in patch description

Andreas Fenkart (7):
  mwifiex: scan: simplify dereference of bss_desc fields
  mwifiex: scan: factor out has_ieee_hdr/has_vendor_hdr
  mwifiex: scan: simplify ternary operators using gnu extension
  mwifiex: scan: factor out dbg_security_flags
  mwifiex: scan: replace pointer arithmetic with array access
  mwifiex: factor out mwifiex_cancel_pending_scan_cmd
  mwifiex: make mwifiex_insert_cmd_to_free_q local static

 drivers/net/wireless/marvell/mwifiex/cmdevt.c      | 125 +++++++-------
 drivers/net/wireless/marvell/mwifiex/main.h        |   3 +-
 drivers/net/wireless/marvell/mwifiex/scan.c        | 185 ++++++++-------------
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c |  13 +-
 4 files changed, 128 insertions(+), 198 deletions(-)

-- 
2.7.0

