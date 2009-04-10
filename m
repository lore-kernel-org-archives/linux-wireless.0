Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:32266 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbZDJRtD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Apr 2009 13:49:03 -0400
MIME-Version: 1.0
In-Reply-To: <69e28c910904100953uc0c0811i6ea8dee19a956951@mail.gmail.com>
References: <15d0b9b20904100916u3ff85ff5gd7a989120b7c048f@mail.gmail.com>
	 <69e28c910904100953uc0c0811i6ea8dee19a956951@mail.gmail.com>
Date: Fri, 10 Apr 2009 19:49:01 +0200
Message-ID: <15d0b9b20904101049h1020f9d7yec3242e3c7cbc06b@mail.gmail.com> (sfid-20090410_194909_030097_0232F405)
Subject: Re: Additional USB identifier for otus driver [WN111v2]
From: Daniele Napolitano <dnax88@gmail.com>
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	akpm@linux-foundation.org, gregkh@suse.de
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/4/10 G=C3=A1bor Stefanik <netrolller.3d@gmail.com>:
> On Fri, Apr 10, 2009 at 6:16 PM, Daniele Napolitano <dnax88@gmail.com=
> wrote:
>> This is a patch for Otus driver [Atheros 9k series] that provide
>> support for WN111v2 USB 802.11n
>> adapter.
>>
>> Otus sources tree: OAL/Otus/Linux
>>
>> --- zdusb.h.orig =C2=A0 =C2=A0 =C2=A0 =C2=A02009-04-10 17:48:17.6204=
23000 +0200
>> +++ zdusb.h =C2=A0 =C2=A0 2009-04-10 17:54:41.356419568 +0200
>> @@ -26,5 +26,9 @@
>>
>>
>> =C2=A0#define VENDOR_DLINK =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
0x07D1 =C2=A0//Dlink
>>
>> =C2=A0#define PRODUCT_DWA160A =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x3C10
>>
>> +
>> +#define VENDOR_NETGEAR =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0846 =C2=
=A0//NetGear
>> +#define PRODUCT_WNDA3100 =C2=A0 =C2=A0 =C2=A0 =C2=A00x9010
>> +#define PRODUCT_WN111v2 =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x9001
>>
>>
>> =C2=A0#endif
>>
>>
>> --- zdusb.c.orig =C2=A0 =C2=A0 =C2=A0 =C2=A02009-04-10 17:48:17.6204=
23000 +0200
>> +++ zdusb.c =C2=A0 =C2=A0 2009-04-10 17:53:15.316421516 +0200
>> @@ -36,7 +36,8 @@
>> =C2=A0static struct usb_device_id zd1221_ids [] =3D {
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ USB_DEVICE(VENDOR_ATHR, PRODUCT_AR9170)=
 },
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 { USB_DEVICE(VENDOR_DLINK, PRODUCT_DWA16=
0A) },
>>
>> - =C2=A0 =C2=A0 =C2=A0 { USB_DEVICE(0x0846, 0x9010) },
>>
>> + =C2=A0 =C2=A0 =C2=A0 { USB_DEVICE(VENDOR_NETGEAR, PRODUCT_WNDA3100=
) },
>> + =C2=A0 =C2=A0 =C2=A0 { USB_DEVICE(VENDOR_NETGEAR, PRODUCT_WN111v2)=
 },
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0{ } =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 /* Terminating entry */
>>
>> =C2=A0};
>>
>>
>>
>>
>> --
>> Daniele "DnaX" Napolitano
>> https://launchpad.net/~dnax88
>> http://dnax.netsons.org/
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wire=
less" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
>>
>
> Need the same for ar9170.

Already present. Look at main.c at line 52 of ar9170 tree.

--=20
Daniele "DnaX" Napolitano
https://launchpad.net/~dnax88
http://dnax.netsons.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
