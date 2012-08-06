Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:58892 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139Ab2HFVqI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 17:46:08 -0400
Message-ID: <50203B17.9010606@hauke-m.de> (sfid-20120806_234613_331455_2BBAD83A)
Date: Mon, 06 Aug 2012 23:45:59 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [PATCH v2] compat: deal with backported codel
References: <1344095900.5982.0.camel@jlt3.sipsolutions.net> <1344162581.4513.1.camel@jlt3.sipsolutions.net> <CAB=NE6XLMTwG65EhExSES-rPsKK7SDBx4+MgwqxuJL__ZtN=zw@mail.gmail.com> <50202A06.7090308@hauke-m.de>
In-Reply-To: <50202A06.7090308@hauke-m.de>
Content-Type: multipart/mixed;
 boundary="------------090700040207090408000507"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090700040207090408000507
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 08/06/2012 10:33 PM, Hauke Mehrtens wrote:
> On 08/06/2012 09:53 PM, Luis R. Rodriguez wrote:
>> On Sun, Aug 5, 2012 at 3:29 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>>> From: Johannes Berg <johannes.berg@intel.com>
>>>
>>> Some distro kernels (in particular the Debian 3.2.0-3
>>> kernel I'm running) backport codel already, so trying
>>> to backport it again causes issues. Protect the compat
>>> backport with #ifdef TCA_CODEL_MAX.
>>>
>>> Also link the flow_dissector code into the codel module
>>> which then won't be loaded on kernels that already have
>>> codel backported.
>>>
>>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>>
>> Applied and pushed, thanks!
>>
>>   Luis
>>
> This breaks my build if net/codel.h is not in the kernel headers:
> 
> In file included from
> /home/hauke/compat-wireless/compat-wireless/compat/sch_fq_codel_core.c:27:0:
> /home/hauke/compat-wireless/compat-wireless/include/net/codel.h:5:28:
> fatal error: net/codel.h: No such file or directory
> compilation terminated.
> 
> TCA_CODEL_MAX is defined in include/linux/compat-3.5.h and this file is
> included ever time, so the check around #include_next <net/codel.h> is
> never false.
> 
> You could define something like COMPAT_CODEL_BACKPORT in
> include/linux/compat-3.5.h and extend the check in include/net/codel.h
> that this has to be unset.
> 
> Hauke

With the attached patch in addition to Johannes' patch it works for me.
Anyone feel free to integrate it or use it in any other way.

Hauke

--------------090700040207090408000507
Content-Type: text/x-patch;
 name="codel.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="codel.patch"

diff --git a/include/linux/compat-3.5.h b/include/linux/compat-3.5.h
index 7fadbf2..3aec3bd 100644
--- a/include/linux/compat-3.5.h
+++ b/include/linux/compat-3.5.h
@@ -150,6 +150,8 @@ static inline int compat_vga_switcheroo_register_client(struct pci_dev *dev,
 #ifndef TCA_CODEL_MAX
 /* CODEL */
 
+#define COMPAT_CODEL_BACKPORT
+
 enum {
 	TCA_CODEL_UNSPEC,
 	TCA_CODEL_TARGET,
diff --git a/include/net/codel.h b/include/net/codel.h
index ab901c5..eee0359 100644
--- a/include/net/codel.h
+++ b/include/net/codel.h
@@ -1,7 +1,7 @@
 #include <linux/version.h>
 #include <linux/pkt_sched.h>
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,5,0)) || defined(TCA_CODEL_MAX)
+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,5,0)) || (defined(TCA_CODEL_MAX) && !defined(COMPAT_CODEL_BACKPORT))
 #include_next <net/codel.h>
 #else
 

--------------090700040207090408000507--
