Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:34450 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727189AbeGMJu6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jul 2018 05:50:58 -0400
Subject: Re: [PATCH] hostap: hide unused procfs helpers
To: Arend van Spriel <arend.vanspriel@broadcom.com>, <j@w1.fi>,
        <kvalo@codeaurora.org>
References: <20180713070317.6724-1-yuehaibing@huawei.com>
 <5B485441.1080305@broadcom.com>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>
From: YueHaibing <yuehaibing@huawei.com>
Message-ID: <6ebda7d5-364a-a242-527c-e57ce4888f9b@huawei.com> (sfid-20180713_113718_028696_EA99F755)
Date: Fri, 13 Jul 2018 17:37:03 +0800
MIME-Version: 1.0
In-Reply-To: <5B485441.1080305@broadcom.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 2018/7/13 15:26, Arend van Spriel wrote:
> + Randy
> 
> On 7/13/2018 9:03 AM, YueHaibing wrote:
>> When CONFIG_PROC_FS isn't set, gcc warning this:
>>
>> drivers/net/wireless/intersil/hostap/hostap_hw.c:2901:12: warning: ‘prism2_registers_proc_show’ defined but not used [-Wunused-function]
>>   static int prism2_registers_proc_show(struct seq_file *m, void *v)
>>
>> drivers/net/wireless/intersil/hostap/hostap_proc.c:16:12: warning: ‘prism2_debug_proc_show’ defined but not used [-Wunused-function]
>>   static int prism2_debug_proc_show(struct seq_file *m, void *v)
>>              ^
>> drivers/net/wireless/intersil/hostap/hostap_proc.c:49:12: warning: ‘prism2_stats_proc_show’ defined but not used [-Wunused-function]
>>   static int prism2_stats_proc_show(struct seq_file *m, void *v)
>>              ^
>> drivers/net/wireless/intersil/hostap/hostap_proc.c:177:12: warning: ‘prism2_crypt_proc_show’ defined but not used [-Wunused-function]
>>   static int prism2_crypt_proc_show(struct seq_file *m, void *v)
>>              ^
>>
>> fix this by adding #ifdef around them.
>> hfa384x_read_reg is only used by prism2_registers_proc_show,so move it
>> into #ifdef.
> 
> There was already a fix for this posted by Randy Dunlap taking a different approach, ie. use __maybe_unused classifier. To be honest I prefer the ifdef approach as it is more explicit and does not feel like a cheat.
> 
> Actually some of the functions are between a flag already PRISM2_NO_PROCFS_DEBUG which is in a private header file hostap_config.h. Seems like this would be better placed in Kconfig and depend on CONFIG_PROCFS. Anyway, this driver is old cruft. Maybe some people are still running it, but it is probably not worth the effort so fine with either fix.
> 

I dont check Randy's patch. ignore this pls.

> Regards,
> Arend
> 
> .
> 
