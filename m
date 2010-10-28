Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web56803.mail.re3.yahoo.com ([66.196.97.77]:35821 "HELO
	web56803.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752525Ab0J1JOT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Oct 2010 05:14:19 -0400
Message-ID: <728838.98715.qm@web56803.mail.re3.yahoo.com>
Date: Thu, 28 Oct 2010 02:14:18 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: [PATCH 2/2] compat-wireless: fix update-initramfs script
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are traces of a widespread error logs from installing
compat-wireless pertaining to update-initramfs, as google would
suggest. Ubuntu 10.10, for example complains of excessive:
"FATAL: Could not load /lib/modules/2.6.31-wl/modules.dep: No such file or directory"
Other distributions/kernels: "Cannot find /lib/modules/2.6.31-wl"

* Fix kernel version detection
* Fix updating of initramfs. Instead of generating new initramfs image,
simply update the existing one. This makes update-grub redundant, which
is good thing, considering it messes with people's grub.cfg settings
every time compat-wireless is installed. At some point replacing this
script in Makefile with "@update-initramfs -u" will probably be best.
 

Signed-off-by: Walter Goldens <goldenstranger@yahoo.com>
---

--- a/scripts/update-initramfs
+++ b/scripts/update-initramfs
@@ -10,16 +10,18 @@
 
 LSB_RED_ID=$(/usr/bin/lsb_release -i -s)
 
-KLIB=/lib/modules/2.6.31-wl/build
+KLIB=/lib/modules/$(uname -r)/build
 ver=$(echo $KLIB | awk -F "/lib/modules/" '{print $2}' | awk -F"/" '{print $1}')
 dir=/boot/
 
 case $LSB_RED_ID in
 "Ubuntu")
 	echo "Updating Ubuntu's initramfs for $ver under $dir ..."
-	mkinitramfs -o $dir/initrd.img-$ver $ver
-	echo "Will now run update-grub to ensure grub will find the new initramfs ..."
-	update-grub
+#	mkinitramfs -o $dir/initrd.img-$ver $ver
+	update-initramfs -u
+	echo "update complete"
+#	echo "Will now run update-grub to ensure grub will find the new initramfs ..."
+#	update-grub
 	;;
 *)
 	echo "Warning:"



      
