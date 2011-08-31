Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:35060 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab1HaS64 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Aug 2011 14:58:56 -0400
Received: by qyk34 with SMTP id 34so724228qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Aug 2011 11:58:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110831183305.GA11296@suse.de>
References: <20110707002034.GA17885@broadcom.com> <20110824222801.GA5280@broadcom.com>
 <CACna6rwG6qNpaOu4QeOvs0L3LVETRt9w5=Ec-L2NJ5gXOAM=nw@mail.gmail.com>
 <20110827143513.GN3775@shale.localdomain> <20110827145003.GA9405@suse.de>
 <CACna6ryfZoahr1FPbZ_syBFhWnfRprEs=95y=piCGXXm_Cu+LQ@mail.gmail.com>
 <20110827152144.GA10126@suse.de> <20110830014257.GI15771@broadcom.com>
 <20110830181452.GA24769@suse.de> <CAB=NE6WpuHdW000qdx4M1w21U8LjKYOX4nhc4kjjiZWwZpop6Q@mail.gmail.com>
 <20110831183305.GA11296@suse.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 31 Aug 2011 11:58:35 -0700
Message-ID: <CAB=NE6V2Exbj3kKuxuYq_iyJ+yh=5bV-2dsJczU+GmRjtr2yQg@mail.gmail.com> (sfid-20110831_205859_606570_8315F40B)
Subject: Re: [PATCH v2] Move brcm80211 to mainline
To: Greg KH <gregkh@suse.de>
Cc: Henry Ptasinski <henryp@broadcom.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 31, 2011 at 11:33 AM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Aug 31, 2011 at 10:55:45AM -0700, Luis R. Rodriguez wrote:
>> On Tue, Aug 30, 2011 at 11:14 AM, Greg KH <gregkh@suse.de> wrote:
>> > On Mon, Aug 29, 2011 at 06:42:57PM -0700, Henry Ptasinski wrote:
>> >> The brcmsmac driver has architectural alignment with our drivers for other
>> >> operating systems, and we intend to to enhance and maintain this driver in
>> >> parallel with drivers for other operating systems.  Maintaining alignment
>> >> between our Linux driver and drivers for other operating systems allows us to
>> >> leverage feature and chip support across all platforms.
>> >
>> > Just curious, if you really are going to try to do this, how are you
>> > going to handle the issue when others change the in-kernel driver in
>> > ways that you are not going to be allowed to make to your "internal"
>> > copy of the driver?
>>
>> What do you mean by this?
>
>  - Infrastructure changes that do not match up with how other operating
>   systems handle things.

Agreed -- they gotta learn to deal with this. IBM's lesson learnt: You
cannot control Linux, only influence it.

>  - support for new features

Ditto.

>  - support for older devices

Ditto. But common sense helps here -- just enable the community
through proper support on b43, IMHO.

>  - license incompatibilities (i.e. new files under GPL-only license
>  - etc.

Agreed.

But -- I will note the typical concern that vendors *should* have is
not that the main driver code will differ from their internal code,
what is of real critical value is to ensure the software that deals
with hardware code doesn't change much to allow us to rapidly add
support for newer chipsets and also take bug fixes back. For Atheros
we've learned to deal with the fact that the only thing we can
possibly try to keep as very similar to our other drivers is what used
to be called the "HAL", and since that is open now I call it "hardware
code", and its in the ath9k_hw module. Mind you -- I still think FOSS
development even helps lead with better architectural designs here, so
if you compare our ath9k_hw with whatever we us with other drivers I
think you'll be pleased with what we've done.

Just my 0.02 CRC.

>> > Also, how are you going to handle any GPL-only changes that happen to
>> > the code as well?
>>
>> For the broadcom drivers this may be hard if people want to move GPLv2
>> b43 code to a permissively licensed driver... but ...
>>
>> > Do you have some process in place to ensure that all
>> > contributions will have the proper copyright releases on it to allow you
>> > to make the same changes to your internal versions?
>>
>> To be clear *new* code going in to a permissively licensed driver
>> follows the Developer's Certificate of Origin which does state the
>> contributor follows the file's license.
>
> For an existing file, yes.

:D

> But for new files, or for copying code from another driver (GPL only)
> into this one (dual licensed), that's different, right?

Yes :)

> You need to be very careful about this, that's all.

Agreed. I think we all stand to win if we do this properly, doing this
properly will help not only share with internal drivers but also the
BSD community and as can be seen with recent efforts by Adrian Chadd
on FreeBSD -- this helps tremendously the community. In the end what
this is proving is internal driver development sucks balls and
collaborative developments are the only real way to sustain support in
the long run for hardware. If we all work together and use common
sense I think we can figure this out.

>> The issues with a large GPLv2 code from b43 and the fact that the
>> other driver is permissively licensed makes this a bit more
>> complicated though, but that is only a reflection of not addressing
>> supporting old hardware. Ouch.
>
> Yes, this is going to be tricky :)

:)

> That is what I am worried about, but I know the lawyers and developers
> at Broadcom have already considered this, but they haven't told us how
> they are going to handle it, which is what I'm curious about.

I really don't expect them to say anything but I'm more curious about
how to address enabling the community with legacy hardware support.
That seems to me the bigger issue.

> Then there the issue that some companies want to keep their internal
> copies in a non-dual licensed codebase, to handle the license of the
> other operating systems they are working with.

To be clear, Broadcom copied Atheros' practice of using a completely
permissively licensed driver under the ISC license, which removes the
ambiguity from the Dual license. The trick to resolving the "other
operating systems" problem is to realize that the "other OSes" do not
*require* you to use *proprietary* licenses, and that *you can* use
permissive licenses as well. This is a whole can of worms in itself
but -- if done properly, I believe architecturally in the long run we
won't have to deal with shit "internal" drivers or license
incompatibilities. In the end I suspect that nice features like RCU,
and Minstrel HT support for example though, will keep innovation on
the edge on Linux though ;)

> Hopefully Broadcom isn't
> going to do this, but others have in the past (SGI with xfs, Intel with
> the ACPI core, etc.)

Good luck to them too :) I hope they copy best practices well.

  Luis
