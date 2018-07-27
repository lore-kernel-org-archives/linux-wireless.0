Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:52232 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732981AbeG0RId (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 13:08:33 -0400
Subject: Re: [PATCH] hostap: hide unused procfs helpers
To: YueHaibing <yuehaibing@huawei.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: j@w1.fi, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, davem@davemloft.net
References: <20180713070317.6724-1-yuehaibing@huawei.com>
 <5B485441.1080305@broadcom.com> <87r2jpvxme.fsf@codeaurora.org>
 <9c6401cd-c04c-1230-d360-922b476c6541@huawei.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <c6fda6cf-3041-66f0-71b8-f86ccadc9260@infradead.org> (sfid-20180727_174618_283717_02EE3E7B)
Date: Fri, 27 Jul 2018 08:46:00 -0700
MIME-Version: 1.0
In-Reply-To: <9c6401cd-c04c-1230-d360-922b476c6541@huawei.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/27/2018 03:03 AM, YueHaibing wrote:
> On 2018/7/27 17:25, Kalle Valo wrote:
>> Arend van Spriel <arend.vanspriel@broadcom.com> writes:
>>
>>> + Randy
>>>
>>> On 7/13/2018 9:03 AM, YueHaibing wrote:
>>>> When CONFIG_PROC_FS isn't set, gcc warning this:
>>>>
>>>> drivers/net/wireless/intersil/hostap/hostap_hw.c:2901:12: warning: ‘prism2_registers_proc_show’ defined but not used [-Wunused-function]
>>>>   static int prism2_registers_proc_show(struct seq_file *m, void *v)
>>>>
>>>> drivers/net/wireless/intersil/hostap/hostap_proc.c:16:12: warning: ‘prism2_debug_proc_show’ defined but not used [-Wunused-function]
>>>>   static int prism2_debug_proc_show(struct seq_file *m, void *v)
>>>>              ^
>>>> drivers/net/wireless/intersil/hostap/hostap_proc.c:49:12: warning: ‘prism2_stats_proc_show’ defined but not used [-Wunused-function]
>>>>   static int prism2_stats_proc_show(struct seq_file *m, void *v)
>>>>              ^
>>>> drivers/net/wireless/intersil/hostap/hostap_proc.c:177:12: warning: ‘prism2_crypt_proc_show’ defined but not used [-Wunused-function]
>>>>   static int prism2_crypt_proc_show(struct seq_file *m, void *v)
>>>>              ^
>>>>
>>>> fix this by adding #ifdef around them.
>>>> hfa384x_read_reg is only used by prism2_registers_proc_show,so move it
>>>> into #ifdef.
>>>
>>> There was already a fix for this posted by Randy Dunlap taking a
>>> different approach, ie. use __maybe_unused classifier. To be honest I
>>> prefer the ifdef approach as it is more explicit and does not feel
>>> like a cheat.
>>
>> I also prefer the ifdef approach more so I'm planning to take this
>> patch.
> 
> It's ok if you prefer pick this.

Right.

-- 
~Randy
