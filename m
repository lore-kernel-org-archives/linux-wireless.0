Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:54887 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab0JVV51 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Oct 2010 17:57:27 -0400
Received: by gxk23 with SMTP id 23so832256gxk.19
        for <linux-wireless@vger.kernel.org>; Fri, 22 Oct 2010 14:57:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4CC2043D.2040909@lwfinger.net>
References: <1287779045-20257-1-git-send-email-zajec5@gmail.com>
	<4CC2043D.2040909@lwfinger.net>
Date: Fri, 22 Oct 2010 23:57:26 +0200
Message-ID: <AANLkTika4wVhH=rGc=qgZozgbe9j-+-zzPkb1KGWLHJC@mail.gmail.com>
Subject: Re: [PATCH] b43: rfkill: use status register based on core revision
 not (PHY's)
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 22 października 2010 23:38 użytkownik Larry Finger
<Larry.Finger@lwfinger.net> napisał:
> On 10/22/2010 03:24 PM, Rafał Miłecki wrote:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> This makes my N-PHY radio at least running (no scanning results so far). The
>> same register is used by wl on this device.
>> ---
>>  drivers/net/wireless/b43/rfkill.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
>> index 78016ae..d2734c9 100644
>> --- a/drivers/net/wireless/b43/rfkill.c
>> +++ b/drivers/net/wireless/b43/rfkill.c
>> @@ -28,7 +28,7 @@
>>  /* Returns TRUE, if the radio is enabled in hardware. */
>>  bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
>>  {
>> -     if (dev->phy.rev >= 3 || dev->phy.type == B43_PHYTYPE_LP) {
>> +     if (dev->dev->id.revision >= 3) {
>>               if (!(b43_read32(dev, B43_MMIO_RADIO_HWENABLED_HI)
>>                     & B43_MMIO_RADIO_HWENABLED_HI_MASK))
>>                       return
>
> As that register is present only when the core revision >= 3, this change should
> not cause a regression. Perhaps this was an error in the RE from the start and
> testing the phy.rev has always been wrong.

Do not blame RE team ;) It was described correctly since "ever", you
can check it in history of:
http://bcm-specs.sipsolutions.net/MMIO

I actually suspect this may be source of self-switching-on-off-radio
issue described in:
"b43legacy-phy3: Radio hardware status changed to XXX" thread.

I already mailed reporter to ask if he still has access to problematic card.

-- 
Rafał
