Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:41442 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759450AbZGHG6N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2009 02:58:13 -0400
Received: by gxk26 with SMTP id 26so2858500gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 07 Jul 2009 23:58:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090707030719.GC7199@hash.localnet>
References: <6c354a1a0906301524m389d49a9sfd812e1ea4740ff5@mail.gmail.com>
	 <6c354a1a0906301550g70fbd9ddkecd09fc0e98dd1ef@mail.gmail.com>
	 <b6c5339f0907020836n6162e8b8k3c1a7a24c335ac41@mail.gmail.com>
	 <6c354a1a0907050513x3a3c91b3vb4b9de7196da1a14@mail.gmail.com>
	 <6c354a1a0907061835g438d65daw38b08b9d55081f43@mail.gmail.com>
	 <20090707030719.GC7199@hash.localnet>
Date: Wed, 8 Jul 2009 02:58:11 -0400
Message-ID: <6c354a1a0907072358u7408d865h5b32c587f63f39d@mail.gmail.com>
Subject: Re: kernel .30 BROKE ATH5K with my AR5212 atheros.
From: Jasin Colegrove <j.wholesalesupply@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 6, 2009 at 11:07 PM, Bob Copeland<me@bobcopeland.com> wrote:
>> Colegrove<j.wholesalesupply@gmail.com> wrote:
>> > Thanks bob for the reply. I did not mean to shout, but someone else
>> > told me that I should make it very clear that I was not subscribed.
>> > But, now I am so it doesn't matter :)
>
> No worries, but whoever said that is wrong as far as vger.kernel.org
> mailing lists go, as everyone just does reply-all.  (Also, top-posting
> is frowned upon.)
>
>> I have found the bad commit.
>
>> $ git bisect good
>> 1e3e6e8fe2f422f75619b1110f78bb638ae905b9 is first bad commit
>> commit 1e3e6e8fe2f422f75619b1110f78bb638ae905b9
>> Author: Nick Kossifidis <mick@madwifi-project.org>
>> Date:   Mon Feb 9 06:15:42 2009 +0200
>>
>>     ath5k: Disable BMISS interrupts
>
> Hmm, so that's a pretty weird commit to end up with.  Can you
> now try whatever your baseline kernel was, with just this patch
> reverted and see if it works for you?

I haven't tried this yet, but I started up gitk and realized that the
last good commit was the one previous to the bad commit. They where
made 3 minutes apart in the ath5k dir. So I am assuming that the
"Disable BMISS interrupts was not actually at fault. It just doesn't
seem logical now that i look at it.
>
> We don't actually do anything with BMISS yet so the only thing it
> could do is slow down your computer.
>
> Another possibility is that something happened between that
> commit and your last good ath5k commit, elsewhere in the tree,
> so a bisect would need to be done over the whole tree instead of
> just the ath5k directory.

So I started another bisect of drivers/net/. Is this the main tree you
where talking about or do you think I need to go further into the main
tree? If so, how far?
>
> A third possibility is the issue comes and goes, or is timing
> related, in which case bisection really isn't useful.

I don't think this is the case, Only because I haven't noticed it to
be intermittent. Either wicd works on reboot of a new kernel or it
doesn't. Any attempts to get it working fail until I restart with a
good commit of the kernel.
>
>> Do you still think it would be wise to file a bug report for this
>> issue. I have yet to try the latest compat-wireless.
>
> Give 2.6.30.1 a shot as it includes a couple of fixes, otherwise
> bugzilla is probably the best bet.

I tried this and this is where the mystery deepens. With .30.1 it
seems that I can connect to my neighbors network using dhcp but I
still can not hook to my own using a static IP. I have not actually
tried conneting with .30.1/dhcp to my own network, but that is the
next step for me if the bisect on drivers/net fails to provide any
stellar results. Once again, downgrading to kernel .29 fixes
everything without changing any of my other settings. I am still 110%
positive this is a kernel module/driver issue. It does make sense, no?
>
> --
> Bob Copeland %% www.bobcopeland.com
>
>

If you have any other bright ideas keep them coming.
