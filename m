Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpout4.wanadoo.co.uk ([80.12.242.68]:27457 "EHLO
	smtpout.wanadoo.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933252Ab3CTRDJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Mar 2013 13:03:09 -0400
Date: Wed, 20 Mar 2013 18:03:07 +0100 (CET)
From: nick@nhthomas.freeserve.co.uk
Reply-To: nick@nhthomas.freeserve.co.uk
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: linux-wireless@vger.kernel.org
Message-ID: <18571064.59631363798987681.JavaMail.www@wwinf3703> (sfid-20130320_180320_243036_40E6C2DF)
In-Reply-To: <24720158.53141363795611541.JavaMail.www@wwinf3703>
Subject: Re: ath6kl_usb - ping problems when compiled for sh4.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Here is another example, taken from Wireshark.
It's an ARP response, effectively saying IP address 192.168.0.107 is at 00:03:7f:20:50:59

This is a message coming out of the wifi adaptor, and the above numbers are the IP address, and MAC address of the wifi device.

7f 20 50 59 00 24 00 03 7f 20 50 59 08 06 00 01
08 00 06 04 00 02 00 03 7f 20 50 59 c0 a8 00 07
20 cf 30 94 83 7b c0 a8 00 65

What we see here is the Destination MAC address is 7f:20:50:59:00:24 (first 6 bytes).
But that's wrong. It should be 20:cf:30:94:83:7b .

The other parts look right though:
00:03:7f:20:50:59 is the MAC of the wifi device.
c0 a8 00 65 is 192.168.0.101 which is the IP address of the destination.
c0 a8 00 07 is the IP address of the wifi adaptor itself.

So, where in the code is the first 6 bytes generated ?


Regards

Nick
