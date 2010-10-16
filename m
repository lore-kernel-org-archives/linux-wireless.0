Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63101 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040Ab0JPAVG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Oct 2010 20:21:06 -0400
Received: by ewy20 with SMTP id 20so1833531ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Oct 2010 17:21:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010160037.06949.chunkeey@googlemail.com>
References: <AANLkTimqNvJ=93NA_s_p3Ype9pYey2+YS0zO0r9TZKd=@mail.gmail.com>
	<201010160037.06949.chunkeey@googlemail.com>
Date: Fri, 15 Oct 2010 17:21:02 -0700
Message-ID: <AANLkTikPRY9_O=u0uL+z_Bbk-J97vxEDBji1xbUYgHtU@mail.gmail.com>
Subject: Re: General protection fault in ieee80211_stop_tx_ba_sessions
From: Blaise Gassend <blaise@willowgarage.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have updated. Will let you know if the problem recurs.

Thanks,
Blaise

On Fri, Oct 15, 2010 at 3:37 PM, Christian Lamparter
<chunkeey@googlemail.com> wrote:
> On Saturday 16 October 2010 00:20:19 Blaise Gassend wrote:
>> I have been getting a general protection fault in
>> ieee80211_stop_tx_ba_sessions. This mostly seems to happen within a
>> few tens of seconds of bringing the interface up.
>>
>> I am pasting a backtrace and system information below below. What
>> other information would be useful to help track this down?
>>
>> Kernel:
>> Linux version 2.6.32-24-generic (buildd@crested) (gcc version 4.4.3
>> (Ubuntu 4.4.3-4ubuntu5) ) #42-Ubuntu SMP Fri Aug 20 14:21:58 UTC 2010
>>
>> Wireless:
>> compat-wireless-2010-10-04
> please update, because it looks like your problem could be fixed by:
> "mac80211: delete AddBA response timer" (2010-10-05)
> http://www.spinics.net/lists/linux-wireless/msg56886.html
>
>> Backtrace (Keeps spewing for a really long time, I can provide more if
>> necessary):
>> general protection fault: 0000 [#1] SMP
>> RIP: 0010:[<xyz>]  [<xyz>] ieee80211_stop_tx_ba_session+0x35/0xd0 [mac80211]
>> Process swapper (pid: 0, threadinfo ffff88013392e000,
>> Call Trace:
>>  <IRQ>
>>  [<81019e69>] ? sched_clock+0x9/0x10
>>  [<a0120a40>] ? sta_addba_resp_timer_expired+0x0/0x50 [mac80211] <<<
>>  [<a0120a87>] ? sta_addba_resp_timer_expired+0x47/0x50 [mac80211]
>>  [<8107776b>] ? run_timer_softirq+0x19b/0x340
>>  [<812b92bd>] ? rb_insert_color+0x9d/0x160
>>  [<8108f723>] ? ktime_get+0x63/0xe0
>
