Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:62595 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756293AbZHFRJA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2009 13:09:00 -0400
Received: by gxk9 with SMTP id 9so1286848gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 06 Aug 2009 10:09:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1249555578.24439.38.camel@ct>
References: <4A7A0952.5020307@redfish-solutions.com> <1249555578.24439.38.camel@ct>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 6 Aug 2009 10:08:36 -0700
Message-ID: <43e72e890908061008k20895df8k636a921db20e83cd@mail.gmail.com>
Subject: Re: Best (ath9k) miniPCI card for testing overall AP functionality
To: Pavel Roskin <proski@gnu.org>
Cc: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>,
	linux-wireless@vger.kernel.org, Pen Li <Pen.Li@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 6, 2009 at 3:46 AM, Pavel Roskin<proski@gnu.org> wrote:
> On Wed, 2009-08-05 at 15:36 -0700, Philip A. Prindeville wrote:
>> I'm trying to get Astlinux ready for the 0.7 release, but we've been
>> hamstrung in testing because of issues with the ath5k drivers on our
>> test platform...  so I've been considering getting different hardware
>> for testing.  We've not been able to shake-down our transition from
>> wireless-tools to iw, or from hostapd 0.6.8 to 0.6.9.
>>
>> I'm guessing that the ath9k tends to be further along in functionality,
>> and more stable, than the ath5k?
>
> I think it's true for AP functionality.  In any case, there is not much
> code shared between ath5k and ath9k, so if you have a driver specific
> problem with ath5k, ath9k is unlikely to have the same problem.
>
>> If that's the case, one of our partners that gives discounted pricing on
>> F/OSS development hardware has the following NICs:
>>
>> Ubiquiti SR71-A  = Atheros AR9160 with DFS SUPPORT
>> Ubiquiti SR71-12 = Atheros AR9220 with DFS SUPPORT
>> Ubiquiti SR71-15 = Atheros AR9220 with DFS SUPPORT
>>
>>
>>
>> I'm looking for b/g or n hardware, and the more power, the better.
>>
>> The 'A' doesn't seem to work with x86 based systems, as far as I can tell.
>
> I have an AR9160 based miniPCI card, and it's working fine on a x86_64
> based system.  I don't think I tested it with a 32-bit kernel, but I
> don't expect any problems.

If you have to go miniPCI I'd recommend to go AR9220 as it seems to
provide the AR9280 MAC and newer radios. I only recently found out
that some companies were selling AR9280 on miniPCI. A few months ago I
would have said I didn't know of any single device out there.
Fortunately that's changed.

The AR9220 you see on the external cards page is for the one card some
user did report as working and verified it did use AR9280 and a new
radio.

I suspect the ubt cards also work, if you see it working just add it
to the list.

> I think the Ubiquiti page for the card would have a warning it it was
> true, but I don't see any warning here:
> http://www.ubnt.com/products/sr71a.php
>
> By the way, AR9160 is supported by MadWifi, unlike AR9280.  MadWifi is
> not actively developed, but if you need another reference point, you'll
> have it.

Does MadWifi support 11n? :)

>> The '12' is b/g/n, 27dBm and uses MMCX connectors, and is type III-A format.
>>
>> The '15' is a/n only, also 27dBm and uses MMCX connectors... also type
>> III-A format.
>>
>> I'm leaning towards a '12', but they're not cheap.
>>
>> According to:
>>
>> http://linuxwireless.org/en/users/Drivers/ath9k
>>
>> and:
>>
>> http://linuxwireless.org/en/users/Drivers/ath9k/products/external
>>
>> none of the above cards are supported...  but that assumes that the Wiki
>> is up to date.
>
> I don't thing the term "up to date" really could apply here.  It would
> apply it there was a definite list and it was easy to update the wiki
> from it.

Hey its easy to update, its a wiki. What else can you ask for?

> In fact, the list is only updated when somebody has such device and
> makes sure that it works.  As you said, Ubiquiti card are not cheap.

Well some history on this list:

We actually slapped onto the wiki a list of known devices in the
market from our marketing team member, Sayuri. Sayuri then also helped
to update the list if she noted errors or there or if there were any
updates.

So a large chunk of that list actually does come from some official
list. The AP list also came from some internal documenation sheet, but
I don't think we follow that as carefully.  I believe the list we have
now on the wiki is pretty well complete, but may require some new
revising based on our new stuff out there, AR9285, and so on.

>>   Also the AR9220 isn't shown on the list of supported
>> chipsets.

Yes it is, the mikrotik card is listed there, its AR9220.

> The Atheros people here should know better, but I think either AR9220
> implies AR9280 or vice versa.

Yeah, and a newer radio too.

> MikroTik RouterBoard R52N has a chip marked AR9220, yet we know that
> it's supported.

ACK.

>> Can anyone confirm or deny that it's unsupported?
>
> I'm quite sure that all those cards are supported, but I cannot
> guarantee anything.

If we at least get one user to indicate its working, then it should work.

  Luis
