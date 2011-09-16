Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f42.google.com ([209.85.212.42]:42401 "EHLO
	mail-vw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab1IPKnH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 06:43:07 -0400
Received: by vwl1 with SMTP id 1so6804964vwl.1
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 03:43:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110914084234.GA5550@kroah.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
	<CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
	<20110913174444.GG11772@tuxdriver.com>
	<CACna6rwS0dGwSFOiqgAYqHNV=AatnHvHes=YdbwSWdKZu8OYiQ@mail.gmail.com>
	<20110914084234.GA5550@kroah.com>
Date: Fri, 16 Sep 2011 12:43:06 +0200
Message-ID: <CACna6rxi6XTUfR_N-n5ss7hmouaaoyZnmvmtdM-pGEfvdaWmQg@mail.gmail.com> (sfid-20110916_124311_885225_10B99181)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Greg KH <gregkh@suse.de>, linux-wireless@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Francis Moreau <francis.moro@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 14 września 2011 10:42 użytkownik Greg KH <greg@kroah.com> napisał:
> On Tue, Sep 13, 2011 at 10:23:47PM +0200, Rafał Miłecki wrote:
>> W dniu 13 września 2011 19:44 użytkownik John W. Linville
>> <linville@tuxdriver.com> napisał:
>> > On Mon, Sep 12, 2011 at 11:27:20PM +0200, Rafał Miłecki wrote:
>> >
>> >> The problem is that brcmsmac duplicates code present in the bcma
>> >> driver. It doesn't use bcma bus architecture.
>> >>
>> >> The real solution is to add bcma driver support in brcmsmac and ssb
>> >> driver support in brcmfmac. Then you can always use bcma and:
>> >> 1) If b43 will load and detect unsupported PHY, it will release the BCMA's core
>> >> 2) brcmsmac will be loaded to let it support the core
>> >
>> > We are going to have to find a way to get brcmsmac into the
>> > wireless-next tree to make it feasible for the Broadcom guys to get
>> > bcma support into that driver.  Do you agree?
>> >
>> > We could move it under the drivers/net/wireless tree.  Or, maybe I
>> > could negotiate with Greg to keep it under the drivers/staging tree
>> > but to let me manage it under wireless-next.  Or...?  Do you have
>> > any thoughts on this?
>>
>> I'll be posting some bcma patches that will allow brcmsmac being
>> converted to bcma support. Currently we don't export few trivial ops
>> in bcma, that are needed by b43/brcmsmac.
>>
>> Could we ask Greg after that, to merge wireless-next into staging?
>
> No.
>
>> That would provide Broadcom guys all the symbols they need.
>
> Yes, or they can wait for the next merge window as that will make things
> easier for everyone involved, right?
>
>> AFAIK git is clever enough to allow Linux easily merge both: Greg's
>> tree and wireless-next tree. Without conflicts coming from
>> "duplicated" patches.
>
> It is, but I really don't want to be dragging around the wireless-next
> tree in staging-next, just like I doubt John would want to drag
> staging-next into wireless-next.

You're right, it wasn't a good idea.

Arend: I've just sent patches to John giving you symbols needed by LCN
code. If there is something more missing, I didn't notice it yet, feel
free to report. AFAICS you should be able now to convert brcmsmac to
use bcma, if you wish to.

-- 
Rafał
