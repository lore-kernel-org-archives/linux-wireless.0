Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:35440 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357AbbGHLGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jul 2015 07:06:14 -0400
MIME-Version: 1.0
In-Reply-To: <559CED4C.1080402@users.sourceforge.net>
References: <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CF8FF.8080600@users.sourceforge.net>
 <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6>
 <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6>
 <5317A59D.4@users.sourceforge.net> <558EB32E.6090003@users.sourceforge.net>
 <558EB4DE.3080406@users.sourceforge.net> <20150707023103.GA22043@kroah.com>
 <559B6FF8.9010704@users.sourceforge.net> <CAH6sp9Nn7LKdqT9E0bykY8jpEc-Ugxn8wby5yLcW+nsx=yG3NQ@mail.gmail.com>
 <559B85CD.6040200@users.sourceforge.net> <CAH6sp9Npqma18pj=ZsxYpCNDCm-AjjXvw61MGKBEKSYvg_LUBg@mail.gmail.com>
 <559BBDD6.7040808@users.sourceforge.net> <CAH6sp9O=NgJXOJzQaaA0o_yae+ae1oJa5Kcqmpo-WWBO_xUW+g@mail.gmail.com>
 <559BFB19.2080700@users.sourceforge.net> <CAGRGNgXTN8AxBNNfie4KvvErOXm3LUyL_QLLWQ6TN_wJgJkD-A@mail.gmail.com>
 <559CCC9D.8050606@users.sourceforge.net> <CAGRGNgWcHxwjx07A45No8vArXR12JGKcfif1Rvi30PQbJs4SGQ@mail.gmail.com>
 <559CED4C.1080402@users.sourceforge.net>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 8 Jul 2015 21:05:53 +1000
Message-ID: <CAGRGNgU1SSUw-97aS0nhFObcMpLPdP3ej9WWNVwN77Fd=ws-bQ@mail.gmail.com> (sfid-20150708_130644_947510_AE5D72F9)
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

On Wed, Jul 8, 2015 at 7:28 PM, SF Markus Elfring
<elfring@users.sourceforge.net> wrote:
>> If it's harmless, then no, but in this case, people are questioning
>> why you're adding it as it adds no value
>
> Some Git software developers care to keep the information complete
> for the author commit.
>
>
>> to anyone and makes it look like you don't know what you're doing.
>
> I specify message field overrides in my update suggestions intentionally.
>
>
>> The issue is that the headers you're adding, From: and Date: are unnecessary.
>
> We have got different opinions about the purpose.

Let me rephrase that: they _should_ be unnecessary.

>> The From: header you add is unnecessary as your email's From: header
>> has the exact same information.
>
> I would like to point out that there is a slight difference in my use case.

Then fix your email client or patch submission process.

>> The reason it's there is because sometimes people forward patches on
>> from other people, e.g. if I were to resend one of your patches,
>> I'd add a From: header to the body of the email so it'd be credited to you.
>
> I am also interested in such an use case.

This happens automatically if you use git-format-patch on a commit you
didn't author. Nobody is adding this manually.

>> The Date: header you add is unnecessary as git-format-patch sets the
>> date header in the email it produces to the author date stored in the commit.
>
> How do you think about my extra patch preparation for the mentioned
> mail forwarding?

It sounds like you're using what could only be described as a
Rube-Goldberg process to send email. Is there truly no way to simplify
that process? (Also, are the servers you send it through re-writing
the original headers?)

You should be sending the patches directly with SMTP using
git-send-email, if you're not, then you're making things overly
complicated for yourself.

>> So if you're sending your patches in emails produced by git-format-patch,
>> there's absolutely no reason to include it.
>
> I disagree here to some degree.
>
> The difference in suggested commit timestamps of a few minutes might look
> negligible for some patches. There are few occasions where the delay between
> a concrete commit and its publishing by an interface like email
> can become days.

I made a commit a month ago, it got rebased today, in fact, I sent
it's metadata in my previous email. When I ran git-format-patch on it,
the timestamp in the headers of the email produced was the date from a
month ago.

If I then sent that email, I believe it'd make it to the list here
with that date intact. If it hadn't, I'd be trying to figure out why
and either fix it or find a different path to get my patch here.

>> They are both almost completely irrelevant for most workflows as people
>> are less interested in when a commit was made and more interested in what
>> release it's in, how it was merged, etc. All of which should be
>> determined without using the timestamp.
>
> How often will it matter who made and published a change first?

If multiple people are submitting identical changes, then the one that
is applied is the one the maintainer sees first, which will most
likely be determined by which one hit their inbox / list first. Nobody
is going to look at timestamps in emails to determine which one will
be applied.

If you're worried about which one of several versions of a patch will
be applied, change the subject to [PATCH v2] ..... instead of [PATCH]
.... for the second version.

>> To be honest, I've only ever used that timestamp for reporting
>> purposes at work, and I'd be surprised if anyone was doing anything
>> other than that with them.
>
> Thanks for your detailed feedback.
>
>
>> How would you feel if someone came in to your place of work
>> and told you to change how you do the job you've been doing for years
>> without a good reason?
>
> You might feel uncomfortable for a moment if you would interpret
> such a suggestion as a personal attack.

I'm not interpreting this as a personal attack.

> I guess that I point only a few technical details out which can change
> the popularity of existing functionality from the Git software.

Git was originally written to manage the Linux kernel. This feature
was probably added by either Linus himself or one of the original
developers who I believe were kernel developers. The patch submission
process has been around for a long time, if this feature isn't used,
it's for a good reason.

Having a feature doesn't mean that it should be used.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
