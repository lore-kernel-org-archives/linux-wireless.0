Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:60970 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754653AbaIQMSm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 08:18:42 -0400
Received: by mail-wg0-f50.google.com with SMTP id x13so1277752wgg.21
        for <linux-wireless@vger.kernel.org>; Wed, 17 Sep 2014 05:18:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAfyv36KrG5SjsJjPqaXp4SuE2hnG-EsXpTE-WrhM8zOdye2-g@mail.gmail.com>
References: <CAAfyv35k1mgQh6FcWaaMciAo8Vkp055k=5xF7zu+yrHmrQbbLA@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951819DB12F1@SC-VEXCH1.marvell.com>
	<CAAfyv35j-77AURB4fHcecbEvyGS6U+1APNRFCf3FDAd_rrWnJw@mail.gmail.com>
	<5FF020A1CFFEEC49BD1E09530C4FF5951821351855@SC-VEXCH1.marvell.com>
	<CAAfyv36KrG5SjsJjPqaXp4SuE2hnG-EsXpTE-WrhM8zOdye2-g@mail.gmail.com>
Date: Wed, 17 Sep 2014 14:18:40 +0200
Message-ID: <CAAfyv359EgdcYqa_HTzsw17HYw0NHU6gq8wmhgexbyLZ=OrQPw@mail.gmail.com> (sfid-20140917_141848_957144_BF4B1398)
Subject: Re: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed when conected to 5GHz
From: Belisko Marek <marek.belisko@gmail.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Avinash Patil <patila@marvell.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I was too fast when hitting Send :)

On Wed, Sep 17, 2014 at 2:07 PM, Belisko Marek <marek.belisko@gmail.com> wrote:
> Dear Amitkumar Karwar,
>
> On Wed, Sep 17, 2014 at 12:52 PM, Amitkumar Karwar <akarwar@marvell.com> wrote:
>> Hi BR,
>>
>>> Dear Amitkumar Karwar,
>>>
>>> some additional info.
>>>
>>> On Thu, Sep 11, 2014 at 5:09 PM, Amitkumar Karwar <akarwar@marvell.com>
>>> wrote:
>>> > Hi BR,
>>> >
>>> >>
>>> >> I'm using 3.9 mainline mwifiex driver for wireless usb card. Doing
>>> >> some throughput testing (with iperf) in 5GHz I got following
>>> failures:
>>> >> [ 221.521799] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb
>>> >> failed
>>> >
>>> > This is skb allocation failure returned by kernel. 4k buffer is
>>> always allocated for Rx packets. This issue doesn't seem to be specific
>>> to 5Ghz.
>>> Yes you're right. I can reproduce issue also with 2.4GHz (doing iperf
>>> testing as mentioned in other email) by pinging device with card.
>>> >
>>> >>
>>> >> I checked which which size fails to allocate and it's 4096 bytes. I
>>> >> was looking to changes in never kernel releases but I cannot find
>>> >> anything obvious. When connected to 2.4GHz I cannot reproduce issue
>>> >> though. I'm using FW version mwifiex 1.0 (14.68.29.p26).
>>> >>
>>> >
>>> > Could you please provide the platform details?
>>> > How often the problem occurs during throughput testing? Are there any
>>> specific steps?
>>> One more observation is that when problem occurred complete system is
>>> unresponsive (console is almost completely dead).
>>
>> Thanks for the more information.
>> Skb alloc failure should be gracefully handled. We will look into this issue.
> OK. Thanks. Can you please
Can you please ping me when you will have some patch so I can test it
also on my device.
>>
>>> I can workaround issue by decreasing iperf bandwidth to ~40m. I think
>>> in this situation we're running out of memory by exhaustive skb
>>> allocations.
>>
>> Actually 6 4K size buffers are being allocated for Rx and Tx data during traffic.
>> Probably your platform runs out of memory after these allocations.
> This could be the issue. I'm running some apps when performing
> throughput test and this could lead
> to out of memory. When I stop all apps and perform the test it behave
> better (I cannot reproduce issue) except of
> fact that whole system is unresponsive for ~ 10 secs as was already mentioned.
This is not fully true. I run loop iperf test (-t 600) and it will
fail after 4 minutes with (there was around 190MB free memory):

