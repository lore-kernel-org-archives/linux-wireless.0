Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44622 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729431AbeG0Kqf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 Jul 2018 06:46:35 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: YueHaibing <yuehaibing@huawei.com>, j@w1.fi,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, davem@davemloft.net,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] hostap: hide unused procfs helpers
References: <20180713070317.6724-1-yuehaibing@huawei.com>
        <5B485441.1080305@broadcom.com>
Date: Fri, 27 Jul 2018 12:25:29 +0300
In-Reply-To: <5B485441.1080305@broadcom.com> (Arend van Spriel's message of
        "Fri, 13 Jul 2018 09:26:57 +0200")
Message-ID: <87r2jpvxme.fsf@codeaurora.org> (sfid-20180727_112547_624828_699C5C0C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> + Randy
>
> On 7/13/2018 9:03 AM, YueHaibing wrote:
>> When CONFIG_PROC_FS isn't set, gcc warning this:
>>
>> drivers/net/wireless/intersil/hostap/hostap_hw.c:2901:12: warning: =E2=
=80=98prism2_registers_proc_show=E2=80=99 defined but not used [-Wunused-fu=
nction]
>>   static int prism2_registers_proc_show(struct seq_file *m, void *v)
>>
>> drivers/net/wireless/intersil/hostap/hostap_proc.c:16:12: warning: =E2=
=80=98prism2_debug_proc_show=E2=80=99 defined but not used [-Wunused-functi=
on]
>>   static int prism2_debug_proc_show(struct seq_file *m, void *v)
>>              ^
>> drivers/net/wireless/intersil/hostap/hostap_proc.c:49:12: warning: =E2=
=80=98prism2_stats_proc_show=E2=80=99 defined but not used [-Wunused-functi=
on]
>>   static int prism2_stats_proc_show(struct seq_file *m, void *v)
>>              ^
>> drivers/net/wireless/intersil/hostap/hostap_proc.c:177:12: warning: =E2=
=80=98prism2_crypt_proc_show=E2=80=99 defined but not used [-Wunused-functi=
on]
>>   static int prism2_crypt_proc_show(struct seq_file *m, void *v)
>>              ^
>>
>> fix this by adding #ifdef around them.
>> hfa384x_read_reg is only used by prism2_registers_proc_show,so move it
>> into #ifdef.
>
> There was already a fix for this posted by Randy Dunlap taking a
> different approach, ie. use __maybe_unused classifier. To be honest I
> prefer the ifdef approach as it is more explicit and does not feel
> like a cheat.

I also prefer the ifdef approach more so I'm planning to take this
patch.

--=20
Kalle Valo
