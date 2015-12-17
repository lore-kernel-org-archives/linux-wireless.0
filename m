Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0039.hostedemail.com ([216.40.44.39]:56615 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755841AbbLQLBw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 06:01:52 -0500
Message-ID: <1450350106.3430.5.camel@perches.com> (sfid-20151217_120155_921482_FB1FD60A)
Subject: Re: [PATCH] Print warnings for missing cfg80211_ops implementations
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Ola Olsson <ola1olsson@gmail.com>
Cc: "ola. olsson" <ola.olsson@sonymobile.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 17 Dec 2015 03:01:46 -0800
In-Reply-To: <1450339048.8247.19.camel@sipsolutions.net>
References: <1450302215-16156-1-git-send-email-ola1olsson@gmail.com>
	 <1450314972.5661.2.camel@perches.com>
	 <CABAco3BSaB9R6-nZQsmOnfXXy2ra-un0jjeBkyq4inzCybD5dw@mail.gmail.com>
	 <1450329559.5661.5.camel@perches.com>
	 <CABAco3DCSqzrCZWYXyibV0U1vuTk1En0k505J67vT6eEP2SfEw@mail.gmail.com>
	 (sfid-20151217_083413_469909_7FF85E76) <1450339048.8247.19.camel@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-17 at 08:57 +0100, Johannes Berg wrote:
> On Thu, 2015-12-17 at 08:34 +0100, Ola Olsson wrote:
> > > but maybe it should be
> > > 
> > >         WARN_ON((ops->add_station && !ops->del_station) ||
> > >                 (!opt->add_station && ops->del_station))
> > > 
> > > etc...
> > 
> > Ahh, got it! I really like your idea but I assume it's quite rare to
> > implement the "stop/del/leave/disconnect" callbacks and at the same
> > time forget to implement the "start/add/join/connect". You will
> > probably find out pretty quickly if the "start" functions are
> > missing,
> > while it might take some time debugging why you lack the "stop"
> > functions (reinitialization issues/ resource leaks for example).
> > 
> > With that said, don't take my word for it, I was only following the
> > existing pattern and I assume someone else had a good reason in the
> > first place.
> > 
> 
> Pretty much what you said :)

Following patterns is good, I just think the
pattern could be trivially improved.

The test is a runtime check on what would ideally
be done at compile time.

Using
	WARN_ON(!a ^ !b)
which is logically the same as what I wrote above
for clarity is simply a bit more coverage and maybe
even a bit run-time faster.


