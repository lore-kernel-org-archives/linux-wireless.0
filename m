Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:48082 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab3BFUDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 15:03:12 -0500
MIME-Version: 1.0
In-Reply-To: <5112A972.3060109@lwfinger.net>
References: <51045387.2040607@gmail.com>
	<5112A972.3060109@lwfinger.net>
Date: Wed, 6 Feb 2013 21:03:10 +0100
Message-ID: <CAOAX8-np_cY85=qL4TQCS9_d3tvggZTww7Maq1RWcasJsQxngw@mail.gmail.com> (sfid-20130206_210405_255470_1700A4F1)
Subject: Re: bugreport upstream: 0bda:819a RTL8188CUS WLAN doesn't work out of
 the box
From: Thomas Rosenkranz <tom.rosary@googlemail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-usb@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry for aksing back.
1. You mean I should get the kernel clean of the realtek driver first
to prevent a crash during patching? Cause unplugging is no option for
a onboard device.
2. I have no idea what to do with the patching file and couldn't find
any good instructions with google. "man patch" doesn't make me smarter
at all


2013/2/6 Larry Finger <Larry.Finger@lwfinger.net>:
> On 01/26/2013 04:07 PM, Xose Vazquez Perez wrote:
>>
>> Thomas Rosenkranz wrote:
>>
>>> 0bda:819a RTL8188CUS WLAN doesn't work out of the box in downstream
>>> and upstreamkernel
>>> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1102179
>>
>>
>> This should go to <linux-wireless@vger.kernel.org>
>>
>> Try:
>> # modprobe rtl8192cu
>> # echo "0bda 819a" > /sys/bus/usb/drivers/rtl8192cu/new_id
>> # dmesg (see output)
>
>
> Please install the attached patch, and retry the above method. I fixed the
> probe function to get rid of the oops. If the device is really foreign, the
> process that writes new_id will not finish until the device is unplugged;
> however, the rest of the system is chugging along.
>
> If 0bda:819a works with rtl8192cu, let me know, and I'll update the USB
> device table.
>
> Larry
>
