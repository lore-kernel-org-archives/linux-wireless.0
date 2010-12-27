Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:43395 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543Ab0L0WVz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Dec 2010 17:21:55 -0500
Received: by qwa26 with SMTP id 26so8851136qwa.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Dec 2010 14:21:54 -0800 (PST)
Message-ID: <4D19118D.6040202@lwfinger.net>
Date: Mon, 27 Dec 2010 16:22:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Nick Leverton <nick@leverton.org>
CC: linux-wireless@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: printk %pV compatibility in b43 and ath for compat-wireless
References: <loom.20101227T190514-850@post.gmane.org>
In-Reply-To: <loom.20101227T190514-850@post.gmane.org>
Content-Type: multipart/mixed;
 boundary="------------030409020407020705020906"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030409020407020705020906
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/27/2010 12:05 PM, Nick Leverton wrote:
> Hi,
> 
> I'm using compat-wireless with Debian 2.6.32 (kernel for forthcoming Debian 6.0 
> release).  It mostly works well but one thing that has crept in recently is the 
> use of new printk features such as %pV which old kernels don't support.  I 
> noticed this whilst trying the new b43 n-phy code (for which much thanks to 
> everyone involved), as I get kernel messages printed of the following form:
> 
> Dec 23 21:10:46 nickl kernel: [688182.007780] Broadcom 43xx driver loaded [ 
> Features: PMNLS, Firmware-ID: FW13 ]
> Dec 23 21:10:50 nickl kernel: [688186.100195] b43-phy0: f535bb54
> Dec 23 21:10:50 nickl kernel: [688186.198711] ADDRCONF(NETDEV_UP): wlan0: link 
> is not ready
> Dec 23 21:11:09 nickl kernel: [688205.048054] b43-phy0: f4a3bb54
> Dec 23 21:11:09 nickl kernel: [688205.145589] ADDRCONF(NETDEV_UP): wlan0: link 
> is not ready
> Dec 23 21:11:20 nickl kernel: [688216.484744] ADDRCONF(NETDEV_CHANGE): wlan0: 
> link becomes ready
> Dec 23 21:11:31 nickl kernel: [688225.667842] b43-phy0 ERROR: f56a5f34
> Dec 23 21:12:14 nickl kernel: [688235.585265] b43-phy0 ERROR: f56a5f34
> Dec 23 21:12:50 nickl kernel: [688270.140937] b43-phy0 ERROR: f56a5f34
> Dec 23 21:13:11 nickl kernel: [688306.427195] b43-phy0 ERROR: f56a5f34
> Dec 23 21:14:05 nickl kernel: [688327.492370] b43-phy0 ERROR: f56a5f34
> Dec 23 21:16:23 nickl kernel: [688381.712250] b43-phy0 ERROR: f56a5f34
> Dec 23 21:22:59 nickl kernel: [688518.942314] b43-phy0 ERROR: f56a5f34
> Dec 23 21:23:00 nickl kernel: [688529.935161] b43-phy0 ERROR: f56a5f34
> 
> As of 20101223, the following code uses %pV, some of which can be seen above:
> 
> ./drivers/net/wireless/b43/main.c:      printk(KERN_INFO "b43-%s: %pV",
> ./drivers/net/wireless/b43/main.c:      printk(KERN_ERR "b43-%s ERROR: %pV",
> ./drivers/net/wireless/b43/main.c:      printk(KERN_WARNING "b43-%s 
> warning: %pV",
> ./drivers/net/wireless/b43/main.c:      printk(KERN_DEBUG "b43-%s debug: %pV",
> ./drivers/net/wireless/ath/main.c:      rtn = printk("%sath: %pV", level, 
> &vaf);
> ./drivers/net/wireless/b43legacy/main.c:        
> printk(KERN_INFO "b43legacy-%s: %pV",
> ./drivers/net/wireless/b43legacy/main.c:        printk(KERN_ERR "b43legacy-%s 
> ERROR: %pV",
> ./drivers/net/wireless/b43legacy/main.c:        
> printk(KERN_WARNING "b43legacy-%s warning: %pV",
> ./drivers/net/wireless/b43legacy/main.c:        printk(KERN_DEBUG "b43legacy-%s 
> debug: %pV",
> 
> It would be useful to know the error message behind the vararg !
> 
> I tried applying the patches which introduced %pV to kernel.org, but 2.6.32 is 
> too old.  Could this be fixed either in the compat b43 driver or in a compat 
> back-feature, please ?

These changes were in commit #5b736d42.

I cannot fix them in compat-wireless, but I think I know the origin of those
errors. At present, b43 is not setting up the transmit header correctly for N
PHYs. Whenever, the rate-setting mechanism tries an OFDM rate, one of these
errors will occur. We are working on modifications to the driver to fix this.
Until we get that done, issue an 'iwconfig wlan0 rate 11M' to lock the interface
at 11 Mb/s.

The attached patch can be reverse-applied to fix the driver.

Larry

--------------030409020407020705020906
Content-Type: text/x-patch;
 name="reverse_pV.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="reverse_pV.patch"

commit 5b736d42bc51fe893fd7d4ceac34c727d23135e1
Author: Joe Perches <joe@perches.com>
Date:   Tue Nov 9 16:35:18 2010 -0800

    drivers/net/wireless/b43/main.c: Use printf extension %pV
    
    Using %pV reduces the number of printk calls and
    eliminates any possible message interleaving from
    other printk calls.
    
    Signed-off-by: Joe Perches <joe@perches.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index a118652..fa48803 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -322,59 +322,83 @@ static int b43_ratelimit(struct b43_wl *wl)
 
 void b43info(struct b43_wl *wl, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	if (b43_modparam_verbose < B43_VERBOSITY_INFO)
 		return;
 	if (!b43_ratelimit(wl))
 		return;
+
 	va_start(args, fmt);
-	printk(KERN_INFO "b43-%s: ",
-	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan");
-	vprintk(fmt, args);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_INFO "b43-%s: %pV",
+	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan", &vaf);
+
 	va_end(args);
 }
 
 void b43err(struct b43_wl *wl, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	if (b43_modparam_verbose < B43_VERBOSITY_ERROR)
 		return;
 	if (!b43_ratelimit(wl))
 		return;
+
 	va_start(args, fmt);
-	printk(KERN_ERR "b43-%s ERROR: ",
-	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan");
-	vprintk(fmt, args);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_ERR "b43-%s ERROR: %pV",
+	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan", &vaf);
+
 	va_end(args);
 }
 
 void b43warn(struct b43_wl *wl, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	if (b43_modparam_verbose < B43_VERBOSITY_WARN)
 		return;
 	if (!b43_ratelimit(wl))
 		return;
+
 	va_start(args, fmt);
-	printk(KERN_WARNING "b43-%s warning: ",
-	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan");
-	vprintk(fmt, args);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_WARNING "b43-%s warning: %pV",
+	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan", &vaf);
+
 	va_end(args);
 }
 
 void b43dbg(struct b43_wl *wl, const char *fmt, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	if (b43_modparam_verbose < B43_VERBOSITY_DEBUG)
 		return;
+
 	va_start(args, fmt);
-	printk(KERN_DEBUG "b43-%s debug: ",
-	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan");
-	vprintk(fmt, args);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk(KERN_DEBUG "b43-%s debug: %pV",
+	       (wl && wl->hw) ? wiphy_name(wl->hw->wiphy) : "wlan", &vaf);
+
 	va_end(args);
 }
 

--------------030409020407020705020906--
