Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3845 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbYAPVwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jan 2008 16:52:45 -0500
Date: Wed, 16 Jan 2008 16:26:45 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Please pull 'fixes-davem' branch of wireless-2.6
Message-ID: <20080116212645.GD3164@tuxdriver.com> (sfid-20080116_215248_188983_FDFE1759)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dave,

One more fix for rfkill in 2.6.24...note that this branch is based
on 2.6.24-rc8.

Thanks,

John

---

Individual patches available here:

	http://www.kernel.org/pub/linux/kernel/people/linville/wireless-2.6/fixes-davem/

---

The following changes since commit cbd9c883696da72b2b1f03f909dbacc04bbf8b58:
  Linus Torvalds (1):
        Linux 2.6.24-rc8

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git fixes-davem

Eric Paris (1):
      rfkill: call rfkill_led_trigger_unregister() on error

 net/rfkill/rfkill.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 4469a7b..d06d338 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -392,11 +392,14 @@ int rfkill_register(struct rfkill *rfkill)
 	rfkill_led_trigger_register(rfkill);
 
 	error = rfkill_add_switch(rfkill);
-	if (error)
+	if (error) {
+		rfkill_led_trigger_unregister(rfkill);
 		return error;
+	}
 
 	error = device_add(dev);
 	if (error) {
+		rfkill_led_trigger_unregister(rfkill);
 		rfkill_remove_switch(rfkill);
 		return error;
 	}
-- 
John W. Linville
linville@tuxdriver.com
