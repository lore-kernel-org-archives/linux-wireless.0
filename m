Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:32947 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431AbaKIKcG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Nov 2014 05:32:06 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH V2 0/3] debugfs: adding helper for single seq_file
Date: Sun, 9 Nov 2014 11:31:57 +0100
Message-ID: <1415529120-16314-1-git-send-email-arend@broadcom.com> (sfid-20141109_113218_430436_696FC53B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series replaces the initial series posted:

Message-ID: <1414498752-9746-1-git-send-email-arend@broadcom.com>

This series include changes in driver code to investigate potential
code savings. As example used the ath9k driver as it has a fair
amount of debugfs files. In this series it changes 7 debugfs entries
to use seq_file and the helper function. Below the output of the
size utility:

   text	   data	    bss	    dec	    hex	filename
 115968	   1225	     28	 117221	  1c9e5	original/ath9k.o
 113224	   1225	     28	 114477	  1bf2d	seq_file/ath9k.o
 111024	   1225	     28	 112277	  1b695	helper/ath9k.o

This series is for 3.19 kernel and applies to the driver-core-next
branch of the driver-core repository.

The second patch has a number of CamelCase checks, but those were
already present in code. So fixing that would be a separate effort.

Changelog:
----------
V2:
 - fixed whitespace failures.
 - use seq_puts where applicable.
 - rebased on driver-core-next branch.

Arend van Spriel (3):
  debugfs: add helper function to create device related seq_file
  ath: use seq_file api for ath9k debugfs files
  ath: ath9k: use debugfs_create_devm_seqfile() helper for seq_file
    entries

 drivers/net/wireless/ath/ath9k/ahb.c   |   1 +
 drivers/net/wireless/ath/ath9k/debug.c | 459 +++++++++++----------------------
 drivers/net/wireless/ath/ath9k/debug.h |  11 +-
 drivers/net/wireless/ath/ath9k/pci.c   |   1 +
 fs/debugfs/file.c                      |  54 ++++
 include/linux/debugfs.h                |  16 +-
 6 files changed, 226 insertions(+), 316 deletions(-)

-- 
1.9.1

