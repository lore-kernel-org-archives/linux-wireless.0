Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:35140 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933949AbbGHHgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 03:36:49 -0400
MIME-Version: 1.0
In-Reply-To: <559CCC9D.8050606@users.sourceforge.net>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net>
 <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <558EB32E.6090003@users.sourceforge.net>
 <558EB4DE.3080406@users.sourceforge.net> <20150707023103.GA22043@kroah.com>
 <559B6FF8.9010704@users.sourceforge.net> <CAH6sp9Nn7LKdqT9E0bykY8jpEc-Ugxn8wby5yLcW+nsx=yG3NQ@mail.gmail.com>
 <559B85CD.6040200@users.sourceforge.net> <CAH6sp9Npqma18pj=ZsxYpCNDCm-AjjXvw61MGKBEKSYvg_LUBg@mail.gmail.com>
 <559BBDD6.7040808@users.sourceforge.net> <CAH6sp9O=NgJXOJzQaaA0o_yae+ae1oJa5Kcqmpo-WWBO_xUW+g@mail.gmail.com>
 <559BFB19.2080700@users.sourceforge.net> <CAGRGNgXTN8AxBNNfie4KvvErOXm3LUyL_QLLWQ6TN_wJgJkD-A@mail.gmail.com>
 <559CCC9D.8050606@users.sourceforge.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 8 Jul 2015 17:36:29 +1000
Message-ID: <CAGRGNgWcHxwjx07A45No8vArXR12JGKcfif1Rvi30PQbJs4SGQ@mail.gmail.com> (sfid-20150708_095814_092076_46801B74)
Subject: Re: Clarification for the use of additional fields in the message body
To: SF Markus Elfring <elfring@users.sourceforge.net>
Cc: Frans Klaver <fransklaver@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Chris Park <chris.park@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Julia Lawall <julia.lawall@lip6.fr>,
	kernel-janitors@vger.kernel.org,
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Markus,

On Wed, Jul 8, 2015 at 5:09 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
>> There's a file in the documentation directory of the kernel
>> tree describing submitting patches and email client setup.
>> Read them both,
>
> I read this information several times.
>
>
>> do what they say without anything extra.
>
> Do you see any special consequences if a bit of "extra" functionality
> is already provided by the Git software for a while?

If it's harmless, then no, but in this case, people are questioning
why you're adding it as it adds no value to anyone and makes it look
like you don't know what you're doing.

>> Your attempts to "improve" on the system are unnecessary
>
> It seems that my approach does not need improvements for the current
> command "git am".
> Would a few extensions for the available documentation help to clarify
> the situation?

The issue is that the headers you're adding, From: and Date: are unnecessary.

The From: header you add is unnecessary as your email's From: header
has the exact same information. The reason it's there is because
sometimes people forward patches on from other people, e.g. if I were
to resend one of your patches, I'd add a From: header to the body of
the email so it'd be credited to you.

The Date: header you add is unnecessary as git-format-patch sets the
date header in the email it produces to the author date stored in the
commit. (see below) So if you're sending your patches in emails
produced by git-format-patch, there's absolutely no reason to include
it.

> Do items like "commit mail address" and "commit timestamp"
> belong together for the data structure "author" by design
> in this content management system?

The information stored for a commit is:

= = = = = =

tree 09496defc9eb793c665a7b80aa22f24c7bd5f204
parent 63c07589832bfe5ec49f2523ddb0e94a20af0f31
author Julian Calaby <julian.calaby@gmail.com> 1435196810 +1000
committer Julian Calaby <julian.calaby@gmail.com> 1436322540 +1000

= = = = = =

Then the subject and commit message.

The numbers after the email addresses are the timestamps. They are
both almost completely irrelevant for most workflows as people are
less interested in when a commit was made and more interested in what
release it's in, how it was merged, etc. All of which should be
determined without using the timestamp.

To be honest, I've only ever used that timestamp for reporting
purposes at work, and I'd be surprised if anyone was doing anything
other than that with them.

In short, nobody cares, and nobody's going to be upset if the actual
time you authored a patch is different to the time recorded upstream.

>> and annoying people.
>
> I understand that various update suggestions can be surprising.
> It is also usual that corresponding acceptance might take
> a bit longer than what some contributors would prefer.

How would you feel if someone came in to your place of work and told
you to change how you do the job you've been doing for years without a
good reason?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
