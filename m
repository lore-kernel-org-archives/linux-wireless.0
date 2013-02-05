Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f50.google.com ([209.85.219.50]:37913 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756737Ab3BEVye (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 16:54:34 -0500
Received: by mail-oa0-f50.google.com with SMTP id l20so770306oag.23
        for <linux-wireless@vger.kernel.org>; Tue, 05 Feb 2013 13:54:33 -0800 (PST)
Message-ID: <51117F98.3040900@lwfinger.net> (sfid-20130205_225444_855481_9910617E)
Date: Tue, 05 Feb 2013 15:54:32 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: Thomas Rosenkranz <tom.rosary@googlemail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: FW: 0bda:819a RTL8188CUS WLAN doesn't work out of the box in
 downstream and upstreamkernel
References: <51102B22.20702@gmail.com> <CAOAX8-k-Nbx4Om8fkEHRW2jmZCxKpsMY6oEZMAvdEQpXWn9Mdw@mail.gmail.com> <511163BA.7060902@gmail.com> <51116A33.9070207@lwfinger.net> <51117994.1060506@gmail.com>
In-Reply-To: <51117994.1060506@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2013 03:28 PM, Xose Vazquez Perez wrote:
> On 02/05/2013 09:23 PM, Larry Finger wrote:
>
>> What difference does it make what chip it has? It is obviously some flavor of RTL8188CU/RTL8192CU that is different enough that it does not work with the kernel version of rtl8192cu. A few months ago,
>> I ran across a new B-CUT RTL8188CE that took new programming for rtl8192ce, and I suspect this device also has the B-CUT chip.
>>
>> The crash on unloading is a known fault of the vendor driver. It happens with devices that work OK with the standard rtl8192cu. I have no desire to find out what causes the crash.
>
> We were trying to know, loading the
> _realtek_ driver, the chip of the device.
>
> *Because*, as Thomas said before, doing:
> # echo "0bda 819a" > /sys/bus/usb/drivers/rtl8192cu/new_id
> with the rtl8192cu _kernel driver_
> He got a _panic of the system_ .
>
> This is a severe bug in rtlwifi.

Yes, but not a bug for the devices that it is supposed to support! No one ever 
says that their driver will support *future* devices! As I said earlier, there 
are newer versions of the RTL8188C chip that requires different programming, 
which may be the cause of the problem. On the other hand, the chip change did 
not cause a crash in rtl8192ce. I just didn't work very well. As I have no such 
device, I cannot test any changes; therefore, I will not make them. If you want 
to write patches that let that device work with the kernel driver, I will be 
happy to review them.

Larry

