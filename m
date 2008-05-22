Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:52016 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYEVTI3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 May 2008 15:08:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: do not alter injected seq numbers
Date: Thu, 22 May 2008 21:08:05 +0200
Cc: Stefanik =?iso-8859-15?q?G=E1bor?= <netrolller.3d@gmail.com>,
	JMF <tolas_feup@hotmail.com>,
	Alejandro Grijalba =?iso-8859-15?q?Mart=EDnez?=
	<sud@latinsud.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
References: <47FAB829.9010304@latinsud.com> <69e28c910805221152g199d83b9s225799d0e3e53bcd@mail.gmail.com> <1211482981.3698.61.camel@johannes.berg>
In-Reply-To: <1211482981.3698.61.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Message-Id: <200805222108.06322.mb@bu3sch.de> (sfid-20080522_210833_489849_215D9483)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 22 May 2008 21:03:01 Johannes Berg wrote:
> On Thu, 2008-05-22 at 20:52 +0200, Stefanik G=E1bor wrote:
> > On Thu, May 22, 2008 at 8:34 PM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > >> >> This does not work, since we use injection for other types of
> > >> >>  frames. For example management frames from hostapd. We don't=
 want
> > >> >>  (and can't) make hostapd keep track of sequence numbers.
> > >> >> You'll have to contact radiotap people and add a flag for thi=
s.
> > >> >>  This would also solve the hardware counter problem then.
> > >
> > >> The flag is IEEE80211_TX_INJECTED. Here is a new patch, for the
> > >> current wireless-testing:
> > >
> > > Reorder the two blocks and you have your answer. NO.
> > >
> > > johannes
> > >
> >=20
> > Hmm, shouldn't this version fix the hostap and other non-monitor-mo=
de cases?
>=20
> No, because hostapd uses monitor interfaces. Give up, it doesn't work
> without an extra radiotap flag.

Well, don't give up, but please contact the radiotap people for adding =
such
a flag to the header. That's really the only way to go.
There are more flags to be added, like we-are-not-interested-in-acks.

--=20
Greetings Michael.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
