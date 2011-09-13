Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f52.google.com ([209.85.215.52]:46078 "EHLO
	mail-ew0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab1IMUXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 16:23:51 -0400
Received: by ewy28 with SMTP id 28so669415ewy.11
        for <linux-wireless@vger.kernel.org>; Tue, 13 Sep 2011 13:23:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20110913174444.GG11772@tuxdriver.com>
References: <CAC9WiBj0A54_R3NszGBEhzMAiZzL0NBmickE88avp0NDGHyjpg@mail.gmail.com>
	<CACna6rwQ60viPGssWzBzgtVGBq1xu+AOxb0fqfRq4NaJFcmP=w@mail.gmail.com>
	<20110913174444.GG11772@tuxdriver.com>
Date: Tue, 13 Sep 2011 22:23:47 +0200
Message-ID: <CACna6rwS0dGwSFOiqgAYqHNV=AatnHvHes=YdbwSWdKZu8OYiQ@mail.gmail.com> (sfid-20110913_222354_439423_CD7EE0DD)
Subject: Re: About the patch: "staging: brcm80211: only enable brcmsmac if
 bcma is not set"
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Greg KH <greg@kroah.com>, Greg KH <gregkh@suse.de>
Cc: Francis Moreau <francis.moro@gmail.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

W dniu 13 września 2011 19:44 użytkownik John W. Linville
<linville@tuxdriver.com> napisał:
> On Mon, Sep 12, 2011 at 11:27:20PM +0200, Rafał Miłecki wrote:
>
>> The problem is that brcmsmac duplicates code present in the bcma
>> driver. It doesn't use bcma bus architecture.
>>
>> The real solution is to add bcma driver support in brcmsmac and ssb
>> driver support in brcmfmac. Then you can always use bcma and:
>> 1) If b43 will load and detect unsupported PHY, it will release the BCMA's core
>> 2) brcmsmac will be loaded to let it support the core
>
> We are going to have to find a way to get brcmsmac into the
> wireless-next tree to make it feasible for the Broadcom guys to get
> bcma support into that driver.  Do you agree?
>
> We could move it under the drivers/net/wireless tree.  Or, maybe I
> could negotiate with Greg to keep it under the drivers/staging tree
> but to let me manage it under wireless-next.  Or...?  Do you have
> any thoughts on this?

I'll be posting some bcma patches that will allow brcmsmac being
converted to bcma support. Currently we don't export few trivial ops
in bcma, that are needed by b43/brcmsmac.

Could we ask Greg after that, to merge wireless-next into staging?
That would provide Broadcom guys all the symbols they need.

AFAIK git is clever enough to allow Linux easily merge both: Greg's
tree and wireless-next tree. Without conflicts coming from
"duplicated" patches.

-- 
Rafał
