Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f174.google.com ([209.85.218.174]:56401 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093AbZENJ6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 05:58:31 -0400
Received: by bwz22 with SMTP id 22so1173366bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 02:58:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1242292128.10076.38.camel@johannes.local>
References: <1242030669.6930.10.camel@johannes.local>
	 <9b2b86520905120709v4bd00e1eo4da26e6c5f75c4ba@mail.gmail.com>
	 <43e72e890905131445s5583481bgb556a925247368db@mail.gmail.com>
	 <9b2b86520905140202y539f8b93m9669e2c8c7ffbdcd@mail.gmail.com>
	 <1242292128.10076.38.camel@johannes.local>
Date: Thu, 14 May 2009 10:58:30 +0100
Message-ID: <9b2b86520905140258t7c169ec7k254deea5d01b6254@mail.gmail.com>
Subject: Re: [RFT v9] rfkill: rewrite
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <Vivek.Natarajan@atheros.com>,
	Easwar Krishnan <Easwar.Krishnan@atheros.com>,
	Nataraj Sadasivam <Nataraj.Sadasivam@atheros.com>,
	Kathir Ganapthy <Kathir.Ganapthy@atheros.com>,
	Ponmudi Ramachandran <Ponmudi.Ramachandran@atheros.com>,
	Senthilkumar Balasubramanian
	<Senthilkumar.Balasubramanian@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 5/14/09, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2009-05-14 at 10:02 +0100, Alan Jenkins wrote:
>
>> > I think my new 4 patches should address this and it'd be great to hear
>> > your tests as you can reproduce easily. We are able to see something
>> > like this but only after 3 hours of testing. Since it seems you might
>> > be able to reproduce quickly it would help.
>>
>> Glad to be of service :-).
>>
>> I applied your four patches on top of my current tree
>> (wireless-testing+rfkill rewrite), and it fixed the OOPS.
>>
>> As a sanity check, I tried un-applying patch 4/4 (cfg80211: fix race
>> between core hint and driver's custom apply), since that looked like
>> the fix I was interested in.  Un-applying this fix caused the OOPS to
>> reappear.
>
> Very good, thank you! That means I don't have to fix anything in
> rfkill :)

Yep, seems so.  I'm now able to test the rfkill functionality and it
all seems fine.  The new resume code successfully fixes the
hibernation corner-case I brought up.  So I'm happy and you can add my

Tested-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>

You should probably drop my Signed-off-by though, seeing as it no
longer includes the eeepc-laptop resume handler I wrote.

Oh, and don't forget the "whitespace error" flagged by git-apply.
scripts/checkpatch.pl will flag it up as well.   Checkpatch also says
you shouldn't initialize "rfkill_no = 0" because it's a static (and
therefore will default to zero in the absence of an initializer).

Thanks
Alan
