Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:33916 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbcA3MCe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 07:02:34 -0500
MIME-Version: 1.0
In-Reply-To: <CAFNHFT9nosMWgAvDdhvpMQLa2+02kD-wk0ChuZWpvCbLGMFYOg@mail.gmail.com>
References: <20160129172908.GA14077@Karyakshetra> <wrfjk2ms465z.fsf@redhat.com>
 <CAGRGNgWQvdfQc-L9z0NKCyCOorxU0seQ-XvYnZDBWA3QKySrRA@mail.gmail.com>
 <1454117303.10099.84.camel@perches.com> <CAGRGNgU2EuY9fpe8rhHtA8OLDRC0s5=tcBStqpq=ZbMNrnuf0w@mail.gmail.com>
 <1454123891.10099.89.camel@perches.com> <CAFNHFT9nosMWgAvDdhvpMQLa2+02kD-wk0ChuZWpvCbLGMFYOg@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Sat, 30 Jan 2016 23:02:14 +1100
Message-ID: <CAGRGNgUPiFUyDw01RZ2iXQ-doPokdDnprqF2Jr=8mzHkbMgfvA@mail.gmail.com> (sfid-20160130_130254_658339_AACA9C54)
Subject: Re: [PATCH] staging: rtl8723au: Fixes unnecessary return warning
To: Bhakti Priya <bhaktipriya96@gmail.com>
Cc: Joe Perches <joe@perches.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Bhakti,

On Sat, Jan 30, 2016 at 5:53 PM, Bhakti Priya <bhaktipriya96@gmail.com> wrote:
> Hi,
>
> Thank you for your reply. I've just sent version 2 of the patch with
> the blank lines removed.
> I will be happy to extend checkpatch.pl. As suggested by you, I am
> trying to detect such blank lines in a line removal patch by checking
> if the line above the deleted line was a blank line and the line
> following the deleted line had a closing brace.
> Can you please guide me and let me know if I am headed in the right direction.

As I understand it, the algorithm needs to work like this:
1. For each patch hunk:
2. Filter out all lines that match /^-/
3. Remove the first character (" " or "+")
4. Normalise EOL characters: s/\r\n?/\n/
5. Over the entire hunk, find any case that matches
/({|\n)\s*\n\s*(\n|})/ where \s matches all space characters except
\n.
6. Report the middle line the preceding regular expression matches to the user.

I'm confident I can write it as a shell script, but I don't know
enough Perl to add that test to checkpatch.pl

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
