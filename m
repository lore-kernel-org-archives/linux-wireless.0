Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758Ab1GRHtL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 03:49:11 -0400
Message-ID: <4E23E56C.9000202@redhat.com> (sfid-20110718_094915_662478_B49C4840)
Date: Mon, 18 Jul 2011 09:49:00 +0200
From: Stefan Assmann <sassmann@redhat.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: wireless <linux-wireless@vger.kernel.org>, ali@internetdog.org
Subject: Re: r8712u issue
References: <4E2051F3.20103@redhat.com> <4E205984.5040803@lwfinger.net>
In-Reply-To: <4E205984.5040803@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 15.07.2011 17:15, Larry Finger wrote:
> On 07/15/2011 09:42 AM, Stefan Assmann wrote:
>> Hi Larry,
>>
>> I'm wondering if you're looking into any issues concerning the
>> driver. The problem I'm currently facing is that the driver does not
>> recognize any network disconnects. So whenever the network goes down the
>> driver will still report it's connected and thus doesn't reconnect when
>> the network is up again.
>>
>> Btw I'm using a 0bda:8172 usb adapter with 2.6.39.
>> Thanks for your help!
> 
> I need more details. What distro? How are you controlling the network? If 
> NetworkManager, what version?

The system is a headless debian squeeze with a self build vanilla 2.6.39
kernel. The network is handled by debian scripts I just added the following
to /etc/network/interfaces:
auto wlan0
iface wlan0 inet dhcp
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf

No NM involved.

> When this situation occurs, what is output to the dmesg log?

Sorry, I don't have the output at hand but IIRC basically nothing special
occurred in dmesg. The interface even keeps it's IP although the wireless
was long gone.

> 
> I do not see this situation on my system/device. Whenever the connection is 
> dropped, NM reconnects.
> 
> There are a recent patches that might have an effect. Can you build your own kernel?

Sure, just let me know what to test.

Ccing Ali Bahar to this reply, since he has seen something similar.
Ali, if I can help with testing please let me know. And no rush in case
you're busy with something else atm. I appreciate the help.

  Stefan
