Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64930 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761419Ab2C3Ui0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Mar 2012 16:38:26 -0400
Received: by iagz16 with SMTP id z16so1443124iag.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Mar 2012 13:38:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1333139642.7679.7.camel@jlt3.sipsolutions.net>
References: <1333105815.3908.11.camel@jlt3.sipsolutions.net>
 <1333105904.3908.13.camel@jlt3.sipsolutions.net> <CAB=NE6XXzwKjFCbV=zi7DaPtpa4aqttB4EMTqaKSzhPMHwJd1A@mail.gmail.com>
 <1333139642.7679.7.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 30 Mar 2012 13:38:06 -0700
Message-ID: <CAB=NE6W0C3v4vBJrXntDEhDLK-AiAH3oGGrkdM4wNk_XvZdQsg@mail.gmail.com> (sfid-20120330_223833_160335_2B2F7C13)
Subject: Re: [PATCH 2/2] compat: explicitly export generated variables
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	lf_driver_backport@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 30, 2012 at 1:34 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2012-03-30 at 13:30 -0700, Luis R. Rodriguez wrote:
>> On Fri, Mar 30, 2012 at 4:11 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > From: Johannes Berg <johannes.berg@intel.com>
>> >
>> > Doing the blanket "export" statement at the beginning
>> > of the generated file confuses the kernel's Makefiles
>> > and causes extreme build slowdowns.
>> >
>> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>> > ---
>>
>> Nice, how did you figure this out BTW!?
>
> Random monkey approach ;-)
>
> I noticed it was slow and saw that it was due to some weird shit from
> the kernel Makefile.lib being executed when it shouldn't be.
>
> Since I have the compat *result* in git, I could easily see the diff
> between the old compat.git/compat-wireless.git and the new versions. And
> then I basically tried to identify the changes that caused this problem,
> my best guess was that it had to be the Makefile so I gradually changed
> that back to the previous version until the problem went away ... and
> then identified which changes were responsible.

Wow, nice find.. so we should be able to make compat-wireless builds
just as fast too there. There config.mk does the same wide export
hackery. Looks like the 3.4 stable releases will have huge
improvements, now to just address 2.6.31 and below for
compat-wireless:

Trying kernel                  2.6.31-02063113-generic  [FAILED]
Trying kernel                  2.6.30-02063010-generic  [FAILED]
Trying kernel                  2.6.29-02062906-generic  [FAILED]
Trying kernel                  2.6.28-02062810-generic  [FAILED]
Trying kernel                    2.6.27-020627-generic  [FAILED]
Trying kernel                    2.6.26-020626-generic  [FAILED]
Trying kernel                    2.6.25-020625-generic  [FAILED]
Trying kernel                    2.6.24-020624-generic  [FAILED]

PS. Please Cc: lf_driver_backport@lists.linux-foundation.org on future patches.

  Luis
