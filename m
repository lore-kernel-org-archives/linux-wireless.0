Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44244 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S936317AbcIRPAO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 18 Sep 2016 11:00:14 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: kvalo@codeaurora.org, devel@driverdev.osuosl.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: Stop log spam from each successful interrupt
References: <1474132155-9330-1-git-send-email-Larry.Finger@lwfinger.net>
        <wrfjbmzmmed0.fsf@redhat.com>
        <a9bcf666-719e-bda8-17bb-212e269ca497@lwfinger.net>
Date: Sun, 18 Sep 2016 11:00:12 -0400
In-Reply-To: <a9bcf666-719e-bda8-17bb-212e269ca497@lwfinger.net> (Larry
        Finger's message of "Sat, 17 Sep 2016 18:06:29 -0500")
Message-ID: <wrfjtwddl0cj.fsf@redhat.com> (sfid-20160918_170018_792139_C787A2C5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:
> On 09/17/2016 03:59 PM, Jes Sorensen wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>> As soon as debugging is turned on, the logs are filled with messages
>>> reporting the interrupt status. As this quantity is usually zero, this
>>> output is not needed. In fact, there will be a report if the status is
>>> not zero, thus the debug line in question could probably be deleted.
>>> Rather than taking that action, I have changed it to only be printed
>>> when the RTL8XXXU_DEBUG_USB bit is set in the debug mask.
>>
>> Wrong flag, please add a RTL8XXXU_DEBUG_INTERRUPT flag instead and use
>> that.
>>
>> Which device do you see this with?
>
> OK. I will change the flag.
>
> I found this with a TP-Link TL-MN8200ND, which has some variant of the
> RTL8188CU chip. It transmits, but I see no evidence that the receiver
> is functioning at all. The same is true for driver rtl8192cu. Only the
> driver from Realtek's web site actually works.

I assume you mean TL-WN8200ND? That device is 'interesting' in the least
positive sense of the word. It seems abandoned by the manufacturer
too. I have one of them but never managed to get it working, not with
any driver under Linux nor Windows.

TP-Link shipped a driver disc with it, but you cannot install that in
any recent version of Windows because the OS ships with it's own driver
for the 8192cu/8188cu series and the device uses the common USB ID. I
have been meaning to see if I could find a box with Vista on it to
install their driver and run a USB trace on it.

> One other problem that I have found is that the debug option on module
> load seems to be ignored. So far, I've had to hard wire the
> flags. Once I find the reason, I'll send a patch for that as well.

That is odd - I use it regularly and haven't had problems with it.

Cheers,
Jes
