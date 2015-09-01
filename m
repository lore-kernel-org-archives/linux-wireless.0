Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:33484 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082AbbIAAQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 20:16:49 -0400
Received: by obcji4 with SMTP id ji4so11422315obc.0
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 17:16:49 -0700 (PDT)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
To: Jes Sorensen <Jes.Sorensen@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
 <55E289A3.6030001@lwfinger.net> <wrfjegik8vqy.fsf@redhat.com>
 <55E39707.60101@lwfinger.net> <wrfjy4gs5ggd.fsf@redhat.com>
 <55E476A0.4080601@lwfinger.net> <wrfjio7v3txe.fsf@redhat.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	johannes@sipsolutions.net
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <55E4EE6F.2010008@lwfinger.net> (sfid-20150901_021653_604875_1FAE31A8)
Date: Mon, 31 Aug 2015 19:16:47 -0500
MIME-Version: 1.0
In-Reply-To: <wrfjio7v3txe.fsf@redhat.com>
Content-Type: multipart/mixed;
 boundary="------------050700010904090003020502"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050700010904090003020502
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 08/31/2015 06:43 PM, Jes Sorensen wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
>> On 08/30/2015 09:39 PM, Jes Sorensen wrote:
>>> Larry Finger <Larry.Finger@lwfinger.net> writes:
>>>> On 08/30/2015 01:41 PM, Jes Sorensen wrote:
>>>>>>> +{USB_DEVICE_AND_INTERFACE_INFO(USB_VENDOR_ID_REALTEK, 0x817e, 0xff,
>>>>>> 0xff, 0xff),
>>>>>>> +	.driver_info = (unsigned long)&rtl8192cu_fops},
>>>>>>
>>>>>> I have tested a device with USB ID 0x0bda (USB_VENDOR_ID_REALTEK):0x817e.
>>>>>
>>>>> Were you happy with the results, or did it cause problems? Ie. did you
>>>>> try on x86 or on PPC32?
>>>>
>>>> As covered in the other mail, it works very well at G rates.
>>>
>>> I see - I am a little confused, it works well on G rates but not on N
>>> rates, or was this due to the AP used?
>>
>> The AP is AC1200. It supports full N rates on other devices.
>
> You only manage to make it work on G rates against this AP? Urgh, I
> don't like that at all.
>
> I thought you reported 30+Mbps performances though?, thats more than you
> get on G.

OK, I get a bit better than the top G rate of 27 Mbps, but the connection 
reports a 54 Mbps raw rate. My Intel 7260 gets RX of 95 and TX of 53 Mbps from 
the same location relative to the AP. For the Intel, the listed raw rate is 300 
Mbps.

>>>>> I don't think any of this is showstopper material for inclusion right
>>>>> now, albeit I do want to address them.
>>>>
>>>> The scheduling while atomic problems do need to be fixed, and I am
>>>> still working on the failure to get a wifi device on PPC.
>>>
>>> It's already fixed :)
>>
>> A full debug=0x3fff showed me one problem on the PPC. I will be
>> testing a patch later today.
>
> Interesting, let me know what you find.

Thanks for the fixes. I'm still getting the sleeping while atomic BUG splat from 
rtl8723a_h2c_cmd+0x48. Today I know that is not a lock dependency issue. I have 
one in VirtualBox that fires and disables further checking, but that driver is 
not loading now.

I have made some progress on the big-endian issues. When the firmware file is 
read from disk, the first byte read must be the first byte written to the 
device. In the slow write N routine, four bytes are picked and written using the 
write32 routine, which does a cpu_to_32() byte swap. As a result, the order of 
bytes to the device is 03, 02, 01, 00! Rather than byte swap twice, I am calling 
the regular writeN routine with each hunk. After a bit of thinking about the 
best blocksize to use, I settled on 64. That reduces the number of full-size 
hunks that are written without unduly increasing the worst-case number of writes 
needed for the remainder.

On PPC, I now get a device registered; however, the scan data are garbled. That 
shouldn't be too difficult to debug, but just in case, I have attached the patch 
for rtl8xxxu_slow_writeN().

Larry




--------------050700010904090003020502
Content-Type: text/x-patch;
 name="fix_big_endian_fw_download.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="fix_big_endian_fw_download.patch"

diff --git a/drivers/net/wireless/rtl8xxxu.c b/drivers/net/wireless/rtl8xxxu.c
index 8773884..80602b8 100644
--- a/drivers/net/wireless/rtl8xxxu.c
+++ b/drivers/net/wireless/rtl8xxxu.c
@@ -1099,17 +1099,18 @@ rtl8xxxu_writeN(struct rtl8xxxu_priv *priv, u16 addr, u8 *buf, u16 len)
 static int
 rtl8xxxu_slow_writeN(struct rtl8xxxu_priv *priv, u16 addr, u8 *buf, u16 len)
 {
-	u32 blocksize = sizeof(u32);
-	u32 *buf4 = (u32 *)buf;
+	u32 blocksize = 64;
 	int i, offset, count, remainder;
 
+	/* This routine does not do any btye swapping on big-endian machines.
+	 * It should be used for writing firmware, and nothing else */
 	count = len / blocksize;
 	remainder = len % blocksize;
 
 	for (i = 0; i < count; i++) {
 		offset = i * blocksize;
-		rtl8xxxu_write32(priv, (REG_FW_START_ADDRESS + offset),
-				 buf4[i]);
+		rtl8xxxu_writeN(priv, (REG_FW_START_ADDRESS + offset),
+				(buf + offset), blocksize);
 	}
 
 	if (remainder) {


--------------050700010904090003020502--
