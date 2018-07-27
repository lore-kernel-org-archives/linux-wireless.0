Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:10143 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731165AbeG0LY4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 07:24:56 -0400
Subject: Re: [PATCH] hostap: hide unused procfs helpers
To: Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
References: <20180713070317.6724-1-yuehaibing@huawei.com>
 <5B485441.1080305@broadcom.com> <87r2jpvxme.fsf@codeaurora.org>
CC: <j@w1.fi>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
        <davem@davemloft.net>, Randy Dunlap <rdunlap@infradead.org>
From: YueHaibing <yuehaibing@huawei.com>
Message-ID: <9c6401cd-c04c-1230-d360-922b476c6541@huawei.com> (sfid-20180727_120627_461912_265686D9)
Date: Fri, 27 Jul 2018 18:03:38 +0800
MIME-Version: 1.0
In-Reply-To: <87r2jpvxme.fsf@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018/7/27 17:25, Kalle Valo wrote:
> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
> 
>> + Randy
>>
>> On 7/13/2018 9:03 AM, YueHaibing wrote:
>>> When CONFIG_PROC_FS isn't set, gcc warning this:
>>>
>>> drivers/net/wireless/intersil/hostap/hostap_hw.c:2901:12: warning: ‘prism2_registers_proc_show’ defined but not used [-Wunused-function]
>>>   static int prism2_registers_proc_show(struct seq_file *m, void *v)
>>>
>>> drivers/net/wireless/intersil/hostap/hostap_proc.c:16:12: warning: ‘prism2_debug_proc_show’ defined but not used [-Wunused-function]
>>>   static int prism2_debug_proc_show(struct seq_file *m, void *v)
>>>              ^
>>> drivers/net/wireless/intersil/hostap/hostap_proc.c:49:12: warning: ‘prism2_stats_proc_show’ defined but not used [-Wunused-function]
>>>   static int prism2_stats_proc_show(struct seq_file *m, void *v)
>>>              ^
>>> drivers/net/wireless/intersil/hostap/hostap_proc.c:177:12: warning: ‘prism2_crypt_proc_show’ defined but not used [-Wunused-function]
>>>   static int prism2_crypt_proc_show(struct seq_file *m, void *v)
>>>              ^
>>>
>>> fix this by adding #ifdef around them.
>>> hfa384x_read_reg is only used by prism2_registers_proc_show,so move it
>>> into #ifdef.
>>
>> There was already a fix for this posted by Randy Dunlap taking a
>> different approach, ie. use __maybe_unused classifier. To be honest I
>> prefer the ifdef approach as it is more explicit and does not feel
>> like a cheat.
> 
> I also prefer the ifdef approach more so I'm planning to take this
> patch.

It's ok if you prefer pick this.

> 
