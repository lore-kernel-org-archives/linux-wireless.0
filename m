Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53566 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab1LVGGm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Dec 2011 01:06:42 -0500
MIME-Version: 1.0
In-Reply-To: <1324516857.4755.2.camel@wwguy-ubuntu>
References: <1324332059-11630-1-git-send-email-wey-yi.w.guy@intel.com>
	<20111221161953.GB11842@tuxdriver.com>
	<1324482300.13074.295.camel@wwguy-huron>
	<20111221195821.GF11842@tuxdriver.com>
	<1324516857.4755.2.camel@wwguy-ubuntu>
Date: Thu, 22 Dec 2011 08:06:41 +0200
Message-ID: <CANUX_P2Ny7YWsYhVTHDRN03yqSdjiHvafC2utsOwdOZd1GqA3Q@mail.gmail.com> (sfid-20111222_070657_448020_1348BB23)
Subject: Re: [PATCH 3.2] iwlagn: fix (remove) use of PAGE_SIZE
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Berg, Johannes" <johannes.berg@intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> > > > From: Johannes Berg <johannes.berg@intel.com>
>> > > >
>> > > > The ICT code erroneously uses PAGE_SIZE. The bug
>> > > > is that PAGE_SIZE isn't necessarily 4096, so on
>> > > > such platforms this code will not work correctly
>> > > > as we'll try to attempt to read an index in the
>> > > > table that the device never wrote, it always has
>> > > > 4096-byte pages.
>> > > >
>> > > > Additionally, the manual alignment code here is
>> > > > unnecessary -- Documentation/DMA-API-HOWTO.txt
>> > > > states:
>> > > >   The cpu return address and the DMA bus master address are both
>> > > >   guaranteed to be aligned to the smallest PAGE_SIZE order which
>> > > >   is greater than or equal to the requested size.  This invariant
>> > > >   exists (for example) to guarantee that if you allocate a chunk
>> > > >   which is smaller than or equal to 64 kilobytes, the extent of the
>> > > >   buffer you receive will not cross a 64K boundary.
>> > > >
>> > > > Just use appropriate new constants and get rid of
>> > > > the alignment code.
>> > > >
>> > > > Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> > > > Cc: stable@vger.kernel.org
>> > > > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> > > > Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
>> > >
>> > > This seems like a big patch.  It is a bit late in the release cycle
>> > > to rewrite all the DMA allocation code. :-)
>> > >
>> > > What platforms does this affect?  Are there actual users involved?
>> >
>> > I understand the patch is bigger than the regular patch should be
>> > generated for stable kernel. Johannes can explain better, but he is on
>> > vacation. as what I understood, he work with community user who
>> > encounter issue and root cause it is PAGE SIZE cause the problem.
>> >
>> > Thanks
>> > Wey
>>
>> Unless someone screams, I'd be a lot more comfortable saving this
>> for 3.3.
> unless Johannes has objection, I am ok for 3.3, it is not something
> people will encounter everyday on common platform..
>

Please note that this patch has two parts: one does the real stuff
(very small), and the other removes unneeded DAM alignment code (big
part).
I guess it can wait to 3.3 and the small part will then be posted to stable.
