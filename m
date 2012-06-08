Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:55837 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625Ab2FHQyZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 12:54:25 -0400
Received: by qcro28 with SMTP id o28so942891qcr.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 09:54:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339173704.5748.19.camel@jlt3.sipsolutions.net>
References: <CAHsu+b_wQOuhbBkx25CZ2cai5VVos7zK3s=EiPBy_+OnXWiWaA@mail.gmail.com>
	<1339014959.4523.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b-ByqBaci9W-oS3OPEK3LdRcuGphtQPOTQ02hPWNpWgQw@mail.gmail.com>
	<1339053364.4517.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b9UjkF6VM_YjJkHVDQzrZqsWqmG-XJKFNeSCdWGbdEngw@mail.gmail.com>
	<20120607180325.7752b3c0@milhouse>
	<1339094215.4630.7.camel@jlt3.sipsolutions.net>
	<1339102567.4630.8.camel@jlt3.sipsolutions.net>
	<4FD11B47.10002@lwfinger.net>
	<CAHsu+b9=4i1oSni1onKAKqH4FZ26nye=7GifnnJO-6c5gCaWpQ@mail.gmail.com>
	<1339136879.5832.1.camel@jlt3.sipsolutions.net>
	<1339137689.5832.2.camel@jlt3.sipsolutions.net>
	<CAHsu+b9uyohfFG46R7QHht6tD3MVUzk4_LJeXp+CC2bRv=NihA@mail.gmail.com>
	<1339167160.4901.0.camel@jlt3.sipsolutions.net>
	<CAHsu+b-p1aTUG8L=5SCNB8Gqzwsm7_VA53Qf-ENPHmM5Z5C8hg@mail.gmail.com>
	<1339168452.5748.0.camel@jlt3.sipsolutions.net>
	<1339168600.5748.2.camel@jlt3.sipsolutions.net>
	<CAHsu+b_Dp-A_kC-MSofJko3hr4dYxreYQ7rrq7wzsJXVoY_5yw@mail.gmail.com>
	<4FD21C6B.5000402@lwfinger.net>
	<1339170182.5748.7.camel@jlt3.sipsolutions.net>
	<1339170287.5748.8.camel@jlt3.sipsolutions.net>
	<1339170510.5748.9.camel@jlt3.sipsolutions.net>
	<1339170742.5748.10.camel@jlt3.sipsolutions.net>
	<CAHsu+b8ZGPN3iQNGH1mdzMO6kH+F1n+qZ5cT4KMcx8bh_BP1qg@mail.gmail.com>
	<1339171159.5748.11.camel@jlt3.sipsolutions.net>
	<CAHsu+b9EgAfq6_G8xqRzf0qHkmyQnvs7j=g4wWcSVJXstAz4mw@mail.gmail.com>
	<1339171694.5748.12.camel@jlt3.sipsolutions.net>
	<CAHsu+b-fZQ0auLAd_8rqaoNfLF-2UghRrB7S7qgu1RrqesbW4Q@mail.gmail.com>
	<1339173704.5748.19.camel@jlt3.sipsolutions.net>
Date: Fri, 8 Jun 2012 18:54:24 +0200
Message-ID: <CAHsu+b_J5CsTdbGn=epwx3A+zJ6Nw8rmuVRjZEwMMsaeGOycpQ@mail.gmail.com> (sfid-20120608_185429_399795_44A2607B)
Subject: Re: chip id 4318 regression: WARN_ON_ONCE(sdata->vif.hw_queue[i] >= n_queues))
From: Andre Heider <a.heider@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	=?ISO-8859-1?Q?Michael_B=FCsch?= <m@bues.ch>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 8, 2012 at 6:41 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-06-08 at 18:16 +0200, Andre Heider wrote:
>
>> >> [   17.597307] wlan0: authenticate with d8:5d:4c:9c:31:14
>> >> [   17.638399] wlan0: send auth to d8:5d:4c:9c:31:14 (try 1/3)
>> >> [   17.851085] wlan0: send auth to d8:5d:4c:9c:31:14 (try 2/3)
>> >> [   18.063086] wlan0: send auth to d8:5d:4c:9c:31:14 (try 3/3)
>> >> [   18.275081] wlan0: authentication with d8:5d:4c:9c:31:14 timed out
>> >>
>> >> Tried it 3 times, always times out.
>
> I missed one a use of queue_mapping, try this:
>
> http://p.sipsolutions.net/cc1fc9799ad3c015.txt

Unfortunately still the authentication timeout.

And trace-cmd, hmm. There're no debian packages for it (at least for
powerpc), ubuntu only has x86 and x86_64, I don't have a compiler on
the wii, my powerpc crosscompiler doesn't have a libc and if I find a
solution I can only blind-script a trace via rc.local because without
wlan there's no way to interact :)
But I'll think of something...
