Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:58231 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZIYVQc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 17:16:32 -0400
Received: by iwn8 with SMTP id 8so1829627iwn.33
        for <linux-wireless@vger.kernel.org>; Fri, 25 Sep 2009 14:16:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890909251406o64417544w2fd836f820eae80e@mail.gmail.com>
References: <loom.20090925T193922-290@post.gmane.org> <200909252005.23746.mb@bu3sch.de>
	<loom.20090925T222532-791@post.gmane.org> <4ABD2ECE.50501@gmail.com>
	<43e72e890909251406o64417544w2fd836f820eae80e@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 25 Sep 2009 14:16:16 -0700
Message-ID: <43e72e890909251416g59a24d8as90f7a4d649c06914@mail.gmail.com>
Subject: Re: Porting AR6K to use cfg80211
To: Dave <kilroyd@googlemail.com>
Cc: Matthew Ryan <rudicus@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 25, 2009 at 2:06 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Fri, Sep 25, 2009 at 1:57 PM, Dave <kilroyd@googlemail.com> wrote:
>> Matthew Ryan wrote:
>>> Michael Buesch <mb@...> writes:
>>>> On Friday 25 September 2009 19:40:52 Matthew Ryan wrote:
>>>>> I was curious if I could get a few expert opinions on if its possible to port
>>>>> this driver to use mac80211, and how difficult/ what pitfalls there may be.
>>>> The device is fullmac, so it does not require mac80211.
>>>> I guess however, ar6k can be ported to use cfg80211.
>>>>
>>>
>>> Do you know of any examples in the source tree which are fullmac, but utilize
>>> cfg80211 that I could use as a base to get started?
>>
>> There are a few fullmac drivers in wireless-testing that use cfg80211. I
>> don't think these are in the recently released 2.6.31, but are queued
>> for 2.6.32.
>>
>> iwmc3200wifi and rndis_wlan are furthest along. orinoco is in the
>> process of conversion (it uses cfg80211, but relies on the wext
>> compatibility code for a large portion of functionality).
>
> Additionally you can poke at the HTC / HIF stuff I'm doing for ar9271:
>
> http://wireless.kernel.org/en/users/Drivers/ath9k_htc
>
> Granted I've removed all credit distribution stuff as ar9271 doesn't
> use it, but it still may be easier to use that then what I had seen on
> ar6k for HTC.

Let me clarify a little more.

ath9k_htc is a module which will use ath_htc and ath_hif_usb.
ath9k_htc delcares hardware support for the 802.11n Atheros 9k family
for devices which use HTC. The ar9271 usb device gets probed by
ath_hif_usb. ath9k_htc is being designed as the mac80211 driver for
ar9271 but it may be possible to just share the same ath9k_htc for all
SoftMAC Atheros 11n HTC devices.

Now, ar6k is FullMAC so an ath9k_htc per se is not needed but I'd
expect you'd just need to implement a ar6k.c which uses cfg80211 and
adds support for the ar6k hw famiy. You'd need to implement an
ath_hif_sdio.c to handle the SDIO transport and this would be the
module probing the ar6k devices over sdio. Now, sure, I don't expect
any PCI/USB ar6k devices but still, this is the architectural approach
I'd like to see.

  Luis
