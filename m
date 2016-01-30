Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0147.hostedemail.com ([216.40.44.147]:47148 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752806AbcA3MJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 07:09:38 -0500
Message-ID: <1454155774.7329.3.camel@perches.com> (sfid-20160130_131035_674369_C29E389C)
Subject: Re: [PATCH] staging: rtl8723au: Fixes unnecessary return warning
From: Joe Perches <joe@perches.com>
To: Julian Calaby <julian.calaby@gmail.com>,
	Bhakti Priya <bhaktipriya96@gmail.com>,
	Andy Whitcroft <apw@shadowen.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 30 Jan 2016 04:09:34 -0800
In-Reply-To: <CAGRGNgUPiFUyDw01RZ2iXQ-doPokdDnprqF2Jr=8mzHkbMgfvA@mail.gmail.com>
References: <20160129172908.GA14077@Karyakshetra>
	 <wrfjk2ms465z.fsf@redhat.com>
	 <CAGRGNgWQvdfQc-L9z0NKCyCOorxU0seQ-XvYnZDBWA3QKySrRA@mail.gmail.com>
	 <1454117303.10099.84.camel@perches.com>
	 <CAGRGNgU2EuY9fpe8rhHtA8OLDRC0s5=tcBStqpq=ZbMNrnuf0w@mail.gmail.com>
	 <1454123891.10099.89.camel@perches.com>
	 <CAFNHFT9nosMWgAvDdhvpMQLa2+02kD-wk0ChuZWpvCbLGMFYOg@mail.gmail.com>
	 <CAGRGNgUPiFUyDw01RZ2iXQ-doPokdDnprqF2Jr=8mzHkbMgfvA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-01-30 at 23:02 +1100, Julian Calaby wrote:
> Hi Bhakti,
> 
> On Sat, Jan 30, 2016 at 5:53 PM, Bhakti Priya  wrote:
> > Hi,
> > 
> > Thank you for your reply. I've just sent version 2 of the patch with
> > the blank lines removed.
> > I will be happy to extend checkpatch.pl. As suggested by you, I am
> > trying to detect such blank lines in a line removal patch by checking
> > if the line above the deleted line was a blank line and the line
> > following the deleted line had a closing brace.
> > Can you please guide me and let me know if I am headed in the right direction.
> 
> As I understand it, the algorithm needs to work like this:
> 1. For each patch hunk:
> 2. Filter out all lines that match /^-/
> 3. Remove the first character (" " or "+")
> 4. Normalise EOL characters: s/\r\n?/\n/
> 5. Over the entire hunk, find any case that matches
> /({|\n)\s*\n\s*(\n|})/ where \s matches all space characters except
> \n.
> 6. Report the middle line the preceding regular expression matches to the user.
> 
> I'm confident I can write it as a shell script, but I don't know
> enough Perl to add that test to checkpatch.pl

That's basically what the $prevline variable in checkpatch does.
Likely it's enough to check that.
Perhaps Andy Whitcroft knows.

