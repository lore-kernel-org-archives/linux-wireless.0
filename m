Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:38788 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727530AbeHJNrB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Aug 2018 09:47:01 -0400
Date: Fri, 10 Aug 2018 13:14:26 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Randy Oostdyk <linux-kernel@oostdyk.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless dongle causing entire machine to hang
Message-ID: <20180810111425.GA16269@redhat.com> (sfid-20180810_131736_616525_49464051)
References: <CAAemcoMYY7utGrrR+8JLPPzQ-YTKsrD=6DZigJ+o9A+72s7CxQ@mail.gmail.com>
 <20180809111049.GC1955@redhat.com>
 <CAAemcoOkA4y7zDMCKzD+nKJAQFoWCGPVHdbEV0j9ZOeaCe144g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lrZ03NoBR/3+SXJZ"
In-Reply-To: <CAAemcoOkA4y7zDMCKzD+nKJAQFoWCGPVHdbEV0j9ZOeaCe144g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Aug 09, 2018 at 12:49:58PM -0600, Randy Oostdyk wrote:
> On Thu, Aug 9, 2018 at 5:10 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > I'm reluctant to replace _warn by _dbg messages as if somethings
> > will go wrong we will not notice that. We can use printk_ratelimited()
> > variant instead to do not spam log in speed that it will hung
> > the machine. But the correct fix should be in USB host drivers,
> > which seems to be not in perfect shape on those embedded platforms.
> 
> Agreed about the "correct" fix likely being on the USB side, but at
> least using printk_ratelimited() will avoid the log spamming, and
> avoid locking the machine, as you said.
> 
> Will someone else take that approach and come up with a patch, or is
> this something I should try to take on myself? I could certainly test
> such a patch, if desired.
> 
> Meanwhile, I'll look into reporting the USB bug, if it hasn't already been.

I'm attaching the ratelimit patch for test. 

However after reading email from Larry I withdraw blaming USB host 
driver. The issue could be faulty HW and USB host driver can not do
much much about this. 

Another question is if machine hung due to log spam or because there
was some crash. Those error conditions trigger code paths that are
not usually used, so there could be some oops that hung the system.

Anyway you can test the patch and report back.

Cheers
Stanislaw

--lrZ03NoBR/3+SXJZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="rt2x00_ratelimited_err.patch"

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 4b1744e..94459d5 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -65,14 +65,19 @@
 /* Utility printing macros
  * rt2x00_probe_err is for messages when rt2x00_dev is uninitialized
  */
+#define wiphy_err_ratelimited(wiphy, format, args...)		\
+	dev_err_ratelimited(&(wiphy)->dev, format, ##args)
+#define wiphy_warn_ratelimited(wiphy, format, args...)		\
+	dev_warn_ratelimited(&(wiphy)->dev, format, ##args)
+
 #define rt2x00_probe_err(fmt, ...)					\
 	printk(KERN_ERR KBUILD_MODNAME ": %s: Error - " fmt,		\
 	       __func__, ##__VA_ARGS__)
 #define rt2x00_err(dev, fmt, ...)					\
-	wiphy_err((dev)->hw->wiphy, "%s: Error - " fmt,			\
+	wiphy_err_ratelimited((dev)->hw->wiphy, "%s: Error - " fmt,	\
 		  __func__, ##__VA_ARGS__)
 #define rt2x00_warn(dev, fmt, ...)					\
-	wiphy_warn((dev)->hw->wiphy, "%s: Warning - " fmt,		\
+	wiphy_warn_ratelimited((dev)->hw->wiphy, "%s: Warning - " fmt,	\
 		   __func__, ##__VA_ARGS__)
 #define rt2x00_info(dev, fmt, ...)					\
 	wiphy_info((dev)->hw->wiphy, "%s: Info - " fmt,			\

--lrZ03NoBR/3+SXJZ--
