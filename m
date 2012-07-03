Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64548 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181Ab2GCQRM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2012 12:17:12 -0400
Received: by pbbrp8 with SMTP id rp8so9454077pbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jul 2012 09:17:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VvJ+rv4mtYMngVg==tDVZpRM2CrGJ3Yc4u7a7ZLwiGOA@mail.gmail.com>
References: <1341322108.20124.3.camel@jlt3.sipsolutions.net> <CAB=NE6VvJ+rv4mtYMngVg==tDVZpRM2CrGJ3Yc4u7a7ZLwiGOA@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 3 Jul 2012 09:16:51 -0700
Message-ID: <CAB=NE6WDyFS5gK85Lq1uEA5A5HLRhhyVcFT7EQkK0SALG0YF6g@mail.gmail.com> (sfid-20120703_181726_112102_FA54256F)
Subject: Re: [PATCH] compat-wireless: fix debugging in iwlwifi
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 3, 2012 at 8:47 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Jul 3, 2012 at 6:28 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> From: Johannes Berg <johannes.berg@intel.com>
>>
>> As compat includes linux/device.h well before iwlwifi, the
>> definitions from there are used without DEBUG, but iwlwifi
>> defines DEBUG to get debug output. Use dev_printk instead
>> of dev_dbg to get debugging back.
>>
>> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>
> Applied and pushed, thanks!

On today's linux-next.git the dev_dbg() changed to dev_err(), I've
updated the patch to reflect this.

mcgrof@tux ~/devel/compat-wireless (git::master)$ git diff
diff --git a/patches/57-iwlwifi-debug-fix.patch
b/patches/57-iwlwifi-debug-fix.patch
index 4b2dfa9..1bfc88f 100644
--- a/patches/57-iwlwifi-debug-fix.patch
+++ b/patches/57-iwlwifi-debug-fix.patch
@@ -9,7 +9,7 @@ dev_printk to make them show up again.

                va_copy(args2, args);
                vaf.va = &args2;
--              dev_dbg(dev, "%c %s %pV", in_interrupt() ? 'I' : 'U',
+-              dev_err(dev, "%c %s %pV", in_interrupt() ? 'I' : 'U',
 -                      function, &vaf);
 +              dev_printk(KERN_DEBUG, dev, "%c %s %pV",
 +                         in_interrupt() ? 'I' : 'U'

  Luis
