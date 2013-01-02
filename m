Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41336 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788Ab3ABQAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 11:00:12 -0500
Date: Wed, 2 Jan 2013 10:47:25 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Hin-Tak Leung <htl10@users.sourceforge.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@canonical.com>,
	linux-wireless@vger.kernel.org, kay@redhat.com
Subject: Re: rtl8187 WARN slowpath on suspend with 3.6.11
Message-ID: <20130102154724.GA2198@tuxdriver.com> (sfid-20130102_170018_434346_4B0A941B)
References: <50E23C19.7050008@lwfinger.net>
 <1357138947.38782.YahooMailClassic@web172305.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1357138947.38782.YahooMailClassic@web172305.mail.ir2.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 02, 2013 at 03:02:27PM +0000, Hin-Tak Leung wrote:
> --- On Tue, 1/1/13, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> 
> > On 12/31/2012 06:16 PM, Hin-Tak Leung
> > wrote:
> > > Hi,
> > >
> > > Does either Larry or Herton see the sort of behavior
> > (https://bugzilla.redhat.com/show_bug.cgi?id=891019) on
> > suspend? John, is there anything changed between 3.6.9 and
> > 3.6.11 which would cause this?
> > >
> > > Other than a genuine kernel regression, it is possible
> > that it might be fedora specific - I just went from F17 to
> > F18. F18 seems to have an systemd integrated udevd which
> > might behaves differently from the older udevd's... or
> > general funniness with F18 (I noticed another bug https://bugzilla.redhat.com/show_bug.cgi?id=891018 but
> > that might be unrelated).
> > >
> > > Anyway, other than whole sale downgrade I think I can
> > try booting 3.6.9 (which suspended cleanly under F17) and
> > see whether it is a F18-specific problem.
> > 
> > Hin-Tak,
> > 
> > My system has never done a suspend/resume with any wireless
> > card, thus I cannot 
> > check your result. The test with 3.6.9 is a good idea.
> > 
> > Sorry,
> > 
> > Larry
> 
> Hi Larry,
> 
> Thanks for the reply. I have since rebooted to 3.6.9-2.fc17.x86_64, 3.6.10-2.fc17.x86_64 as well as 3.6.9-4.fc18.x86_64, 3.6.10-5.fc18.x86_64 and 3.6.11-3.fc18.x86_64; and all have the same problem. 3.6.9-2.fc17.x86_64 was the last kernel which I ran for over two weeks and had suspended a few times according to my /var/log/messages*. So this looks like a fedora-18 specific problems brought on by changes in userland
> between F17 and F18. (possibly the systemd integrated udevd).
> 
> I'll add a comment to the bug report and let John reassign as appropriate.

Thanks, Hin-Tak!  I'll ask Kay to investigate.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