[  875.249551] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
[  875.256645] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
[  875.263694] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
[  875.270940] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
[  875.277993] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
[  875.285068] usb 1-1: mwifiex_usb_submit_rx_urb: dev_alloc_skb failed
[  3]  0.0- 1.0 sec  81.8 KBytes    670 Kbits/sec  0.034 ms    0/   57 (0%)
[  3]  1.0- 2.0 sec  0.00 Bytes  0.00 bits/sec  0.034 ms    0/    0 (nan%)
[  3]  2.0- 3.0 sec  0.00 Bytes  0.00 bits/sec  0.034 ms    0/    0 (nan%)
[  3]  3.0- 4.0 sec  0.00 Bytes  0.00 bits/sec  0.034 ms    0/    0 (nan%)
[  3]  4.0- 5.0 sec  0.00 Bytes  0.00 bits/sec  0.034 ms    0/    0 (nan%)
[  3]  5.0- 6.0 sec  0.00 Bytes  0.00 bits/sec  0.034 ms    0/    0 (nan%)
[  3]  6.0- 7.0 sec  0.00 Bytes  0.00 bits/sec  0.034 ms    0/    0 (nan%)
[  3]  7.0- 8.0 sec  0.00 Bytes  0.00 bits/sec  0.034 ms    0/    0 (nan%)
[  3]  8.0- 9.0 sec  0.00 Bytes  0.00 bits/sec  0.034 ms    0/    0 (nan%)
[  3]  9.0-10.0 sec  0.00 Bytes  0.00 bits/sec  0.034 ms    0/    0 (nan%)
[  3] 10.0-11.0 sec  0.00 Bytes  0.00 bits/sec  0.034 ms    0/    0 (nan%)
[  3] 11.0-12.0 sec  0.00 Bytes  0.00 bits/sec  0.034 ms    0/    0 (nan%)
[  3] 12.0-13.0 sec  0.00 Bytes  0.00 bits/sec  0.034 ms    0/    0 (nan%)
[  3] 13.0-14.0 sec  0.00 Bytes  0.00 bits/sec  0.034 ms    0/    0 (nan%)
[  3] 14.0-15.0 sec  81.8 KBytes    670 Kbits/sec  24.506 ms   60/  117 (51%)


[ 1019.644302] usb 1-1: mwifiex_cmd_timeout_func: Timeout cmd id
(1410955919.418091) = 0x6, act = 0x3
[ 1019.653826] usb 1-1: num_data_h2c_failure = 0
[ 1019.658409] usb 1-1: num_cmd_h2c_failure = 0
[ 1019.662907] usb 1-1: num_cmd_timeout = 1
[ 1019.667072] usb 1-1: num_tx_timeout = 0
[ 1019.671117] usb 1-1: last_cmd_index = 4
[ 1019.675186] usb 1-1: last_cmd_id: 28 00 28 00 28 00 5b 00 06 00
[ 1019.681426] usb 1-1: last_cmd_act: 13 01 13 01 13 01 01 00 03 00
[ 1019.687778] usb 1-1: last_cmd_resp_index = 3
[ 1019.692281] usb 1-1: last_cmd_resp_id: 28 80 28 80 28 80 5b 80 28 80
[ 1019.698997] usb 1-1: last_event_index = 2
[ 1019.703223] usb 1-1: last_event: 17 00 33 00 08 00 33 00 08 00
[ 1019.709389] usb 1-1: data_sent=0 cmd_sent=0
[ 1019.713820] usb 1-1: ps_mode=1 ps_state=0
[ 1019.718211] usb 1-1: cmd timeout

>>
>> Could you please try changing this number(MWIFIEX_TX_DATA_URB/MWIFIEX_RX_DATA_URB macros) to 3?
I tried but it doesn't help (also sometimes I see odd driver crashes -
NULL pointer access)
>>
>> Regards,
>> Amitkumar Karwar
>
> Best Regards,
>
> marekb
>
> --
> as simple and primitive as possible
> -------------------------------------------------
> Marek Belisko - OPEN-NANDRA
> Freelance Developer
>
> Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
> Tel: +421 915 052 184
> skype: marekwhite
> twitter: #opennandra
> web: http://open-nandra.com

Best Regards,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
