Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33144 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932236AbcIBRRj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2016 13:17:39 -0400
Received: by mail-oi0-f46.google.com with SMTP id c15so170848750oig.0
        for <linux-wireless@vger.kernel.org>; Fri, 02 Sep 2016 10:17:38 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: Debugging RTL8192CU firmware loading on 3.12 powerpc
To: Simon Wunderlich <sw@simonwunderlich.de>
References: <1586991.4QUcrJhXOm@prime>
 <8cae6bb9-0465-9210-b543-61136836c263@broadcom.com>
 <6578938.N4SWO0a2Ic@bentobox>
Cc: Sven Eckelmann <sven@narfation.org>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org,
        Pannirselvam Kanagaratnam <pannirk@gmail.com>
Message-ID: <14297c9d-3b2f-7cb9-208d-d01b88d74ef3@lwfinger.net> (sfid-20160902_191742_818400_13F4B0B4)
Date: Fri, 2 Sep 2016 12:17:36 -0500
MIME-Version: 1.0
In-Reply-To: <6578938.N4SWO0a2Ic@bentobox>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/02/2016 06:26 AM, Sven Eckelmann wrote:
> On Freitag, 2. September 2016 13:13:20 CEST Arend Van Spriel wrote:
> [...]
>>> Do you have any recommendations where the firmware loading problems could
>>> come from, and where we could start to debug? Any pointers would be
>>> appreciated.
>> Hi Simon,
>>
>> Could it be an endian issue?
>
> Yes, it could be one (at least I've also guessed this - I could still be
> completely wrong). But the problem is now to find a good starting point for
> the debugging effort.
>
> I've only looked at Simon's screen once while he gather USB dumps but didn't
> spot any obvious at that time. There was also the problem that the comparison
> dump looked already a lot different due to some timing differences.
>
> I think Simon can give you later more details (when required).

Simon,

Yes, it is an endian issue. I can see part of the problem, but I do not have a 
fix yet.

The firmware is read in as an array of bytes, thus it is effectively in 
little-endian order. When it is written back to the device in routine 
_rtl92c_fw_block_write(), the data output uses 32-bit writes. Of course, all 
data supplied in all 2- and 4-byte writes is assumed to be in CPU order. As the 
device needs the data to be little-endian, it will be byte swapped on BE 
machines. As a result, the firmware is written out in the wrong byte order. I 
think that this problem should be fixed with:

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c 
b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
index 43fcb25..cd7ae70 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192c/fw_common.c
@@ -74,18 +74,19 @@ static void _rtl92c_fw_block_write(struct ieee80211_hw *hw,
         struct rtl_priv *rtlpriv = rtl_priv(hw);
         u32 blocksize = sizeof(u32);
         u8 *bufferptr = (u8 *)buffer;
-       u32 *pu4byteptr = (u32 *)buffer;
+       __le32 *pu4byteptr = (__le32 *)buffer;
         u32 i, offset, blockcount, remainsize;
+       u32 data;

         blockcount = size / blocksize;
         remainsize = size % blocksize;

         for (i = 0; i < blockcount; i++) {
                 offset = i * blocksize;
+               data = le32_to_cpu(*(pu4byteptr + i));
                 rtl_write_dword(rtlpriv, (FW_8192C_START_ADDRESS + offset),
-                               *(pu4byteptr + i));
+                               data);
         }
-
         if (remainsize) {
                 offset = blockcount * blocksize;
                 bufferptr += offset;

Unfortunately, applying the patch results in a checksum error on my PPC.

I'll let you know what I find.

Larry
