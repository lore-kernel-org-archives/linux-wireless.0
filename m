Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53918 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105Ab0ENSUb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 14:20:31 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: Update Readme to reflect changes
Date: Fri, 14 May 2010 20:20:16 +0200
Message-Id: <1273861216-12195-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1273861216-12195-1-git-send-email-hauke@hauke-m.de>
References: <1273861216-12195-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* A description of the differences of the stable and the normal version
  of compat wireless was added.
* Some outdated parts are now up to date
* replaceing the developing section with version in the wiki

These changes are needed because some people are tiring to build their
own compat-wireless version based on wireless-testing and some people
choose compat-wireless stable based on their currently running kernel
version.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 README |  181 ++++++++++++++++++++++++++++++++++++++++++++++++++++------------
 1 files changed, 147 insertions(+), 34 deletions(-)

diff --git a/README b/README
index 88b16b4..62986e8 100644
--- a/README
+++ b/README
@@ -8,11 +8,6 @@ It is technically possible to support kernels < 2.6.25 but more
 work is required for that.
 It also provides Linux bluetooth subsystem enhancements for kernels 2.6.27 and above.
 
-If you'd like to keep the wireless-testing git repository local as well,
-please read out git-guide which explains how to achieve this:
-
-http://wireless.kernel.org/en/developers/git-guide
-
 With a local git repository you can update the compatibility package yourself. 
 For more information on how to do this please refer the Developers section below.
 
@@ -30,13 +25,30 @@ Subscribe to the wiki page to get updates on the documentation.
 Where to get the latest
 -----------------------
 
-This package lets you build your own 'latest', all you need is a local git repository
-checkout of wireless-testing.git. However since not many users are expected to keep
-a local git repository of wireless-testing we provide daily snapshots of this
-package + the wireless subsystem code. You can find the latest snapshot at:
+This package lets you build your own 'latest', all you need is a local git
+repository. This way is documented in the Developers section of this document.
+However since not many users are expected to keep a local git repository we 
+provide daily snapshots of this package + the wireless and bluetooth subsystem
+code. You can find the latest snapshot at:
 
+linux-next.git version:
 http://wireless.kernel.org/en/users/Download
 
+stable version:
+http://wireless.kernel.org/en/users/Download/stable/
+
+Versions
+--------
+
+There are two different versions of this package available. 
+ * Version based on latest linux-next.git tree named compat-wireless-YYYY-MM-DD.tar.bz2
+ * Version based on linux-2.6-stable.git tree named compat-wireless-2.6.CC.DD.tar.bz2
+
+Both versions should work for every kernel > 2.6.25. The differences are the
+code they are containing. The version based on linux-next.git contains the
+wireless and bluetooth subsystem out of linux-next.git and the stable version
+the wireless subsystem out of the corresponding linux stable version.
+
 Selecting your driver
 ---------------------
 
@@ -72,7 +84,7 @@ Load:
 Reboot unless you know what you are doing.
 
 
-Bluetooth modules can be seperately compiled and installed using below commands
+Bluetooth modules can be separately compiled and installed using below commands
 
 Build:
 	make bt
@@ -130,7 +142,7 @@ Non-wireless drivers
 --------------------
 
 To support b43 ssb is also provided, and since ssb is also provided
-we provide b44 (the ethernet driverl).
+we provide b44 (the ethernet driver).
 
 The new rfkill drivers also provided and backported.
 
@@ -156,7 +168,7 @@ Why?
 
 For users or developers stuck on older kernels that want to help test or 
 patch wireless work. Additionally if you're on a recent kernel this lets
-you get the latest and greatest wireless-testing git work without much effort.
+you get the latest and greatest linux-next git work without much effort.
 This may mean new drivers for some users. Last but not least we hope this
 will encourage vendors and developers to post patches upstream first
 rather than forking or maintaining their own mac80211 releases with
@@ -197,7 +209,7 @@ Here you see the list of changes to all wireless drivers, the wireless core and
 
 http://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=log;
 
-This views all the changes on the 'everything' branch of wireless-testing.git.
+This views all the changes on wireless-testing.git.
 
 License
 -------
@@ -211,38 +223,139 @@ Developers
 ----------
 
 Compatibility work goes into compat/compat.[ch]. If using those files do 
