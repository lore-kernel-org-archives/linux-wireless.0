Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:18484 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab0CEVfg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Mar 2010 16:35:36 -0500
Subject: Re: KEY_RFKILL not found on kernel 2.6.30
From: Pavel Roskin <proski@gnu.org>
To: Keith Bannister <k.bannister@ieee.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <e44ae5e1003032058g2cf1b5a1lcf62e8919dddea58@mail.gmail.com>
References: <e44ae5e1003032058g2cf1b5a1lcf62e8919dddea58@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 16:35:26 -0500
Message-Id: <1267824926.3068.12.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-03-04 at 15:58 +1100, Keith Bannister wrote:

> /home/keith/wireless/compat-wireless-2010-03-03/net/rfkill/input.c:219:
> error: ‘KEY_RFKILL’ undeclared (first use in this function)

The same happens on Linux 2.6.26.  I've just sent a patch for that.
Sorry, I should have credited you as the original reporter.

> Any Ideas?

Please apply this patch to compat-wireless:

diff --git a/include/linux/compat-2.6.33.h b/include/linux/compat-2.6.33.h
index 9559f21..70e5f98 100644
--- a/include/linux/compat-2.6.33.h
+++ b/include/linux/compat-2.6.33.h
@@ -49,6 +49,8 @@ static inline void compat_release_firmware(const struct firmware *fw)
 }
 #endif
 
+#define KEY_RFKILL		247	/* Key that controls all radios */
+
 #define IFF_DONT_BRIDGE 0x800		/* disallow bridging this ether dev */
 /* source: include/linux/if.h */
 

-- 
Regards,
Pavel Roskin
