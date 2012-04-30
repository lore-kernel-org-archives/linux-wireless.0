Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63888 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756156Ab2D3Qid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 12:38:33 -0400
Received: by wibhj6 with SMTP id hj6so3007101wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 30 Apr 2012 09:38:32 -0700 (PDT)
From: Anisse Astier <anisse@astier.eu>
To: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Cc: Ivo van Doorn <IvDoorn@gmail.com>, linville@tuxdriver.com,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Anisse Astier <anisse@astier.eu>
Subject: [PATCH v5 0/3] rt2800 debug improvements
Date: Mon, 30 Apr 2012 18:33:30 +0200
Message-Id: <1335803613-1253-1-git-send-email-anisse@astier.eu> (sfid-20120430_183837_659104_7FF20E0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In there are all the debug facilites I would have liked to have while I was
trying to understand why chipset revision RT5390R wasn't working (see:
http://article.gmane.org/gmane.linux.kernel.wireless.general/89561 ).

Changes since v4:
 - re-add BBP size patch (first one) in the series
 - add Ivo's Acked-bys
Changes since v3:
 - Don't print a debug message when register type isn't registered
Changes since v2:
 - split the second patch in two to incorporate changes suggested by Ivo
van Doorn (thanks for the review!) :
 - first part (second patch) is now only a small rewrite of the code to
   initialize only the supported register. Any unsupported register wouldn't
   have its files created.
 - second patch best viewed ignoring spaces ((git) diff -w)
 - third patch is effectively adding RFCSR support.
 - we allocate more data for sprintf since we add a new register.
Changes since v1:
 - removed initialization in chipsets other than rt2800, we now rely on
  default initialization.
 - added comments to make this explicit
 - fix rfcsr size (64)
 - fix pre-review bug thanks to Ivo Van Doorn

Anisse Astier (3):
  rt2800: debugfs register access: BBP is 256 bytes big
  rt2x00: debugfs support - allow a register to be empty
  rt2x00: Add debugfs access for rfcsr register

 drivers/net/wireless/rt2x00/rt2800.h      |    4 +-
 drivers/net/wireless/rt2x00/rt2800lib.c   |    7 +++
 drivers/net/wireless/rt2x00/rt2x00debug.c |   82 ++++++++++++++++-------------
 drivers/net/wireless/rt2x00/rt2x00debug.h |    1 +
 4 files changed, 57 insertions(+), 37 deletions(-)

-- 
1.7.9.4