-not suffice additional actual code changes can go into compat/compat.diff.
+not suffice additional actual code changes can go into patches/*.patch.
 
-If you have your own wireless-testing git tree, before running admin-update.sh
-be sure to set your GIT_TREE variable. For example:
+An extended and more up to date version can be found at:
 
-export GIT_TREE=/home/mcgrof/wireless-testing/
+http://wireless.kernel.org/en/users/Download/hacking
 
-scripts/admin-clean.sh		- Cleans the compat-wireless-2.6 tree
-scripts/admin-update.sh		- Updates compat-wireless-2.6 with your git tree
-scripts/admin-refresh.sh	- Does the above two
+This section deals with development details of compat-wireless and the other
+trees it uses. If you want to make your own compat-wireless tarballs, or if you
+see something busted with compat-wireless or just want to add something new or
+an enhancement this is the guide for you.
 
-TODO
-----
+Git trees you will need
+-----------------------
 
-* Compatibilty work for 2.6.18 --> 2.6.21
+compat-wireless backports both the bluetooth and 802.11 subsystems down to older
+kernels. To be able to synchronize backporting the latest and greatest the
+linux-next.git tree is used as its main source for kernel updates. General Linux
+kernel compatibility is addressed through a general kernel compatibility tree,
+compat.git. compat-wireless then has its own tree for specific wireless
+compatibility. You will then need to checkout three trees to start hacking on
+compat-wireless:
 
-Patches for compatibility work
-------------------------------
+git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
+git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat.git
+git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6.git
 
-Please send patches against:
+Linux next
+----------
 
-git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/compat-wireless-2.6.git
+The linux-next.git tree brings all subsystems being worked on for the next
+kernel release into one tree. So if the current rc kernel is 2.6.33-rc5, this
+means linux-next will have what people today are working on for the 2.6.34
+kernel release.
+
+compat.git
+----------
+
+The compat git tree is a general kernel compatibility layer which can be shared
+amongst different compatibility projects, or drivers. compat-wireless is just
+one of the kernel compatibility projects using compat.git. compat.git builds a
+general compatibility module, compat, and any additional modules to let you get
+new general kernel updates from future kernels on your old kernels.
 
-To: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
-CC: linux-wireless@vger.kernel.org
-Subject: [PATCH] compat-2.6: backport foo
+compat.git modules
+------------------
 
-Patches for drivers
+compat.git provides a few modules and headers to help with general kernel
+compatibility.
+
+compat
+------
+
+Provides all exported symbols implemented in each respective kernel
+compat-2.6.xy.c files. Upon module load it just initializes the Linux kernel's
+''power management Quality Of Service'' (aka '''pm-qos''') Interface interface
+added as of the 2.6.24 kernel. No other things are initialized, the rest of the
+compat module just acts as a library of exported symbols.
+
+compat_firmware_class
+---------------------
+
+Another module which compat.git provides is a backport of the firmware_class
+module which got updated recently newer with a new request_firmware_nowait()
+to allow better asynchronous firmware uploading. This was added as of the 2.6.33
+kernel. The firmware_class module has been backported into a new module called
+compat_firmware_class. A separate module has been defined instead of a direct
+replacement for firmware_class since your system may have old drivers which use
+the old request_firmware_nowait() and would bust if they used the new
+request_firmware_nowait(). The compat_firmware_class module registers its own
+sysfs subsystem and as such also gets udev events sent through a separate
+subsystem. Because of this a new udev rules file is required and provided.
+
+compat-wireless.git
 -------------------
 
-If you'd like to send patches for a driver though you can send it using our 
-Submitting Patches guideline:
+Anything that is not general kernel compatibility but instead specific to 802.11
+or bluetooth goes into compat-wireless.git. After you've cloned all three trees,
+linux-next.git, compat.git and compat-wireless.git you need to change into the
+compat-wireless directory and tell compat-wireless where you linux-next and
+compat.git trees are. You do this with environment variables GIT_TREE and
+GIT_COMPAT_TREE. You can do for example:
+
+export GIT_TREE=/home/user/wireless-testing/
+export GIT_COMPAT_TREE=/home/users/compat.git/
+
+Then you can update your local sources based on these linux-next.git and
+compat.git trees:
+
+scripts/admin-clean.sh   - Cleans the compat-wireless-2.6 tree
+scripts/admin-update.sh  - Updates compat-wireless-2.6 with your git tree
+scripts/admin-refresh.sh - Does the above two
+
+Adding new drivers
+------------------
+
+Most new drivers are enabled for compilation. If see a driver you would like
+enabled try it into the mix, test them and if they work enable them and send
+the respective patches.
+
+Sending patches
+---------------
+
+Remember there are three trees. linux-next itself is a conglomeration of kernel
+git trees itself, so patches for linux-next.git should be sent to each
+respective subsystem for which the patches are targeted for. So for example for
+802.11 you will want to send them to John Linville and cc linux-wireless, for
+further guidelines on this see the Submitting Patches guidelines for 802.11.
+http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches
+As another example, for bluetooth you will want to send them to Marcel
+Holtmann and cc the linux-bluetooth mailing list. If your patch touches on
+others areas of the kernel refer to the MAINTAINERS file on the kernel.
+
+For compat.git and compat-wireless.git please send patches against to:
 
-http://wireless.kernel.org/en/developers/SubmittingPatches
+To: Luis R. Rodriguez <mcgrof@kernel.org>
+CC: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
+Subject: [PATCH] compat-2.6: fix foo
+
+For patches for compat.git please use a subject like the following:
+
+Subject: [PATCH] compat: fix foo
+
+For compat-wireless.git please use a subject like the following:
+
+Subject: [PATCH] compat-wireless: fix foo
+
+Patches are preferred sent with a clear commit log entry, if unfamiliar with
+how to send patches please refer to
+http://wireless.kernel.org/en/developers/Documentation/git-guide.
+
+
+TODO
+-----
+ * Dialog (make menuconfig) option for this package
+ * Compatibility work for 2.6.18 --> 2.6.25
 
-- 
1.7.0.4

