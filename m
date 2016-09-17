Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:33993 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754719AbcIQXGc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Sep 2016 19:06:32 -0400
Received: by mail-oi0-f42.google.com with SMTP id a62so17382804oib.1
        for <linux-wireless@vger.kernel.org>; Sat, 17 Sep 2016 16:06:32 -0700 (PDT)
Subject: Re: [PATCH] rtl8xxxu: Stop log spam from each successful interrupt
To: Jes Sorensen <Jes.Sorensen@redhat.com>
References: <1474132155-9330-1-git-send-email-Larry.Finger@lwfinger.net>
 <wrfjbmzmmed0.fsf@redhat.com>
Cc: kvalo@codeaurora.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <a9bcf666-719e-bda8-17bb-212e269ca497@lwfinger.net> (sfid-20160918_010636_437790_7E2A2EF6)
Date: Sat, 17 Sep 2016 18:06:29 -0500
MIME-Version: 1.0
In-Reply-To: <wrfjbmzmmed0.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/17/2016 03:59 PM, Jes Sorensen wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>> As soon as debugging is turned on, the logs are filled with messages
>> reporting the interrupt status. As this quantity is usually zero, this
>> output is not needed. In fact, there will be a report if the status is
>> not zero, thus the debug line in question could probably be deleted.
>> Rather than taking that action, I have changed it to only be printed
>> when the RTL8XXXU_DEBUG_USB bit is set in the debug mask.
>
> Wrong flag, please add a RTL8XXXU_DEBUG_INTERRUPT flag instead and use
> that.
>
> Which device do you see this with?

OK. I will change the flag.

I found this with a TP-Link TL-MN8200ND, which has some variant of the RTL8188CU 
chip. It transmits, but I see no evidence that the receiver is functioning at 
all. The same is true for driver rtl8192cu. Only the driver from Realtek's web 
site actually works.

One other problem that I have found is that the debug option on module load 
seems to be ignored. So far, I've had to hard wire the flags. Once I find the 
reason, I'll send a patch for that as well.

Larry
