Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:46435 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681Ab2LQPSS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 10:18:18 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so5587974iay.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2012 07:18:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50CF1465.3050205@canonical.com>
References: <201212171158.qBHBwYni003158@chaitanya-desktop>
 <50CF0C21.60101@posedge.com> <50CF1465.3050205@canonical.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 17 Dec 2012 20:47:57 +0530
Message-ID: <CABPxzYLQnQhhWx5aoB5MJ4P0LdRgGxaVEt0+J6f_x6+CVZpk3g@mail.gmail.com> (sfid-20121217_161822_562483_C4E33C91)
Subject: Re: [PATCH] Apparamor: Fix the OOPS due to wrong header inclusion in
 file in Makefile(3.7.0-rc1 Kernel)
To: John Johansen <john.johansen@canonical.com>
Cc: Chaitanya <chaitanyatk@posedge.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ok. But it will be good if its in the mac80211-next branch, its really
annoying :-)

On Mon, Dec 17, 2012 at 6:17 PM, John Johansen
<john.johansen@canonical.com> wrote:
> On 12/17/2012 04:12 AM, Chaitanya wrote:
>>
>>
>> Fix the OOPS in the apparmor security module
>> during the bootup.(oops points to strlen in audit_log_untrustedstring function)
>> Note: Actual fix lifted from Al-Viro.
>>
>> Signed-off-by: Chaitanya T K <chaitanyatk@posedge.com>
>
> thanks for reporting, this patch was included in 3.7-rc2
> see 43c422eda99b894f18d1cca17bcd2401efaf7bd0
>
>
>> ---
>>  security/apparmor/Makefile |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/security/apparmor/Makefile b/security/apparmor/Makefile
>> index 7b3021c..5706b74 100644
>> --- a/security/apparmor/Makefile
>> +++ b/security/apparmor/Makefile
>> @@ -57,7 +57,7 @@ cmd_make-rlim = echo "static const char *const rlim_names[RLIM_NLIMITS] = {" \
>>
>>  $(obj)/capability.o : $(obj)/capability_names.h
>>  $(obj)/resource.o : $(obj)/rlim_names.h
>> -$(obj)/capability_names.h : $(srctree)/include/linux/capability.h \
>> +$(obj)/capability_names.h : $(srctree)/include/uapi/linux/capability.h \
>>                           $(src)/Makefile
>>       $(call cmd,make-caps)
>>  $(obj)/rlim_names.h : $(srctree)/include/uapi/asm-generic/resource.h \
>>
>>
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
