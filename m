Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:32950 "EHLO
	mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574AbcFTKKu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2016 06:10:50 -0400
Received: by mail-pf0-f169.google.com with SMTP id i123so49141422pfg.0
        for <linux-wireless@vger.kernel.org>; Mon, 20 Jun 2016 03:10:33 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v2 0/2] *** staging: wilc1000: Replace semaphores ***
Date: Mon, 20 Jun 2016 15:40:17 +0530
Message-Id: <1466417419-13568-1-git-send-email-binoy.jayan@linaro.org> (sfid-20160620_121133_647799_06D9B8F6)
In-Reply-To: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
References: <1465814259-3009-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the second patch series for 'wilc1000'. The original patch series
consisted 7 patches of which only the first 5 are good. The patch 6 and 7
are being worked on in this series in a different way.

This patch series removes the semaphore 'sem' in 'wilc1000' and also
restructures the implementation of kthread / message_queue logic with
a create_singlethread_workqueue() / queue_work() setup.

These are part of a bigger effort to eliminate all semaphores
from the linux kernel.

They build correctly (individually and as a whole).

NB: The changes are untested

Rework on the review comments by Arnd w.r.t. v1 for patch 2:

struct message_queue can be removed since
 - after the workqueue conversion, mq->sem is no longer needed
 - recv_count is not needed, it just counts the number of entries in the list
 - struct wilc' pointer can be retrieved from the host_if_msg, (vif->wilc)
 - the message list is not needed because we always look only at the
   first entry, except in wilc_mq_destroy(), but it would be better
   to just call destroy_workqueue(), which also drains the remaining work.
 - the exiting flag is also handled by destroy_workqueue()   
 - with everything else gone, the spinlock is also not needed any more.

Do 'kfree' only at the end of 'host_if_work' 

wilc_initialized is always '1' so the conditional 'wilc_mq_send'
in 'hostIFthread' can be removed.

A connect command (HOST_IF_MSG_CONNECT) does not complete while scan is ongoing. 
So, the special handling of this command needs to be preserved.

Use create_singlethread_workqueue() instead of alloc_workqueue(), so that
we stay closer to the current behavior by having the thread run only
on one CPU at a time and not having a 'dedicated' thread for each.

Split the patch to seperate interface changes to 'wilc_mq_send'
    No easy way found to split the patch to change the interface
    'wilc_mq_send' and to 'wilc_enqueue_cmd' as the parameters 
    'mq' 'send_buf' and 'send_buf_size' itself are part of the message
    queue implementation.


Binoy Jayan (2):
  staging: wilc1000: message_queue: Move code to host interface
  staging: wilc1000: Replace kthread with workqueue for host interface

 drivers/staging/wilc1000/Makefile         |   1 -
 drivers/staging/wilc1000/TODO             |   5 +
 drivers/staging/wilc1000/host_interface.c | 417 +++++++++++++++---------------
 drivers/staging/wilc1000/wilc_msgqueue.c  | 144 -----------
 drivers/staging/wilc1000/wilc_msgqueue.h  |  28 --
 5 files changed, 216 insertions(+), 379 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_msgqueue.c
 delete mode 100644 drivers/staging/wilc1000/wilc_msgqueue.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

