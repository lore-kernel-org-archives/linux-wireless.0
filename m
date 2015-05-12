Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:35098 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933918AbbELVv4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2015 17:51:56 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: ming.lei@canonical.com, rusty@rustcorp.com.au
Cc: torvalds@linux-foundation.org, dhowells@redhat.com,
	seth.forshee@canonical.com, linux-kernel@vger.kernel.org,
	pebolle@tiscali.nl, linux-wireless@vger.kernel.org,
	gregkh@linuxfoundation.org, jlee@suse.com, tiwai@suse.de,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [PATCH v3 0/4] firmware: few fixes for name uses
Date: Tue, 12 May 2015 14:49:39 -0700
Message-Id: <1431467383-28540-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20150512_235234_716206_6E4471EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Luis R. Rodriguez" <mcgrof@suse.com>

This v3 changes patch 1 to just return -ENOMEM and remove the
unlikely() optimization. It also drops the early truncation
checks.

Luis R. Rodriguez (4):
  firmware: fix __getname() missing failure check
  firmware: check for file truncation on direct firmware loading
  firmware: fix possible use after free on name on asynchronous request
  firmware: use const for remaining firmware names

 drivers/base/firmware_class.c | 61 +++++++++++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 16 deletions(-)

-- 
2.3.2.209.gd67f9d5.dirty

