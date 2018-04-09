Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f175.google.com ([74.125.82.175]:34603 "EHLO
        mail-ot0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752970AbeDIQSM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 12:18:12 -0400
Received: by mail-ot0-f175.google.com with SMTP id m7-v6so9269274otd.1
        for <linux-wireless@vger.kernel.org>; Mon, 09 Apr 2018 09:18:12 -0700 (PDT)
Subject: Re: iwlwifi-7265-ucode-25.30.14.0.tgz. in Centos 7
To: Dusan Bruncko <dusan.bruncko@cern.ch>,
        linux-wireless@vger.kernel.org, centos-devel@centos.org
References: <fe3605be-8ce1-ee6f-7ea2-7f736f5493fb@cern.ch>
 <238bda30-c983-f4aa-fdaf-a4f06cb83c1d@lwfinger.net>
 <e01645c5-16eb-aa47-2926-1b2890687b2f@cern.ch>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <23bb800e-544c-607e-43ae-6833949167af@lwfinger.net> (sfid-20180409_181816_692075_110A1D0E)
Date: Mon, 9 Apr 2018 11:18:10 -0500
MIME-Version: 1.0
In-Reply-To: <e01645c5-16eb-aa47-2926-1b2890687b2f@cern.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/08/2018 11:56 PM, Dusan Bruncko wrote:
> Dear Larry,
> 
> Thank you for your mail. But concerning to "capa flags index 3", I am not sure. 
> Please look
> following message receiving for command "ps aux",
> 
> /usr/bin/abrt-watch-log -F BUG: WARNING: at WARNING:
> CPU: INFO: possible recursive locking detected ernel BUG at list_del corruption 
> list_add corruption do_IRQ: stack over
> flow: ear stack overflow (cur: eneral protection fault nable to handle kernel 
> ouble fault: RTNL: assertion failed eek!
>   page_mapcount(page) went negative! adness at NETDEV WATCHDOG ysctl table check 
> failed : nobody cared IRQ handler type
>   mismatch Machine Check Exception: Machine check events logged divide error: 
> bounds: coprocessor segment overrun: inva
> lid TSS: segment not present: invalid opcode: alignment check: stack segment: 
> fpu exception: simd exception: iret exce
> ption: /var/log/messages -- /usr/bin/abrt-dump-oops -xtD
> 
> I am not software expert, but also looking on message from abrt:
> 
> Subject: [abrt] : divide error: 0000 [#1] SMP => look attachment.
> 
> Maybe it is direct consequence connected with my wi-fi problem...
> 
> Regards,
>                    Dusan
> 
> Larry Finger wrote:
>> On 04/08/2018 01:58 AM, Dusan Bruncko wrote:
>>> Hello,
>>>
>>> Allow me to ask you the following question:
>>>
>>> I have laptop with: "02:00.0 Network controller: Intel Corporation Wireless 
>>> 7265 (rev 59)".
>>> For this device I found firmware iwlwifi-7265-ucode-25.30.14.0.tgz.
>>>
>>> My problem is following: This firmware was created for kernel 4.2+, but I am 
>>> using
>>> Centos 7 with kernels a la 3.10. Therefore I see during booting and after 
>>> switch off some
>>> problematic messages a la:
>>> capa flags index 3 larger than supported by driver  or
>>> failed to remove key (2, ff:ff:ff:ff:ff:ff) from hardware ...
>>>
>>> Wi-fi works properly, not to look on the previous messages.
>>>
>>> My question to you: do you have in schedule to include proper firmware also for
>>> centos 7/redhat 7?
>>
>> If your kernel were newer, I would recommend running the backports drivers, 
>> but I think 3.10 is too old. That said, this code change would not fix the 
>> "failed to remove key" message as I get that on my 7260 device with kernel 
>> 4.16.0. I think you may safely ignore this one if for no other reason than it 
>> only happens when the device is being shut down.
>>
>> If the "capa flags index 3" message is not causing any problems, I would 
>> ignore it as well.

On this and most mailing lists, one should not top post. It is most inconvenient 
to have to continually scroll up and down to get to your comments while writing 
mine.

In your first posting, you said "Wi-fi works properly". That certainly does not 
imply any problems other than the strange messages in the log. If you are 
getting BUG and/or WARNING dumps, then the output of the dmesg command will list 
the traceback. I do not see any of those. They may be a consequence of using 
such an old kernel. I am only an Intel wifi user, not a developer, and it is 
unlikely that I will be able to fix any of your problems. In any case, you need 
to post the full tracebacks of those BUGS/WARNINGS here. Remember, do not post 
at the top.

Larry

A: Because it puts things out of order.
Q: Why is top posting bad?
