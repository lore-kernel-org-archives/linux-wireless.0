Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:59530 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbYBVVhK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2008 16:37:10 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1108550mue.5
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2008 13:37:08 -0800 (PST)
Message-ID: <43e72e890802221337h799ee09yef95c21c0033c49f@mail.gmail.com> (sfid-20080222_213717_483725_8D542163)
Date: Fri, 22 Feb 2008 16:37:05 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Bill Moss" <bmoss@clemson.edu>
Subject: Re: compile issues compat-wireless-2.6
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47BE12FF.7030808@clemson.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <47BE12FF.7030808@clemson.edu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 21, 2008 at 7:10 PM, Bill Moss <bmoss@clemson.edu> wrote:
> http://linuxwireless.org/download/compat-wireless-2.6/compat-wireless-2.6.tar.bz2
>
>  Compile issues for Fedora 8 kernel-2.6.24.2-7.fc8.x86_64.
>
>  For a successful compile, I had to
>
>  Add to ieee80211_sta.c
>  #define CONFIG_MAC80211_IBSS_DEBUG 1
>
>  Add to compat-wireless-2.6/drivers/net/wireless/ipw2200.h
>  static inline void le32_add_cpu(__le32 *var, u32 val)
>  {
>         *var = cpu_to_le32(le32_to_cpu(*var) + val);
>  }
>
>  The first looks like a compatibility fix.
>
>  A recent kernel patch has moved byteorder definitions such as this one
>
>  from  /usr/src/kernels/2.6.24.2-7.fc8-x86_64/fs/ocfs2/endian.h (missing
>  in Fedora kernels)
>
>  to  /usr/include/linux/byteorder/generic.h (in Fedora kernels)
>
>  But this patch has not made it to Fedora 8 and 9 kernels.

Thanks for reporting this. The changes you mentioned come from the patch:

      commit 8b5f6883683c91ad7e1af32b7ceeb604d68e2865
      Author: Marcin Slusarz <marcin.slusarz@gmail.com>
      Date:   Fri Feb 8 04:20:12 2008 -0800

Since it changes core headers around and ports ext3 and XFS
filesystems to it this won't go into 2.6.24 instead its been picked up
by the 2.6.25 series. I've ported over the changes as follows and
pushed a new compat-wireless tarball. Please test and let me know how
it goes.

commit d0a3153c24dd7181b6cd22c47342279443472d0a
Author: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
Date:   Fri Feb 22 16:30:11 2008 -0500

    Port over new le32_add_cpu & friends changes from OCFS2 to core move.

    The patch:
      commit 8b5f6883683c91ad7e1af32b7ceeb604d68e2865
      Author: Marcin Slusarz <marcin.slusarz@gmail.com>
      Date:   Fri Feb 8 04:20:12 2008 -0800

          byteorder: move le32_add_cpu & friends from OCFS2 to core

      moves le*_add_cpu and be*_add_cpu functions from OCFS2 to core
      header and converted some existing code to it. We port
      it here as later kernels will most likely use it.
      Thanks to Bill Moss <bmoss@clemson.edu> for reporting this.

    Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>

diff --git a/compat/compat.h b/compat/compat.h
index 2644c95..73af8ba 100644
--- a/compat/compat.h
+++ b/compat/compat.h
@@ -218,6 +218,47 @@ static inline void set_freezable(void) {}
 /* Compat work for 2.6.24 */
 #if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,25))

+/* The patch:
+ * commit 8b5f6883683c91ad7e1af32b7ceeb604d68e2865
+ * Author: Marcin Slusarz <marcin.slusarz@gmail.com>
+ * Date:   Fri Feb 8 04:20:12 2008 -0800
+ *
+ *     byteorder: move le32_add_cpu & friends from OCFS2 to core
+ *
+ * moves le*_add_cpu and be*_add_cpu functions from OCFS2 to core
+ * header (1st) and converted some existing code to it. We port
+ * it here as later kernels will most likely use it.
+ */
+static inline void le16_add_cpu(__le16 *var, u16 val)
+{
+       *var = cpu_to_le16(le16_to_cpu(*var) + val);
+}
+
+static inline void le32_add_cpu(__le32 *var, u32 val)
+{
+       *var = cpu_to_le32(le32_to_cpu(*var) + val);
+}
+
+static inline void le64_add_cpu(__le64 *var, u64 val)
+{
+       *var = cpu_to_le64(le64_to_cpu(*var) + val);
+}
+
+static inline void be16_add_cpu(__be16 *var, u16 val)
+{
+       *var = cpu_to_be16(be16_to_cpu(*var) + val);
+}
+
+static inline void be32_add_cpu(__be32 *var, u32 val)
+{
+       *var = cpu_to_be32(be32_to_cpu(*var) + val);
+}
+
+static inline void be64_add_cpu(__be64 *var, u64 val)
+{
+       *var = cpu_to_be64(be64_to_cpu(*var) + val);
+}
+
 /* 2.6.25 changes hwrng_unregister()'s behaviour by supporting
  * suspend of its parent device (the misc device, which is itself the
  * hardware random number generator). It does this by passing a parameter to
