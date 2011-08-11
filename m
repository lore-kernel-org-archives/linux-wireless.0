Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52504 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab1HKKfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 06:35:34 -0400
Received: by wwf5 with SMTP id 5so1904068wwf.1
        for <linux-wireless@vger.kernel.org>; Thu, 11 Aug 2011 03:35:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110811021554.GA24567@internetdog.org>
References: <6264DDFA6754194CAB6452BFF5202C330F5F2115@SXGM-401.fg.rbc.com>
	<CAPoLzpe0OYq677NooOY5F7PyvbNobOXXCuSnoaF7ZVc0cJkjAw@mail.gmail.com>
	<20110811021554.GA24567@internetdog.org>
Date: Thu, 11 Aug 2011 06:35:32 -0400
Message-ID: <CAPoLzpeQF_xO_4eT2CKfp9cXKWUopssHjCkXd3_b0e8EAn8e_w@mail.gmail.com> (sfid-20110811_123538_365675_131CF586)
Subject: Re: brcmsmac: fifo 0: descriptor error
From: Pedram Navid <pedram.navid@gmail.com>
To: ali@internetdog.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thank you Ali, I apologize, this is my first time reporting a bug
through a mailing list.

Both lines repeat almost every second until I either run ifconfig
wlan0 down or remove the module completely. I have since downgraded to
2.6.39 and am using the wl module and don't seem to have any problems.
I still have the 3.0 Kernel available if anyone would like me to test
further.

On Wed, Aug 10, 2011 at 10:15 PM, Ali Bahar <ali@internetdog.org> wrote:
> Hi Pedram,
>
> you must use a meaningful Subject-line for your email.
> Hopefully, this'll attract the attention of the couple of Broadcom guys
> who are on this list.
>
> Also,
>
>
> On Wed, Aug 10, 2011 at 06:48:45PM -0400, Pedram Navid wrote:
>> Hello,
>>
>> I'd like to report a bug I have not been able to find elsewhere. I am on
>> a fresh Arch install with linux 3.0.1-1, using the brcmsmac module.
>> Initially, the wireless works for a few days. At some point, it will
>> stop, outputing the following error repeatedly:
>>
>> Aug  7 09:55:27 localhost kernel: [  825.796697] ieee80211 phy0: wl0:
>> fifo 0: descriptor error
>> Aug  7 09:55:27 localhost kernel: [  825.796713] ieee80211 phy0: wl0:
>> fatal error, re-initializing
>
> You may wish to note which of these lines repeat. Do both repeat, or
> only the "re-initializing" line? (It may be easier to just paste a few
> lines into your mail.)
>
> later,
> ali
>
>
>> I can rmmod brcmsmac, reboot, shutdown, give it a few days, and start
>> over and it will sometimes work. Other times, it will persist with the
>> fifo errors. Please let me know you need additional log files. I had
>> this problem since 2.6.38 and reinstalled Arch twice, thinking it was
>> something with my setup that was done incorrectly but haven't been
>> able to figure it out. I can't find another case of this error on the
>> internet.
>>
>> #    lspci -vnn | grep 14e4
>> 05:00.0 Network controller [0280]: Broadcom Corporation
>> 802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
>>        Subsystem: Broadcom Corporation Device [14e4:0510]
>>
>>  #  lsmod  | grep brc
>> brcmsmac              594624  0
>> brcmutil                6563  1 brcmsmac
>> mac80211              215605  1 brcmsmac
>> cfg80211              160516  2 brcmsmac,mac80211
>> crc_ccitt               1331  1 brcmsmac
>>
>> Thank you
>> Pedram
>
