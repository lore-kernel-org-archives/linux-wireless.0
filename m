Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:22082 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758974AbZKFPX7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 10:23:59 -0500
Received: by fg-out-1718.google.com with SMTP id e12so310178fga.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 07:24:04 -0800 (PST)
Message-ID: <4AF43F8D.6090303@lwfinger.net>
Date: Fri, 06 Nov 2009 09:23:57 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: Carlo Parata <carlo_parata@hotmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Wifi led does not work on Acer Aspire One D250 (ath5k
 	driver)
References: <loom.20091106T135746-452@post.gmane.org> <b6c5339f0911060716n538268f6w1300e3400e0bd2c8@mail.gmail.com>
In-Reply-To: <b6c5339f0911060716n538268f6w1300e3400e0bd2c8@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/06/2009 09:16 AM, Bob Copeland wrote:
> On Fri, Nov 6, 2009 at 8:00 AM, Carlo Parata <carlo_parata@hotmail.com> wrote:
>> With this patch, a Acer Aspire One D250 can turn on the wifi led. The array of
>> compatible devices in ath5k driver now includes the hardware present in this
>> computer, as well as the led pin and polarity.
>>
>> --- ../led.c    2009-11-06 06:16:39.000000000 +0100
>> +++ ./drivers/net/wireless/ath/ath5k/led.c      2009-11-06 12:37:44.000000000 +0100
>> @@ -73,6 +73,8 @@
>>        { ATH_SDEVICE(PCI_VENDOR_ID_HP, 0x0137b), ATH_LED(3, 1) },
>>        /* IBM-specific AR5212 (all others) */
>>        { PCI_VDEVICE(ATHEROS, PCI_DEVICE_ID_ATHEROS_AR5212_IBM), ATH_LED(0, 0) },
>> +        /* Acer Aspire One D250 AR5007EG */
>> +       { PCI_VDEVICE(ATHEROS, 0x001c), ATH_LED(3, 1) },
> 
> No, this should be based on the subdevice instead
> (there are lots of ath:001c with different LED settings).
> 
> Also, please add your email to the appropriate stanza.

It is more than just your E-mail address. Please see
Documents/SubmittingPatches.
