Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32822 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809Ab1FDSTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 14:19:45 -0400
Received: by iwn34 with SMTP id 34so2163081iwn.19
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jun 2011 11:19:44 -0700 (PDT)
Message-ID: <4DEA773D.5070500@lwfinger.net> (sfid-20110604_201955_719935_13899D30)
Date: Sat, 04 Jun 2011 13:19:41 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: In case 3.0-rc1 from wireless-testing fails to boot
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When I tried using 3.0-rc1 from mainline, my computer failed to boot because it 
got into an infinite loop initiated from user space. Bisection led to a 
particular commit, and reverting it "fixed" the problem. In fact, the actual 
problem was a faulty merge. This problem is fixed in the current linux-2.6-git, 
but that patch is not yet in wireless-testing.

In case you run into this problem, the fix is commit 0f48f2600911d (reproduced 
below):


commit 0f48f2600911d5de6393829e4a9986d4075558b3
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jun 2 05:29:19 2011 +0900

     block: fix mismerge of the DISK_EVENT_MEDIA_CHANGE removal

     Jens' back-merge commit 698567f3fa79 ("Merge commit 'v2.6.39' into
     for-2.6.40/core") was incorrectly done, and re-introduced the
     DISK_EVENT_MEDIA_CHANGE lines that had been removed earlier in commits

      - 9fd097b14918 ("block: unexport DISK_EVENT_MEDIA_CHANGE for
        legacy/fringe drivers")

      - 7eec77a1816a ("ide: unexport DISK_EVENT_MEDIA_CHANGE for ide-gd
        and ide-cd")

     because of conflicts with the "g->flags" updates near-by by commit
     d4dc210f69bc ("block: don't block events on excl write for non-optical
     devices")

     As a result, we re-introduced the hanging behavior due to infinite disk
     media change reports.

     Tssk, tssk, people! Don't do back-merges at all, and *definitely* don't
     do them to hide merge conflicts from me - especially as I'm likely
     better at merging them than you are, since I do so many merges.

     Reported-by: Steven Rostedt <rostedt@goodmis.org>
     Cc: Jens Axboe <jaxboe@fusionio.com>
     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index a0aabd9..46b8136 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -321,7 +321,6 @@ static void pcd_init_units(void)
  		strcpy(disk->disk_name, cd->name);	/* umm... */
  		disk->fops = &pcd_bdops;
  		disk->flags = GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
-		disk->events = DISK_EVENT_MEDIA_CHANGE;
  	}
  }

diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index ae15a4d..7878da8 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -627,7 +627,6 @@ static int viocd_probe(struct vio_dev *vdev, const struct 
vio_device_id *id)
  	gendisk->fops = &viocd_fops;
  	gendisk->flags = GENHD_FL_CD | GENHD_FL_REMOVABLE |
  			 GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
-	gendisk->events = DISK_EVENT_MEDIA_CHANGE;
  	set_capacity(gendisk, 0);
  	gendisk->private_data = d;
  	d->viocd_disk = gendisk;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 6e5123b..144d272 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1782,7 +1782,6 @@ static int ide_cd_probe(ide_drive_t *drive)
  	ide_cd_read_toc(drive, &sense);
  	g->fops = &idecd_ops;
  	g->flags |= GENHD_FL_REMOVABLE | GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
-	g->events = DISK_EVENT_MEDIA_CHANGE;
  	add_disk(g);
  	return 0;


