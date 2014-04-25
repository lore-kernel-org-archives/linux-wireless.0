Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:56501 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751529AbaDYHrE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 03:47:04 -0400
Received: by mail-wi0-f169.google.com with SMTP id hm4so2283994wib.2
        for <linux-wireless@vger.kernel.org>; Fri, 25 Apr 2014 00:47:02 -0700 (PDT)
Message-ID: <535A12F3.8020003@gmail.com> (sfid-20140425_094711_103003_A108A165)
Date: Fri, 25 Apr 2014 10:46:59 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Julian Sikorski <belegdol@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Low 5 GHz performance of Intel Advanced-N 6230
References: <5358AADD.3010702@gmail.com> <ljbdr0$c27$1@ger.gmane.org>
In-Reply-To: <ljbdr0$c27$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 04/24/2014 07:24 PM, Julian Sikorski wrote:
> W dniu 24.04.2014 08:10, Julian Sikorski pisze:
>> Dear all,
>>
>> I have been moderately recently hit by a performance drop of Intel
>> Advanced-N 6230 card. I unfortunately do not have the "before" numbers,
>> but I have noticed this since I was able to stream bluray rips over nfs
>> to a wired Raspberry Pi a while ago and now I cannot. This has lead me
>> to begin investigating the issue.
>> In the end I have used iperf3, testing speeds between RPi and laptop,
>> with laptop running both Windows and Linux. iperf3 on RPi was always the
>> same, on the laptop it was self-compiled iperf3 git master (on Windows I
>> used Cygwin). Please see the observed speeds below:
>> - Windows: upload to RPi 93 Mbit/s, download from RPi 54 Mbit/s
>> - Fedora: upload to RPi 26 Mbit/s, download from RPi 48 Mbit/s
>>
>> This is all on Fedora 20 x86_64. Please find attached the journalctl log
>> for the last boot. Please let me know if more information is needed - I
>> would love to get my network speeds back up to the level where I can
>> watch bluray rips again. Thank you for your support in advance.
>>
>> Best regards,
>> Julian
>>
> Hello again,
> 
> I have narrowed this down to have regressed between 3.13.6-200.fc20 and
> 3.13.7-200. Using pointers from Josh Boyer of #fedora-devel, I have
> managed to restore the previous performance by loading iwlwifi with
> 11n_disable=8. I am now at 3.14.1-200 with that option enabled and the
> network is fast as it used to be.
> Is such a major performance hit expected from this change? Here is the
> commit in question:
> https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/commit/?h=linux-3.13.y&id=45e5cb4f43d33e72ff5f98c80b081eb42e4e4182
> 

Right - I disabled TX APMDU in this patch. This feature gives a big boost in TX performance, but lots of people experienced bugs that disappeared when this feature was disabled. This bug is in the firmware. Since the most common use case is to browse the internet which is more Rx than Tx, I decided to disabled this feature by default and allow people to enabled it using the module parameter.
