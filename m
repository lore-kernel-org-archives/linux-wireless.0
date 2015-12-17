Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50674 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755741AbbLQMnO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 07:43:14 -0500
Message-ID: <1450356187.8247.30.camel@sipsolutions.net> (sfid-20151217_134318_655418_05B66F4A)
Subject: Re: [PATCH] Print warnings for missing cfg80211_ops implementations
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>, Ola Olsson <ola1olsson@gmail.com>
Cc: "ola. olsson" <ola.olsson@sonymobile.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 17 Dec 2015 13:43:07 +0100
In-Reply-To: <1450350106.3430.5.camel@perches.com>
References: <1450302215-16156-1-git-send-email-ola1olsson@gmail.com>
	 <1450314972.5661.2.camel@perches.com>
	 <CABAco3BSaB9R6-nZQsmOnfXXy2ra-un0jjeBkyq4inzCybD5dw@mail.gmail.com>
	 <1450329559.5661.5.camel@perches.com>
	 <CABAco3DCSqzrCZWYXyibV0U1vuTk1En0k505J67vT6eEP2SfEw@mail.gmail.com>
	 (sfid-20151217_083413_469909_7FF85E76) <1450339048.8247.19.camel@sipsolutions.net>
	 <1450350106.3430.5.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-12-17 at 03:01 -0800, Joe Perches wrote:

> Following patterns is good, I just think the
> pattern could be trivially improved.

It's a question of what makes sense though - nobody implements stop_xyz
without implementing start_xyz, and even if they do it's pointless.
It's just that if you have start_xyz most/all of your functional tests
might work, but we'd really like to have stop_xyz as well.

It's not *worse* to check for the XOR (like you suggest below), but
it's not really any better either.

> The test is a runtime check on what would ideally
> be done at compile time.

If you have any suggestions how to do that then that'd be great :) I
don't really see a way of doing that since this depends on the driver
and the driver might even fill the struct at runtime (like hwsim does
IIRC)

> Using
> 	WARN_ON(!a ^ !b)
> which is logically the same as what I wrote above
> for clarity is simply a bit more coverage and maybe
> even a bit run-time faster.

Don't think we have to worry much about the runtime overhead, but
that's a nice idea. As I said above though, I don't think it really
makes a difference.

johannes
