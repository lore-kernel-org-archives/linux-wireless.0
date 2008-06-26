Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from n40.bullet.mail.ukl.yahoo.com ([87.248.110.173]:40319 "HELO
	n40.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751626AbYFZRjw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 13:39:52 -0400
Message-ID: <4863D05A.7070801@yahoo.co.uk> (sfid-20080626_194017_619902_3E5A7CB1)
Date: Thu, 26 Jun 2008 18:22:34 +0100
From: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Matthew Garrett <mjg@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	herton@mandriva.com.br, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, andreamrl@tiscali.it, linville@redhat.com
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product id 0x8197/0x8189
References: <779389.39286.qm@web23108.mail.ird.yahoo.com> <48630FE7.7060800@lwfinger.net>
In-Reply-To: <48630FE7.7060800@lwfinger.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Larry Finger wrote:
> Hin-Tak Leung wrote:
>> --- On Thu, 26/6/08, Matthew Garrett <mjg@redhat.com> wrote:
<snipped>
>> E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=0a(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=0b(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>> E:  Ad=0c(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
> 
> My device doesn't show up in /proc, but /sys/bus/usb/devices/1-5/product 
> shows it to have the same Product string as yours, with a ProdID of 8187.
<snipped>

Is your usbfs mounted? you should have an entry similiar to this in your
fstab:
----------
none            /proc/bus/usb    usbfs  auto         0 0
----------
and that gives you the /proc/bus/usb/devices entries. Most userland
usb device drivers (libusb - scanners, ptp digital cameras) need the
/proc/bus/usb hierachy to work.
The usb endpoint list is a functional difference between the 8187 and 8187b.
(it runs to 0c for the 8187b, and does not have a 02 entry which the 8187 uses).


