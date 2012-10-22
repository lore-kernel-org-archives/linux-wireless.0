Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37878 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753279Ab2JVNUG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 09:20:06 -0400
Message-ID: <1350912037.10166.5.camel@jlt4.sipsolutions.net> (sfid-20121022_152014_050017_044890AA)
Subject: Re: [regression][bisected] Handling of channel contexts causes
 wireless to fail (i.e. no wlan* devices)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ronald <ronald645@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 22 Oct 2012 15:20:37 +0200
In-Reply-To: <CAF1_xX2uo0Q7mNSEENA2uH61itMxjoJ8ejcS9MeW5puibXpeeQ@mail.gmail.com> (sfid-20121022_151350_348128_51F9AA58)
References: <CAF1_xX2uo0Q7mNSEENA2uH61itMxjoJ8ejcS9MeW5puibXpeeQ@mail.gmail.com>
	 (sfid-20121022_151350_348128_51F9AA58)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-10-22 at 15:13 +0200, Ronald wrote:
> The following commit causes wireless interfaces to not show up (i.e.
> wlan* is non existant):
> 
> fe57d9f: mac80211: track whether to use channel contexts
> 
> Reverting this commit on top of current wireless-testing resulted in
> undefined references to chanctx.

Oops, my mistake, this should fix it:

http://p.sipsolutions.net/cd55626ca51fc3c5.txt

johannes

