Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.tqs.de ([62.157.136.17]:30438 "EHLO mail.tqs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755873Ab2CBI6R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 03:58:17 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: AW: [PATCH] Staging: rtl8712: Change double device ID back to original value
Date: Fri, 2 Mar 2012 09:57:23 +0100
Message-ID: <47F3F98010FF784EBEE6526EAAB078D10FD7EF81@tq-mailsrv.tq-net.de> (sfid-20120302_095821_223866_0F39C7CA)
In-Reply-To: <4F4BA81D.1070800@lwfinger.net>
References: <20120227102857.21246.43090.stgit@localhost.localdomain> <4F4BA81D.1070800@lwfinger.net>
From: "Martin Krause" <Martin.Krause@tqs.de>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: <linux-wireless@vger.kernel.org>,
	"John Linville" <linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,

Larry Finger wrote on :
> On 02/27/2012 04:29 AM, Martin Krause wrote:
>> In the rtl8712 staging driver the 0bda:8172 usb device id exists two
>> times. It seems that this was an error when integrating the original
>> Realtek driver into the kernel. This patch changes the double device
>> id back to the value used in the last Realtek driver
>> (rtl8712_8188_8191_8192SU_usb_linux_v2.6.6.0.20110401).
>> 
>> Signed-off-by: Martin Krause<martin.krause@tqs.de>
>> ---
>> I tested this patch on a powerpc board (p2020 based) with a WIFIHU
>> Radicom wireless module with a RTL8191SU chip on it (usb device id
>> 0bda:8192). 
>> 
>>   drivers/staging/rtl8712/usb_intf.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Your patch does two things. One is the deletion of a
> duplicate USB ID, and the
> other is the addition of a new one. I would prefer that any
> patch do one or the
> other, but not both. Note, there are two sets of duplicate
> IDs in the table for
> the driver - the one you note in the RTL8191SU section, and another
> for 0bda:8174 in the section that covers the RTL8192SU.
> 
> I think you are deleting the wrong 0bda:8172 with this patch.
> The 0bda code is
> for Realtek, thus the one in the Asus section is the one to remove.
> 
> Does your chip really have an RTL8191SU label? The USB
> database says that ID
> 0bda:8192 is for the RTL8192SU. I would like to correct the database
> if it is wrong.

>From the Radicom engineers I get the following answer:

"Our WiFiHU is using RTL8191SU and USB ID is 0BDA/8192".

It seems the USB database is wrong, so. And this might be also an
explanation why this USB ID is used in the rtl8192su staging driver
(file drivers\staging\rtl8192u\r8192U_core.c). I compiled this driver
during my tests with the embedded Radicum WIFIHU wireless module
and it accepts this USB id (0bda:8192), but it did not work with
it. In contrast, the rtl8712 staging driver is working with this
moudule if adding this USB ID to it (as done in my patch).

Regards,
Martin

>> diff --git a/drivers/staging/rtl8712/usb_intf.c
> b/drivers/staging/rtl8712/usb_intf.c
>> index 9bade18..bb247ce 100644
>> --- a/drivers/staging/rtl8712/usb_intf.c
>> +++ b/drivers/staging/rtl8712/usb_intf.c
>> @@ -104,7 +104,7 @@ static struct usb_device_id rtl871x_usb_id_tbl[]
>> = { 
>> 
>>   /* RTL8191SU */
>>   	/* Realtek */
>> -	{USB_DEVICE(0x0BDA, 0x8172)},
>> +	{USB_DEVICE(0x0BDA, 0x8192)},
>>   	/* Amigo */
>>   	{USB_DEVICE(0x0EB0, 0x9061)},
>>   	/* ASUS/EKB */
