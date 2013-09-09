Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:59583 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755700Ab3IIXqO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 19:46:14 -0400
Message-ID: <522E5D83.9060103@ilande.co.uk> (sfid-20130910_014617_621306_7048EB35)
Date: Tue, 10 Sep 2013 00:45:07 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Timothy Rundle <tgrundlesr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <522E0573.4000804@ilande.co.uk> <522E1B7D.5010107@lwfinger.net> <522E463E.4040701@ilande.co.uk> <522E5416.4010901@lwfinger.net>
In-Reply-To: <522E5416.4010901@lwfinger.net>
Subject: Re: RTL8192CU continually reconnecting
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/09/13 00:04, Larry Finger wrote:

>> I also tried another experiment which was to change your patch so that
>> instead
>> of logging just the first 100 beacons to dmesg, log every 10th beacon
>> (count %
>> 10) to dmesg instead. This showed that even when the timeouts are
>> occurring
>> against the AP, I'm still seeing a continual stream of beacons from other
>> stations on the network.
>
> Looking at only every 10th one could be systematically missing the ones
> from your AP.

Oh sure - what I was looking to prove was whether it was all beacons 
that weren't getting through, or just the ones from the AP when the 
timeout occurred.

>> This makes me wonder if Oleksij is correct in that the problem is that
>> not all
>> the frames coming from the USB interface are being picked up by the
>> driver.
>> Perhaps not all incoming USB RX buffers are being scanned (causing
>> some queued
>> frames to be lost) or maybe USB transfers can contain more than 1
>> frame and
>> rtlwifi is only catching the first frame within each notified transfer?
>
> None of those suppositions make any sense.

Well I freely admit that I don't have much knowledge of the kernel USB 
layers (only from some old embedded systems years ago), so it was really 
just a case of thinking out loud...

>> To double check whether it was a general ehci-pci problem, I tried
>> plugging in a
>> spare zd1211rw dongle and that worked absolutely fine. So I think
>> that's a
>> reasonable indication that general USB function is okay.
>
> I do not suspect any USB problem unless it is in rtl8192cu.

Okay.

> Could you please run the attached patch? It will only print messages for
> your AP, and print enough to still be getting them when the AP timeout
> occurs.

Done.

dmesg output:
http://www.ilande.co.uk/tmp/rtl8192cu_patch-3-dmesg.txt

wpa_supplicant output:
http://www.ilande.co.uk/tmp/rtl8192cu_patch-3-wpa_supplicant.txt

Now the interesting part was as you can see from the logs, I managed to 
get a reasonably long association to the AP towards the end so I tried 
running dhclient against the wlan1 interface - this was slow, taking 
about 60s to complete, but it did eventually return with an IP address. 
With that in place, I tried pinging 8.8.8.8 and ended up with a very 
poor connection, with the ping exit banner reporting 87% packet loss :(


ATB,

Mark.
