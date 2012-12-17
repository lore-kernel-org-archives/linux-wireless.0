Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:60331 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2LQMrj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 07:47:39 -0500
Message-ID: <50CF1465.3050205@canonical.com> (sfid-20121217_134748_414291_1154357B)
Date: Mon, 17 Dec 2012 04:47:33 -0800
From: John Johansen <john.johansen@canonical.com>
MIME-Version: 1.0
To: Chaitanya <chaitanyatk@posedge.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] Apparamor: Fix the OOPS due to wrong header inclusion
 in file in Makefile(3.7.0-rc1 Kernel)
References: <201212171158.qBHBwYni003158@chaitanya-desktop> <50CF0C21.60101@posedge.com>
In-Reply-To: <50CF0C21.60101@posedge.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/17/2012 04:12 AM, Chaitanya wrote:
> 
> 
> Fix the OOPS in the apparmor security module
> during the bootup.(oops points to strlen in audit_log_untrustedstring function)
> Note: Actual fix lifted from Al-Viro.
>  
> Signed-off-by: Chaitanya T K <chaitanyatk@posedge.com>

thanks for reporting, this patch was included in 3.7-rc2
see 43c422eda99b894f18d1cca17bcd2401efaf7bd0


> ---
>  security/apparmor/Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/security/apparmor/Makefile b/security/apparmor/Makefile
> index 7b3021c..5706b74 100644
> --- a/security/apparmor/Makefile
> +++ b/security/apparmor/Makefile
> @@ -57,7 +57,7 @@ cmd_make-rlim = echo "static const char *const rlim_names[RLIM_NLIMITS] = {" \
>  
>  $(obj)/capability.o : $(obj)/capability_names.h
>  $(obj)/resource.o : $(obj)/rlim_names.h
> -$(obj)/capability_names.h : $(srctree)/include/linux/capability.h \
> +$(obj)/capability_names.h : $(srctree)/include/uapi/linux/capability.h \
>  			    $(src)/Makefile
>  	$(call cmd,make-caps)
>  $(obj)/rlim_names.h : $(srctree)/include/uapi/asm-generic/resource.h \
> 
> 
> 
> 

