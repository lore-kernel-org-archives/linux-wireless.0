Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f42.google.com ([209.85.220.42]:35456 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854AbcFVKDq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 06:03:46 -0400
Received: by mail-pa0-f42.google.com with SMTP id hl6so15619959pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2016 03:02:52 -0700 (PDT)
From: Binoy Jayan <binoy.jayan@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Austin Shin <austin.shin@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Tony Cho <tony.cho@atmel.com>, Glen Lee <glen.lee@atmel.com>,
	Leo Kim <leo.kim@atmel.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org, Binoy Jayan <binoy.jayan@linaro.org>
Subject: [PATCH v3 0/3] *** staging: wilc1000: Replace semaphores ***
Date: Wed, 22 Jun 2016 15:31:28 +0530
Message-Id: <1466589691-14798-1-git-send-email-binoy.jayan@linaro.org> (sfid-20160622_120407_650516_4D80F46E)
In-Reply-To: <1466417419-13568-1-git-send-email-binoy.jayan@linaro.org>
References: <1466417419-13568-1-git-send-email-binoy.jayan@linaro.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patchset [v3] is part of the second patch series for 'wilc1000'.
The original patch series consisted 7 patches of which only the first 5
are good. The patch 6 and 7 are being worked on in this series
in a different way.

This patch series removes the semaphore 'sem' in 'wilc1000' and also
restructures the implementation of kthread / message_queue logic with
a create_singlethread_workqueue() / queue_work() setup.

These are part of a bigger effort to eliminate all semaphores
from the linux kernel.

They build correctly (individually and as a whole).

NB: The changes are untested

Discussion carried forward from previous patchset [v2]

Rework on the review comments by Arnd w.r.t. v1

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

New changes in v3

Rework on the review comments by Arnd w.r.t. v2
 - Removed forward declaration for wilc_enqueue_cmd
 - Change the interface 'wilc_mq_send' in a different patch
 - Avoid change in indentation in host_if_work and move it to
   a different patch

Cannot remove forward declaraition for 'host_if_work'
   since there is a mutual dependency.

	Binoy

Binoy Jayan (3):
  staging: wilc1000: message_queue: Move code to host interface
  staging: wilc1000: Replace kthread with workqueue for host interface
  staging: wilc1000: Change interface wilc_mq_send to wilc_enqueue_cmd

 drivers/staging/wilc1000/Makefile         |   1 -
 drivers/staging/wilc1000/TODO             |   5 +
 drivers/staging/wilc1000/host_interface.c | 395 +++++++++++++++---------------
 drivers/staging/wilc1000/wilc_msgqueue.c  | 144 -----------
 drivers/staging/wilc1000/wilc_msgqueue.h  |  28 ---
 5 files changed, 204 insertions(+), 369 deletions(-)
 delete mode 100644 drivers/staging/wilc1000/wilc_msgqueue.c
 delete mode 100644 drivers/staging/wilc1000/wilc_msgqueue.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

