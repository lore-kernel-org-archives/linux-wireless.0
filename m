Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:4599 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758792Ab2EJOrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 10:47:14 -0400
Message-ID: <4FABD4EB.4070003@gmail.com> (sfid-20120510_164719_962500_86299305)
Date: Thu, 10 May 2012 16:47:07 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Andreas Hartmann <andihartmann@01019freenet.de>
CC: Ivo Van Doorn <ivdoorn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [rt2x00-users] [PATCH][RFC/RFT] rt2800: Implement selectable
 support for 802.11w (MFP)
References: <201205100719.q4A7JwVl003140@mail.maya.org> <CAOZOX0VfLrqBwfcqf5qsSnA4EH00-6tmG8te3M-WVAR8NqcFSw@mail.gmail.com> <4FAB9EAE.9090403@01019freenet.de> <CAOZOX0Vax7HTsND=vi+c6vamtvWaWW9omWu1CM-=vWsrAf4fgQ@mail.gmail.com> <4FABCECC.30709@01019freenet.de>
In-Reply-To: <4FABCECC.30709@01019freenet.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/12 16:21, Andreas Hartmann wrote:
> Hi Ivo,
> 
> Ivo Van Doorn wrote:
>> Hi,
>>
>> On Thu, May 10, 2012 at 12:55 PM, Andreas Hartmann
>> <andihartmann@01019freenet.de> wrote:
>>> Hello!
>>>
>>> Ivo Van Doorn schrieb:
>>>> Hi,
>>>>
>>>> On Thu, May 10, 2012 at 9:19 AM, Andreas Hartmann
>>>> <andihartmann@01019freenet.de> wrote:
>>>>> This patch adds support for 802.11w for rt2800. This is achieved by
>>>>> using the 802.11w implementation in mac80211.
>>>>>
>>>>> To get this working, it is necessary to disable hw encryption of
>>>>> rt2800pci / rt2800usb, because I don't know of any support in hardware
>>>>> for 802.11w and therefore let mac80211 do the whole job.
>>>>>
>>>>> The user can enable 802.11w with the new mod parameter enablemfp.
>>>>> Enabling MFP disables hw encryption.
>>>>>
>>>>> 802.11w is deactivated per default.
>>>>>
>>>>> Tested with rt2860 and rt3572.
>>>>>
>>>>> This is a workaround as long as there isn't hardware support implemented
>>>>> in the driver.
>>>>>
>>>>> Signed-off-by: Andreas Hartmann <andihartmann@01019freenet.de>
>>>>> ---
>>>>> diff -ur compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800lib.c compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800lib.c
>>>>> --- compat-wireless-2012-04-26.orig/drivers/net/wireless/rt2x00/rt2800lib.c     2012-04-26 22:10:30.000000000 +0200
>>>>> +++ compat-wireless-2012-04-26/drivers/net/wireless/rt2x00/rt2800lib.c  2012-05-09 11:37:48.463278177 +0200
>>>>> @@ -4519,6 +4519,15 @@
>>>>>            IEEE80211_HW_AMPDU_AGGREGATION |
>>>>>            IEEE80211_HW_REPORTS_TX_ACK_STATUS;
>>>>>
>>>>> +       /*
>>>>> +        * Enable support for 802.11w in mac80211. hwencryption must be disabled
>>>>> +        */
>>>>> +       if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags) && rt2x00dev->mfprequested) {
>>>>> +               INFO(rt2x00dev, "802.11w support (MFP) enabled.\n");
>>>>> +               rt2x00dev->hw->flags |=
>>>>> +                       IEEE80211_HW_MFP_CAPABLE;
>>>>> +       }
>>>>
>>>> Can't the whole patch be simplified into
>>>>
>>>> if (!test_bit(CAPABILITY_HW_CRYPTO, &rt2x00dev->cap_flags)) {
>>>>                INFO(rt2x00dev, "802.11w support (MFP) enabled.\n");
>>>>                rt2x00dev->hw->flags |=
>>>>                        IEEE80211_HW_MFP_CAPABLE;
>>>> }
>>>
>>> This would surely be possible, but it wouldn't be possible any more to
>>> run the driver w/o MFP support as long as hw encryption is disabled.
>>>
>>> Additionally, I would like to have an additional comment added to
>>> nohwcrypt, which mentions, that activating nohwcrypt enables MFP, like:
>>> "Disable hardware encryption, enable MFP." to let the user know, how to
>>> enable MFP.
>>
>> I am wondering what the usecase would be for having an option to disable MFP?
>> Isn't that a feature which technically should be enabled by default and in the
>> userspace you have the configuration to use it or not?
> 
> It's the same idea as behind the nohwcrypt switch. If there are problems
> with the feature in a special case, you have the possibility to disable it.
> My understanding of nohwcrypt is to have a fallback mode, which I didn't
> want to touch. That's all.
> 

The difference here is that nohwcrypt has no userspace choice to use it,
MFP does have that. Therefore I do not believe there is a need to also
be able to enable/disable it at the module level.

---
Gertjan
