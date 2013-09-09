Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p15195424.pureserver.info ([82.165.34.74]:43034 "EHLO
	p15195424.pureserver.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab3IIWGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 18:06:48 -0400
Message-ID: <522E463E.4040701@ilande.co.uk> (sfid-20130910_000652_320428_4C5CEED1)
Date: Mon, 09 Sep 2013 23:05:50 +0100
From: Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Timothy Rundle <tgrundlesr@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <CALa3VXYo1yTuDr22M7AUcp0WLQszzdMSJczRgmD57uPd_68vWQ@mail.gmail.com> <522D054B.5060205@lwfinger.net> <522DD856.7050309@ilande.co.uk> <522DE1BE.6070904@lwfinger.net> <522DE8CA.9010008@ilande.co.uk> <522DFF83.6000605@lwfinger.net> <522E0573.4000804@ilande.co.uk> <522E1B7D.5010107@lwfinger.net>
In-Reply-To: <522E1B7D.5010107@lwfinger.net>
Subject: Re: RTL8192CU continually reconnecting
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/09/13 20:03, Larry Finger wrote:

> There were no secrets in that dump, but it did reveal a major clue.
>
> A response from your system for your AP was:
>
> mode 2, state 0, is_beacon 0, is_probe_resp 1, length 147
>
> For the number of beacons to be updated, the state has to be 2 or 3. My
> system has scan_ssid=1 in the wpa_supplicant configuration file. When
> the scan finishes, then a value of 2 is set into the mode variable.
>
> The attached updated patch should set the correct mode even if scanning
> is not enabled.

Aha! This patch is definitely a step in the right direction - with this 
applied, wpa_supplicant now associates immediately with the AP without 
the initial delay :)

However... I'm still seeing the same 
"rtlwifi:rtl_watchdog_wq_callback():<0-0> AP off, try to reconnect now" 
message appearing in dmesg after every 10s or so. I've uploaded the 
updated dmesg output to 
http://www.ilande.co.uk/tmp/rtl8192cu_patch-2-dmesg.txt for you to take 
a look at.

I also tried another experiment which was to change your patch so that 
instead of logging just the first 100 beacons to dmesg, log every 10th 
beacon (count % 10) to dmesg instead. This showed that even when the 
timeouts are occurring against the AP, I'm still seeing a continual 
stream of beacons from other stations on the network.

This makes me wonder if Oleksij is correct in that the problem is that 
not all the frames coming from the USB interface are being picked up by 
the driver. Perhaps not all incoming USB RX buffers are being scanned 
(causing some queued frames to be lost) or maybe USB transfers can 
contain more than 1 frame and rtlwifi is only catching the first frame 
within each notified transfer?

To double check whether it was a general ehci-pci problem, I tried 
plugging in a spare zd1211rw dongle and that worked absolutely fine. So 
I think that's a reasonable indication that general USB function is okay.


ATB,

Mark.
