Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout0.freenet.de ([195.4.92.90]:44721 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140Ab2EJK6i (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 06:58:38 -0400
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout0.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SSR4u-0004l8-VP
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 12:58:36 +0200
Received: from localhost ([::1]:46260 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SSR4u-0001B0-RW
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 12:58:36 +0200
Received: from [195.4.92.10] (port=45350 helo=0.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SSR2L-0000XG-6S
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 12:55:57 +0200
Received: from [2002:4fde:7a2:2:5054:ff:feb8:40bd] (port=49031 helo=mail.maya.org)
	by 0.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SSR2K-0007t7-Ip
	for linux-wireless@vger.kernel.org; Thu, 10 May 2012 12:55:56 +0200
Message-ID: <4FAB9EAE.9090403@01019freenet.de> (sfid-20120510_125841_671594_8CD09D76)
Date: Thu, 10 May 2012 12:55:42 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Ivo Van Doorn <ivdoorn@gmail.com>
CC: "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [rt2x00-users] [PATCH][RFC/RFT] rt2800: Implement selectable
 support for 802.11w (MFP)
References: <201205100719.q4A7JwVl003140@mail.maya.org> <CAOZOX0VfLrqBwfcqf5qsSnA4EH00-6tmG8te3M-WVAR8NqcFSw@mail.gmail.com>
In-Reply-To: <CAOZOX0VfLrqBwfcqf5qsSnA4EH00-6tmG8te3M-WVAR8NqcFSw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

Ivo Van Doorn schrieb:
> Hi,
> 
> On Thu, May 10, 2012 at 9:19 AM, Andreas Hartmann
> <andihartmann@01019freenet.de> wrote:
>> This patch adds support for 802.11w for rt2800. This is achieved by
>> using the 802.11w implementation in mac80211.
>>
>> To get this working, it is necessary to disable hw encryption of
>> rt2800pci / rt2800usb, because I don't know of any support in hardware
>> for 802.11w and therefore let mac80211 do the whole job.
>>
>> The user can enable 802.11w with the new mod parameter enablemfp.
>> Enabling MFP disables hw encryption.
>>
>> 802.11w is deactivated per default.
>>
>> Tested with rt2860 and rt3572.
>>
>> This is a workaround as long as there isn't hardware support implemented
>> in the driver.
>>
>> Signed-off-by: Andreas Hartmann <andihartmann@01019freenet.de>
>> ---
>> diff -ur compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800lib.c compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800lib.c
>> --- compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800lib.c     2012-04-26 22:10:30.000000000 +0200
>> +++ compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800lib.c  2012-05-09 11:37:48.463278177 +0200
>> @@ -4519,6 +4519,15 @@
>>            IEEE80211_HW_AMPDU_AGGREGATION |
>>            IEEE80211_HW_REPORTS_TX_ACK_STATUS;
>>
>> +       /*
>> +        * Enable support for 802.11w in mac80211. hwencryption must be disabled
>> +        */
>> +       if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags) && rt2x00dev->mfprequested) {
>> +               INFO(rt2x00dev, "802.11w support (MFP) enabled.\n");
>> +               rt2x00dev->hw->flags |=
>> +                       IEEE80211_HW_MFP_CAPABLE;
>> +       }
> 
> Can't the whole patch be simplified into
> 
> if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags)) {
>                INFO(rt2x00dev, "802.11w support (MFP) enabled.\n");
>                rt2x00dev->hw->flags |=
>                        IEEE80211_HW_MFP_CAPABLE;
> }

This would surely be possible, but it wouldn't be possible any more to
run the driver w/o MFP support as long as hw encryption is disabled.

Additionally, I would like to have an additional comment added to
nohwcrypt, which mentions, that activating nohwcrypt enables MFP, like:
"Disable hardware encryption, enable MFP." to let the user know, how to
enable MFP.

> 
> Why need a extra moduleflag when all it does is toggle the nohwcrypto
> module parameter?

Because I wanted to achieve the old behaviour of the driver w/o hw
encryption.
If you think, this isn't necessary, I'm absolutely fine with removing it.


Andreas
