Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([80.75.119.105]:33084 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab2HIN0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 09:26:14 -0400
Date: Thu, 9 Aug 2012 15:26:04 +0200 (CEST)
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: Andy Gospodarek <andy@greyhouse.net>
Cc: Phil Perry <phil@elrepo.org>, mcgrof@frijolero.org,
	lf driver backport
	<lf_driver_backport@lists.linux-foundation.org>,
	linux-wireless@vger.kernel.org
Message-ID: <2121451356.93690.1344518764022.JavaMail.root@neratec.com> (sfid-20120809_152618_209742_B24207D9)
In-Reply-To: <1344487215-24143-1-git-send-email-andy@greyhouse.net>
Subject: Re: [PATCH v2] compat: support RHEL6.3 as a build target
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/09/2012 06:40 AM, Andy Gospodarek wrote:
> This patch allows me to compile and load the latest compat modules on
> RHEL6.3.  Users of compat on RHEL6 should note that you should set
> CONFIG_COMPAT_KFIFO=n as those bits are not needed at all.
> 
> [...]
> 
> diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
> index 56d5961..09e4b6f 100644
> --- a/include/linux/compat-2.6.36.h
> +++ b/include/linux/compat-2.6.36.h
> @@ -98,6 +98,8 @@ struct pm_qos_request_list {
>   * Dummy printk for disabled debugging statements to use whilst maintaining
>   * gcc's format and side-effect checking.
>   */
> +/* mask no_printk as RHEL6 backports this */
> +#define no_printk(...) compat_no_printk(...)
>  static inline __attribute__ ((format (printf, 1, 2)))
>  int no_printk(const char *s, ...) { return 0; }
>  
> [...]

This at least breaks compilation on 2.6.35-22 with gcc throwing a
compat-2.6.36.h:104: error: ISO C requires a named argument before ‘...’

It looks like no_printk() needs to be renamed to compat_no_printk()
to make it work as intended.

This is a systematic mistake at several sections of this patch, where
the original function needs to be prefixed by 'compat_' to match the 
related macro.


---
diff --git a/include/linux/compat-2.6.36.h b/include/linux/compat-2.6.36.h
index 8b02260..b6757c3 100644
--- a/include/linux/compat-2.6.36.h
+++ b/include/linux/compat-2.6.36.h
@@ -101,7 +101,7 @@ struct pm_qos_request_list {
 /* mask no_printk as RHEL6 backports this */
 #define no_printk(...) compat_no_printk(...)
 static inline __attribute__ ((format (printf, 1, 2)))
-int no_printk(const char *s, ...) { return 0; }
+int compat_no_printk(const char *s, ...) { return 0; }
 
 #ifndef alloc_workqueue
 #define alloc_workqueue(name, flags, max_active) __create_workqueue(name, flags, max_active, 0)
