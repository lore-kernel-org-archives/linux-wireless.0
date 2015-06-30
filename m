Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout1.freenet.de ([195.4.92.91]:59137 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbbF3Rxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2015 13:53:35 -0400
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout1.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.85 #1)
	id 1Z9zZU-0003vz-8w
	for linux-wireless@vger.kernel.org; Tue, 30 Jun 2015 19:43:48 +0200
Received: from localhost ([::1]:41191 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.85 #1)
	id 1Z9zZT-0001cM-V1
	for linux-wireless@vger.kernel.org; Tue, 30 Jun 2015 19:43:48 +0200
Received: from mx11.freenet.de ([195.4.92.21]:49843)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.85 #1)
	id 1Z9zWS-0005GE-Ch
	for linux-wireless@vger.kernel.org; Tue, 30 Jun 2015 19:40:40 +0200
Received: from pd9eaeadb.dip0.t-ipconnect.de ([217.234.234.219]:50915 helo=mail.maya.org)
	by mx11.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256) (port 587) (Exim 4.85 #1)
	id 1Z9zWS-000374-4v
	for linux-wireless@vger.kernel.org; Tue, 30 Jun 2015 19:40:40 +0200
Received: from [192.168.1.6] (dualc.maya.org [192.168.1.6])
	by mail.maya.org (8.14.7/8.13.8) with ESMTP id t5UHcmiE008050
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2015 19:38:48 +0200
Message-ID: <5592D495.10603@maya.org> (sfid-20150630_195351_076978_47AD8F21)
Date: Tue, 30 Jun 2015 19:40:37 +0200
From: Andreas Hartmann <andihartmann@freenet.de>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Modifications to RT5572_LinuxSTA_2.6.1.3_20121022 to get it working
 with actual kernels. Fix for Linux 4.1.
References: <54B627E3.6040707@maya.org> <54B629C7.6020601@maya.org>	<54BE37F6.2090604@maya.org> <54CA3CC2.1080109@maya.org>
In-Reply-To: <54CA3CC2.1080109@maya.org>
Content-Type: multipart/mixed;
 boundary="------------000209060803080304030104"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000209060803080304030104
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

Hi,

this patch fixes RT5572_LinuxSTA_2.6.1.3_20121022 to get it working with
Linux 4.1.

W/o this patch, the driver can't read
/etc/Wireless/RT2870STA/RT2870STA.dat anymore and therefore the driver
defaults to 802.11g e.g.


Reason:
After commit 5d5d56897530 ("make new_sync_{read,write}() static")
->read() cannot be called directly any more.

Here you can find all old existing patches for other
kernel versions: [1]


Regards,
Andreas


[1]
http://news.gmane.org/find-root.php?group=gmane.linux.drivers.rt2x00.user&article=2670


--------------000209060803080304030104
Content-Type: text/x-patch;
 name="rt_linux_4,1.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rt_linux_4,1.c.diff"

--- a/DPO_RT5572_LinuxSTA_2.6.1.3_20121022/os/linux/rt_linux.c  2015-01-29 14:40:35.891324646 +0100
+++ b/DPO_RT5572_LinuxSTA_2.6.1.3_20121022/os/linux/rt_linux.c  2015-06-28 08:10:18.556116310 +0200
@@ -1126,22 +1126,33 @@
 
 int RtmpOSFileRead(RTMP_OS_FD osfd,
 		     char *pDataPtr, int readLen) {
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,19,0)
 	/* The object must have a read method */
 	if (osfd->f_op && osfd->f_op->read) {
 		return osfd->f_op->read(osfd, pDataPtr, readLen, &osfd->f_pos);
 	} else {
 		DBGPRINT(RT_DEBUG_ERROR, ("no file read method\n"));
+#else
+	if (osfd && osfd->f_mode & FMODE_CAN_READ) {
+		return __vfs_read(osfd, pDataPtr, readLen, &osfd->f_pos);
+	} else {
+		DBGPRINT(RT_DEBUG_ERROR, ("no file read method\n"));
+#endif
 		return -1;
 	}
 }
 
 int RtmpOSFileWrite(RTMP_OS_FD osfd,
 		    char *pDataPtr, int writeLen) {
+#if LINUX_VERSION_CODE < KERNEL_VERSION(3,19,0)
 	return osfd->f_op->write(osfd,
 				 pDataPtr,
 				 (
 	size_t) writeLen,
 				 &osfd->f_pos);
+#else
+	return __vfs_write(osfd, pDataPtr, (size_t) writeLen, &osfd->f_pos);
+#endif
 }
 
 static inline void __RtmpOSFSInfoChange(OS_FS_INFO * pOSFSInfo,

--------------000209060803080304030104--
