Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624Ab3EHO3j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 10:29:39 -0400
Message-ID: <1368023384.1664.10.camel@dcbw.foobar.com> (sfid-20130508_162943_193800_71DDF316)
Subject: Re: Wifi signal level differences
From: Dan Williams <dcbw@redhat.com>
To: nick@nhthomas.freeserve.co.uk
Cc: linux-wireless@vger.kernel.org
Date: Wed, 08 May 2013 09:29:44 -0500
In-Reply-To: <7566504.38231368021104217.JavaMail.www@wwinf3714>
References: <7566504.38231368021104217.JavaMail.www@wwinf3714>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-05-08 at 15:51 +0200, nick@nhthomas.freeserve.co.uk wrote:
> Hi,
> 
> I have an Atheros ath6kl_usb based wifi dongle.
> I am using it with an embedded project.
> 
> The driver code can be built for either X86 or sh4 hardware - so I can also use the same USB wifi dongle on my Fedora 12 Linux PC or plugged in to the embedded device.
> It's working fine in both situations.
> 
> But, I notice that the signal level reported in /proc/net/wireless is slightly different between the two units.
> Note, I am using the same physical Atheros wifi dongle, and moving it from one device to the other to this test.
> 
> I notice that when using the X86 PC I see a signal level of -61, which is marginally better than the -66 I see in the embedded device.
> 
> I know that this isn't an exact science - but using a short USB extension lead I can orientate the wifi dongle to be in the same place and orientation when plugged in to either device.
> So, I would expect the wifi signal strength to be reported the same !?
> 
> I know there are many differences between my Fedora 12 PC, and the embedded STLinux project - not least that the driver is compiled using different compilers.
> 
> But, I was wondering what else could explain the difference in signal levels between the two?
> 
> Also, which part of the driver code is responsible for reading/calculating the signal level value?

What kernel versions is each system running?  The kernel's mac80211
stack is what calculates the actual dBm/RSSI value based on information
given from the dongle firmware.  And the calculations may change in
different kernel versions.  Second make sure you compare the firmware
versions that you have on the two systems to see if they are different;
it's also possible that different firmware versions calculate signal
strength differently.

In the end though, the difference between -61 and -66 isn't worth
worrying about, since in the same location without moving the signal
level can change by that much from one second to the next.

Dan

