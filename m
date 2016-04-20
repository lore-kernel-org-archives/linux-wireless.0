Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f169.google.com ([209.85.214.169]:35995 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbcDTQmE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Apr 2016 12:42:04 -0400
Received: by mail-ob0-f169.google.com with SMTP id j9so34926853obd.3
        for <linux-wireless@vger.kernel.org>; Wed, 20 Apr 2016 09:42:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160420160442.GA6803@redhat.com>
References: <1461135572-7468-1-git-send-email-yeohchunyeow@gmail.com>
	<20160420160442.GA6803@redhat.com>
Date: Thu, 21 Apr 2016 00:42:03 +0800
Message-ID: <CAEFj985x_YRNL2SLttrxNboq39dD0oHGVcB3CLr3xGNDut=36w@mail.gmail.com> (sfid-20160420_184209_227561_FB1F79BA)
Subject: Re: [PATCH] rt2800usb: enable MFP if hw crypt is disabled
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Noted. Patch v2 sent.

----
Chun-Yeow

On Thu, Apr 21, 2016 at 12:04 AM, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Wed, Apr 20, 2016 at 02:59:32PM +0800, Chun-Yeow Yeoh wrote:
>> If rt2800usb is loaded with nohwcrypt=1, mac80211 takes
>> care of the crypto with software encryption/decryption
>> and thus, MFP can be used.
>>
>> Tested for secured mesh using ath9k_htc and ath9k.
>>
>> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>> ---
>>  drivers/net/wireless/ralink/rt2x00/rt2800usb.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
>> index 4b0bb6b..84ea329 100644
>> --- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
>> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
>> @@ -48,6 +48,7 @@ MODULE_PARM_DESC(nohwcrypt, "Disable hardware encryption.");
>>
>>  static bool rt2800usb_hwcrypt_disabled(struct rt2x00_dev *rt2x00dev)
>>  {
>> +     ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
>>       return modparam_nohwcrypt;
>
> You set MFP feature regardless if actually hwcrypt is disabled or not.
> Beside this should not be done in function which is intended to test
> if hw crypto is disabled. Please set the future in place where other
> hw->flags are set.
>
> Thanks
> Stanislaw
