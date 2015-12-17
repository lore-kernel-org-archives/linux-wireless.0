Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48441 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753207AbbLQH5f (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 02:57:35 -0500
Message-ID: <1450339048.8247.19.camel@sipsolutions.net> (sfid-20151217_085738_934433_23EDF8D4)
Subject: Re: [PATCH] Print warnings for missing cfg80211_ops implementations
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>, Joe Perches <joe@perches.com>
Cc: "ola. olsson" <ola.olsson@sonymobile.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 17 Dec 2015 08:57:28 +0100
In-Reply-To: <CABAco3DCSqzrCZWYXyibV0U1vuTk1En0k505J67vT6eEP2SfEw@mail.gmail.com> (sfid-20151217_083413_469909_7FF85E76)
References: <1450302215-16156-1-git-send-email-ola1olsson@gmail.com>
	 <1450314972.5661.2.camel@perches.com>
	 <CABAco3BSaB9R6-nZQsmOnfXXy2ra-un0jjeBkyq4inzCybD5dw@mail.gmail.com>
	 <1450329559.5661.5.camel@perches.com>
	 <CABAco3DCSqzrCZWYXyibV0U1vuTk1En0k505J67vT6eEP2SfEw@mail.gmail.com>
	 (sfid-20151217_083413_469909_7FF85E76)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-17 at 08:34 +0100, Ola Olsson wrote:
> > but maybe it should be
> > 
> >         WARN_ON((ops->add_station && !ops->del_station) ||
> >                 (!opt->add_station && ops->del_station))
> > 
> > etc...
> 
> Ahh, got it! I really like your idea but I assume it's quite rare to
> implement the "stop/del/leave/disconnect" callbacks and at the same
> time forget to implement the "start/add/join/connect". You will
> probably find out pretty quickly if the "start" functions are
> missing,
> while it might take some time debugging why you lack the "stop"
> functions (reinitialization issues/ resource leaks for example).
> 
> With that said, don't take my word for it, I was only following the
> existing pattern and I assume someone else had a good reason in the
> first place.
> 

Pretty much what you said :)

johannes
