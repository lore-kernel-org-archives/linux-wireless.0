Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45065 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727582AbeGMHkV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jul 2018 03:40:21 -0400
Received: by mail-wr1-f65.google.com with SMTP id c4-v6so11378653wrs.12
        for <linux-wireless@vger.kernel.org>; Fri, 13 Jul 2018 00:27:00 -0700 (PDT)
Subject: Re: [PATCH] hostap: hide unused procfs helpers
To: YueHaibing <yuehaibing@huawei.com>, j@w1.fi, kvalo@codeaurora.org
References: <20180713070317.6724-1-yuehaibing@huawei.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, davem@davemloft.net,
        Randy Dunlap <rdunlap@infradead.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5B485441.1080305@broadcom.com> (sfid-20180713_092703_578235_2422D665)
Date: Fri, 13 Jul 2018 09:26:57 +0200
MIME-Version: 1.0
In-Reply-To: <20180713070317.6724-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+ Randy

On 7/13/2018 9:03 AM, YueHaibing wrote:
> When CONFIG_PROC_FS isn't set, gcc warning this:
>
> drivers/net/wireless/intersil/hostap/hostap_hw.c:2901:12: warning: ‘prism2_registers_proc_show’ defined but not used [-Wunused-function]
>   static int prism2_registers_proc_show(struct seq_file *m, void *v)
>
> drivers/net/wireless/intersil/hostap/hostap_proc.c:16:12: warning: ‘prism2_debug_proc_show’ defined but not used [-Wunused-function]
>   static int prism2_debug_proc_show(struct seq_file *m, void *v)
>              ^
> drivers/net/wireless/intersil/hostap/hostap_proc.c:49:12: warning: ‘prism2_stats_proc_show’ defined but not used [-Wunused-function]
>   static int prism2_stats_proc_show(struct seq_file *m, void *v)
>              ^
> drivers/net/wireless/intersil/hostap/hostap_proc.c:177:12: warning: ‘prism2_crypt_proc_show’ defined but not used [-Wunused-function]
>   static int prism2_crypt_proc_show(struct seq_file *m, void *v)
>              ^
>
> fix this by adding #ifdef around them.
> hfa384x_read_reg is only used by prism2_registers_proc_show,so move it
> into #ifdef.

There was already a fix for this posted by Randy Dunlap taking a 
different approach, ie. use __maybe_unused classifier. To be honest I 
prefer the ifdef approach as it is more explicit and does not feel like 
a cheat.

Actually some of the functions are between a flag already 
PRISM2_NO_PROCFS_DEBUG which is in a private header file 
hostap_config.h. Seems like this would be better placed in Kconfig and 
depend on CONFIG_PROCFS. Anyway, this driver is old cruft. Maybe some 
people are still running it, but it is probably not worth the effort so 
fine with either fix.

Regards,
Arend
