Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3938 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932817AbXCQMNz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Mar 2007 08:13:55 -0400
Date: Fri, 16 Mar 2007 17:31:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: jeff@garzik.org
Cc: linux-wireless@vger.kernel.org
Subject: Please pull 'upstream-fixes' branch of wireless-2.6
Message-ID: <20070316213153.GD3426@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following changes since commit db98e0b434a6265c451ffe94ec0a29b8d0aaf587:
  Linus Torvalds (1):
        Linux 2.6.21-rc4

are found in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git upstream-fixes

Larry Finger (1):
      bcm43xx: MANUALWLAN fixes

Michal Schmidt (1):
      airo: Fix an error path memory leak

 drivers/net/wireless/airo.c                  |    4 +++-
 drivers/net/wireless/bcm43xx/bcm43xx_radio.c |   14 +++++++-------
 2 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index a8c2bfe..2ada76a 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -2852,7 +2852,7 @@ static struct net_device *_init_airo_card( unsigned short irq, int port,
 	if (rc) {
 		airo_print_err(dev->name, "register interrupt %d failed, rc %d",
 				irq, rc);
-		goto err_out_unlink;
+		goto err_out_nets;
 	}
 	if (!is_pcmcia) {
 		if (!request_region( dev->base_addr, 64, dev->name )) {
@@ -2935,6 +2935,8 @@ err_out_res:
 	        release_region( dev->base_addr, 64 );
 err_out_irq:
 	free_irq(dev->irq, dev);
+err_out_nets:
+	airo_networks_free(ai);
 err_out_unlink:
 	del_airo_dev(dev);
 err_out_thr:
diff --git a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
index 32beb91..ee1e7a2 100644
--- a/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
+++ b/drivers/net/wireless/bcm43xx/bcm43xx_radio.c
@@ -882,10 +882,10 @@ static void _stack_save(u32 *_stackptr, size_t *stackidx,
 {
 	u32 *stackptr = &(_stackptr[*stackidx]);
 
-	assert((offset & 0xF000) == 0x0000);
-	assert((id & 0xF0) == 0x00);
+	assert((offset & 0xE000) == 0x0000);
+	assert((id & 0xF8) == 0x00);
 	*stackptr = offset;
-	*stackptr |= ((u32)id) << 12;
+	*stackptr |= ((u32)id) << 13;
 	*stackptr |= ((u32)value) << 16;
 	(*stackidx)++;
 	assert(*stackidx < BCM43xx_INTERFSTACK_SIZE);
@@ -896,12 +896,12 @@ static u16 _stack_restore(u32 *stackptr,
 {
 	size_t i;
 
-	assert((offset & 0xF000) == 0x0000);
-	assert((id & 0xF0) == 0x00);
+	assert((offset & 0xE000) == 0x0000);
+	assert((id & 0xF8) == 0x00);
 	for (i = 0; i < BCM43xx_INTERFSTACK_SIZE; i++, stackptr++) {
-		if ((*stackptr & 0x00000FFF) != offset)
+		if ((*stackptr & 0x00001FFF) != offset)
 			continue;
-		if (((*stackptr & 0x0000F000) >> 12) != id)
+		if (((*stackptr & 0x00007000) >> 13) != id)
 			continue;
 		return ((*stackptr & 0xFFFF0000) >> 16);
 	}
-- 
John W. Linville
linville@tuxdriver.com
