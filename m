Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4235 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755764Ab1GGOqg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jul 2011 10:46:36 -0400
Date: Thu, 7 Jul 2011 07:46:28 -0700
From: "Henry Ptasinski" <henryp@broadcom.com>
To: "Greg KH" <gregkh@suse.de>
cc: "Pavel Roskin" <proski@gnu.org>,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Brett Rudley" <brudley@broadcom.com>,
	"Arend Van Spriel" <arend@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: Re: [RFC] Move brcm80211 to mainline
Message-ID: <20110707144628.GF23944@broadcom.com> (sfid-20110707_164639_757953_399B082E)
References: <20110707002034.GA17885@broadcom.com>
 <CACna6rx5EyZ-=2XgWawdN_Qu2t1K1sdHZydZFW6=TiX2QUwMfw@mail.gmail.com>
 <4E1504A3.1070801@gnu.org> <20110707014512.GA21087@suse.de>
MIME-Version: 1.0
In-Reply-To: <20110707014512.GA21087@suse.de>
Content-Type: text/plain;
 charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 06, 2011 at 06:45:12PM -0700, Greg KH wrote:
> On Wed, Jul 06, 2011 at 08:58:11PM -0400, Pavel Roskin wrote:
> > On 07/06/2011 08:40 PM, Rafał Miłecki wrote:
> > >Short question, without commenting on brcm80211 code yet:
> > >
> > >Why should we want 2 mainline drivers for the same hardware?
> > 
> > Also, checkpatch.pl finds a lot of bad stuff:
> > 
> > total: 1 errors, 1505 warnings, 105454 lines checked
> > 
> > $ scripts/checkpatch.pl 0001-wireless-testing-add-brcm80211.patch >Log
> > $ egrep '^(WARNING|ERROR)' Log |sort |uniq -c
> >       1 ERROR: do not use assignment in if condition
> >      76 WARNING: braces {} are not necessary for any arm of this statement
> >     205 WARNING: braces {} are not necessary for single statement blocks
> >       4 WARNING: consider using a completion
> >      11 WARNING: consider using kstrto* in preference to simple_strtoul
> >      20 WARNING: do not add new typedefs
> >       5 WARNING: externs should be avoided in .c files
> >    1164 WARNING: line over 80 characters
> >      20 WARNING: Use of volatile is usually wrong: see
> 
> Almost all of these should be fixed, especially the volatile one, that's
> just horrible.

Fixes for these are in progress.  We'll keep posting patches to address this
cleanup in staging.

> Also, there's the whole big endian mess that needs to be fixed up before
> the driver can be moved out of staging.  Henry, what's the status of
> that?

We're looking at BE MIPS, and I sent some cards to Benjamin Herrenschmidt so he
can test on PPC platforms.

- Henry

