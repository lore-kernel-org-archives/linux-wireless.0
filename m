Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:34790 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752808AbYFZScm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jun 2008 14:32:42 -0400
Message-ID: <4863E113.1040609@lwfinger.net> (sfid-20080626_203248_959661_17F3C972)
Date: Thu, 26 Jun 2008 13:33:55 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
CC: Matthew Garrett <mjg@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	herton@mandriva.com.br, linux-wireless@vger.kernel.org,
	flamingice@sourmilk.net, andreamrl@tiscali.it, linville@redhat.com
Subject: Re: [RFC][PATCH] Realtek 8187B wireless support with product id 0x8197/0x8189
References: <779389.39286.qm@web23108.mail.ird.yahoo.com> <48630FE7.7060800@lwfinger.net> <4863D05A.7070801@yahoo.co.uk>
In-Reply-To: <4863D05A.7070801@yahoo.co.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> 
> 
> Larry Finger wrote:
>> Hin-Tak Leung wrote:
>>> --- On Thu, 26/6/08, Matthew Garrett <mjg@redhat.com> wrote:
> <snipped>
>>> E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>>> E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>>> E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>>> E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>>> E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>>> E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>>> E:  Ad=0a(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>>> E:  Ad=0b(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>>> E:  Ad=0c(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
>>
>> My device doesn't show up in /proc, but 
>> /sys/bus/usb/devices/1-5/product shows it to have the same Product 
>> string as yours, with a ProdID of 8187.
> <snipped>
> 
> Is your usbfs mounted? you should have an entry similiar to this in your
> fstab:
> ----------
> none            /proc/bus/usb    usbfs  auto         0 0
> ----------
> and that gives you the /proc/bus/usb/devices entries. Most userland
> usb device drivers (libusb - scanners, ptp digital cameras) need the
> /proc/bus/usb hierachy to work.
> The usb endpoint list is a functional difference between the 8187 and 
> 8187b.
> (it runs to 0c for the 8187b, and does not have a 02 entry which the 
> 8187 uses).

My fstab entry was set "noauto". Once it was mounted, then it shows

T:  Bus=01 Lev=01 Prnt=01 Port=04 Cnt=02 Dev#=  3 Spd=480 MxCh= 0
D:  Ver= 2.00 Cls=00(>ifc ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=0bda ProdID=8187 Rev= 2.00
S:  Manufacturer=Manufacturer_Realtek
S:  Product=RTL8187B_WLAN_Adapter
S:  SerialNumber=00e04c000001
C:* #Ifs= 1 Cfg#= 1 Atr=80 MxPwr=500mA
I:* If#= 0 Alt= 0 #EPs= 9 Cls=ff(vend.) Sub=ff Prot=ff Driver=rtl8187
E:  Ad=83(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=04(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=05(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=06(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=07(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=89(I) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0a(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0b(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms
E:  Ad=0c(O) Atr=02(Bulk) MxPS= 512 Ivl=0ms

Do I understand correctly that it might be better to check for the 
existence of endpoint 02 for an 8187 device? Or would it be better to 
look for endpoint 12 to set it as an 8187B?

Larry

