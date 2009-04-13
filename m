Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:41104 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbZDMVlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 17:41:23 -0400
Received: by ewy9 with SMTP id 9so2342557ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 14:41:21 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: George Kadianakis <asn@woodpecker.gentoo.org>
Subject: Re: kernel panic with rt61pci
Date: Mon, 13 Apr 2009 23:41:18 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <20090413211131.GA11257@woodpecker.gentoo.org>
In-Reply-To: <20090413211131.GA11257@woodpecker.gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200904132341.18679.IvDoorn@gmail.com> (sfid-20090413_234130_512193_041C99C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> this mail is the result of:
> http://bugs.gentoo.org/show_bug.cgi?id=262862
> 
> The problem is a 2.6.28 regression (which is fixed in 2.6.29) that
> causes a kernel panic when rt61pci tries to connect to a router.
> 
> You can find a screenshot of the panic over here:
> http://bugs.gentoo.org/attachment.cgi?id=185431
> For more info, visit the Gentoo bug entry page.
> 
> Any ideas on the patch that fixes the crash?

Yes, a very simple one actually.

As mentioned in the bugreport, going through all patches
is unfeasable. There are way too many patches and when you
do get the patch there are probably a lot of dependencies on earlier
patches.

However the bug occurs within Hardware crypto functionality,
this means that the best workaround is to disable the HW crypto itself.
Below is the patch which disables HW crypto by default. Note that it still
allows it to be enabled by using the nohwcrypt=0 module parameter.

If indeed the bug is not present in 2.6.29, I think below patch is the one
most worthwhile. :)

Ivo

---
diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index 9e630e7..e1ba2e8 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -38,7 +38,7 @@
 /*
  * Allow hardware encryption to be disabled.
  */
-static int modparam_nohwcrypt = 0;
+static int modparam_nohwcrypt = 1;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
diff --git a/drivers/net/wireless/rt2x00/rt61pci.c b/drivers/net/wireless/rt2x00/rt61pci.c
index 4346cd1..1e1bf5c 100644
--- a/drivers/net/wireless/rt2x00/rt61pci.c
+++ b/drivers/net/wireless/rt2x00/rt61pci.c
@@ -40,7 +40,7 @@
 /*
  * Allow hardware encryption to be disabled.
  */
-static int modparam_nohwcrypt = 0;
+static int modparam_nohwcrypt = 1;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
diff --git a/drivers/net/wireless/rt2x00/rt73usb.c b/drivers/net/wireless/rt2x00/rt73usb.c
index 853b2b2..48a109a 100644
--- a/drivers/net/wireless/rt2x00/rt73usb.c
+++ b/drivers/net/wireless/rt2x00/rt73usb.c
@@ -39,7 +39,7 @@
 /*
  * Allow hardware encryption to be disabled.
  */
-static int modparam_nohwcrypt = 0;
+static int modparam_nohwcrypt = 1;
 module_param_named(nohwcrypt, modparam_nohwcrypt, bool, S_IRUGO);
 MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
 
