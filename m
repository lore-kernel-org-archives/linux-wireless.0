Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52220 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754740Ab2BAQb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 11:31:29 -0500
Date: Wed, 1 Feb 2012 11:27:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Mohammed Shafi <shafi.wireless@gmail.com>
Cc: Laurent Bonnans <bonnans.l@gmail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: 
Message-ID: <20120201162730.GA29685@tuxdriver.com> (sfid-20120201_173132_702809_58D87CC4)
References: <CAAJ3AHeF5-yD_+a6HiA3Ty-yjizM4hOqS+nnZimbJULuX0s--A@mail.gmail.com>
 <CAD2nsn2RTzkx_1ApoyPixfim6j5sY7kscW4QAzoVu49HyTNJjA@mail.gmail.com>
 <CAD2nsn0c=cUdD8kQWNprGr7GJ6t1Y+c=LA2KZ+sSVgrsb3oedQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CAD2nsn0c=cUdD8kQWNprGr7GJ6t1Y+c=LA2KZ+sSVgrsb3oedQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 01, 2012 at 04:44:08PM +0530, Mohammed Shafi wrote:
> On Tue, Jan 31, 2012 at 11:28 AM, Mohammed Shafi
> <shafi.wireless@gmail.com> wrote:
> > On Tue, Jan 31, 2012 at 1:13 AM, Laurent Bonnans <bonnans.l@gmail.com> wrote:
> >> Since the update from linux 3.2.1 to 3.2.2, dhcp stopped working on
> >> some APs on my laptop with an AR9285 Wireless card.
> >>
> >> dhcp works fine on an open wifi network but receives no response on a
> >> wep network I use. I haven't been able to test it on a third network
> >> for now.
> >
> >  reverting  "ath9k_hw: fix interpretation of the rx KeyMiss flag" does
> > helps.  i  need to analyze
> > if it exposes some real issue which need to be fixed.
> >
> 
> this seems to be a problem in WEP alone, where the key miss is always
> set for this case and RX_FLAG_DECRYPTED is not set. mac80211 trys to
> decrypt,  but fails due to ICV mismatch.

OK...any way to differentiate this case at that point in the code?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
