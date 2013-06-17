Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f48.google.com ([209.85.219.48]:44164 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3FQPWB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 11:22:01 -0400
Received: by mail-oa0-f48.google.com with SMTP id f4so3562603oah.21
        for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 08:22:00 -0700 (PDT)
Message-ID: <51BF2996.9060102@lwfinger.net> (sfid-20130617_172342_781511_84BB0C32)
Date: Mon, 17 Jun 2013 10:21:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Tobias Kluge <zielscheibe@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192cu fail to connect with a AP
References: <loom.20130617T154136-827@post.gmane.org>
In-Reply-To: <loom.20130617T154136-827@post.gmane.org>
Content-Type: multipart/mixed;
 boundary="------------070503020805050906000104"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070503020805050906000104
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/17/2013 09:06 AM, Tobias Kluge wrote:
> Hi,
>
> I've recently bought a TP-Link TL-WN8200ND USB WiFi dongle, it uses the
> Realtek 8192cu chipset.
> After several attempts with different kernels (starting with 3.2.6) and
> compat-wireless drivers, I'm still running into the same problem. The device
> can successful scan for networks in reach, but cannot connect to any of
> them, regardless the encryption (tried every mode, including no encryption
> at all).
>
> At the moment I'm using the kernel release 3.10.0-rc6 and the device is
> still not recognized by the "rtl8192cu" driver module without manually
> setting the device ID into the SySFS
>
> "echo "2357 0100" > /sys/bus/usb/drivers/rtl8192cu/new_id"

No one had reported that this device used rtl8192cu, thus it is not in the 
device tables, nor is it in the USB database as shown by the bare entry in your 
lsusb output. Attached is a patch that will add your device to the tables. That 
will be submitted to the maintainer relatively soon.

There were a number of changes to that driver that just appeared in 3.10-rc6. 
These fixed a number of bug reports on the Red Hat bugzilla as shown in the 
commit message for commit 5b8df24. I had built 3.10-rc6 from the mainline git 
tree; however, I had not booted it till now. With it, my Edimax EW-7811Un 
adapter with an RTL8188CUS chip could connect to WEP, WPA1 and WPA2 APs; 
however, when I dug out my Alfa AWUS036NHR with an RTL8188RU chip, it could not 
connect to any of my APs. I now need to check the results for the 
wireless-testing git tree, which I normally use, to see if there is a difference 
in the two trees.

Larry





--------------070503020805050906000104
Content-Type: text/plain; charset=UTF-8;
 name="rtl8192cu_add_deviceid_2357_0100"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="rtl8192cu_add_deviceid_2357_0100"

SW5kZXg6IHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3
aWZpL3J0bDgxOTJjdS9zdy5jCj09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KLS0tIHdpcmVsZXNzLXRlc3Rpbmct
c2F2ZS5vcmlnL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3J0bHdpZmkvcnRsODE5MmN1L3N3LmMK
KysrIHdpcmVsZXNzLXRlc3Rpbmctc2F2ZS9kcml2ZXJzL25ldC93aXJlbGVzcy9ydGx3aWZp
L3J0bDgxOTJjdS9zdy5jCkBAIC0zNTksNiArMzU5LDcgQEAgc3RhdGljIHN0cnVjdCB1c2Jf
ZGV2aWNlX2lkIHJ0bDgxOTJjX3VzYgogCXtSVExfVVNCX0RFVklDRSgweDIwMDEsIDB4MzMw
YSwgcnRsOTJjdV9oYWxfY2ZnKX0sIC8qRC1MaW5rLUFscGhhKi8KIAl7UlRMX1VTQl9ERVZJ
Q0UoMHgyMDE5LCAweGFiMmIsIHJ0bDkyY3VfaGFsX2NmZyl9LCAvKlBsYW5leCAtQWJvY29t
Ki8KIAl7UlRMX1VTQl9ERVZJQ0UoMHgyMGY0LCAweDYyNGQsIHJ0bDkyY3VfaGFsX2NmZyl9
LCAvKlRSRU5ETmV0Ki8KKwl7UlRMX1VTQl9ERVZJQ0UoMHgyMzU3LCAweDAxMDAsIHJ0bDky
Y3VfaGFsX2NmZyl9LCAvKlRQLUxpbmsgV044MjAwTkQqLwogCXtSVExfVVNCX0RFVklDRSgw
eDczOTIsIDB4NzgyMiwgcnRsOTJjdV9oYWxfY2ZnKX0sIC8qRWRpbWF4IC1FZGltYXgqLwog
CXt9CiB9OwoK
--------------070503020805050906000104--
