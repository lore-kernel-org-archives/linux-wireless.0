Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:25224 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbZBBXs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Feb 2009 18:48:58 -0500
Received: by fg-out-1718.google.com with SMTP id 16so752122fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 02 Feb 2009 15:48:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <35040.82.152.223.193.1233590184.squirrel@www.phantomjinx.co.uk>
References: <33918.62.172.74.16.1233233185.squirrel@www.phantomjinx.co.uk>
	 <3ace41890901290952o6412c8dco660a36ffc2fcf485@mail.gmail.com>
	 <41405.91.85.186.216.1233323986.squirrel@www.phantomjinx.co.uk>
	 <3ace41890901301117na1a81e8g90b25d6e8ff469ae@mail.gmail.com>
	 <35757.91.85.186.216.1233353086.squirrel@www.phantomjinx.co.uk>
	 <3ace41890902011709h285b4e9bi40da145f841533ea@mail.gmail.com>
	 <37630.82.152.223.193.1233582663.squirrel@www.phantomjinx.co.uk>
	 <49871083.5040309@lwfinger.net>
	 <35040.82.152.223.193.1233590184.squirrel@www.phantomjinx.co.uk>
Date: Mon, 2 Feb 2009 23:48:55 +0000
Message-ID: <3ace41890902021548o39b5f02veacc0bd650e92c7@mail.gmail.com> (sfid-20090203_004902_697870_ECB20800)
Subject: Re: rtl8187 wireless issues
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 2, 2009 at 3:56 PM, P.G. Richardson
<p.g.richardson@phantomjinx.co.uk> wrote:

>> I just looked back at the patch log for wireless-testing. To get the
>> best code for the RTL8187, you should have compat-wireless from no
>> earlier than Jan. 28.
>>
>> Larry
>
> Thanks for letting me know. Compat-wireless dated 30/01/2009.

The "stuck-at-1Mb" problem happens a few times recently, for different
reasons - I suggest doing an "iwconfig rate <something>" and/or
"iwconfig rate <something> auto" to see if it works better. (the
latter means if it can take auto, so it is different from the former).
I say use the latest compat-wireless tarball whenever you need to
re-compile. If a problem persists, then ask. Note that if you let it
idle for a long time the rate change machanism will down-regulate.
(i.e. you should check *while* you are trying to push a lot of traffic
through).

About dates in wireless-testing log - I had an impression (I could be
wrong) that the dates are sometimes git-format-patch/posting dates and
not dates at which John commits to wireless-testing? (i.e. the dates
shown could be a lot earlier than time of commit, or time of commit is
not shown by the dates associated with a patch - I thought this makes
sense since the date of a patch should be the first time it appears in
the "system", not the first time it gets in-coporated in a particular
tree, and patches can go between trees and should *not* pick up date
change on the way).
