Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:20852 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbZENSob (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 14:44:31 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 11:44:32 -0700
Subject: Re: [ath9k-devel] ath9k module-Unable to set channel-since ath
 comes
From: Jouni Malinen <jouni.malinen@atheros.com>
To: Davide Pesavento <davidepesa@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"alexander.bartha@drz-wien.at" <alexander.bartha@drz-wien.at>,
	Alexander Bartha <alex.xy.privat@gmx.at>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <2da21fe50905120135h1cb8746foae4b3b4b37b3cb24@mail.gmail.com>
References: <43e72e890905101141r6fe3b655ta158acabf4c87ec3@mail.gmail.com>
	 <OF24E7AF48.E39EC671-ONC12575B4.00236C72-C12575B4.0024C49C@drz-wien.at>
	 <43e72e890905112355t53537ca9w2797cfc8694302@mail.gmail.com>
	 <1242112310.3873.55.camel@johannes.local>
	 <43e72e890905120014w13ca9317r8ec8fa270f2bbb1e@mail.gmail.com>
	 <2da21fe50905120135h1cb8746foae4b3b4b37b3cb24@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 14 May 2009 21:44:27 +0300
Message-ID: <1242326667.14069.20.camel@jm-desktop>
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-12 at 01:35 -0700, Davide Pesavento wrote:
> I've already reported ath9k's issues with PS multiple times [1] [2]
> [3], but the driver hasn't been fixed yet. You can find a verbose
> debugging output at [4], I hope that helps in fixing the problem (I
> can provide even more info if needed and I'm willing to test patches).

I submitted a set of patches to resolve some of the PS issues in ath9k.
I would expect these to hit wireless-testing.git eventually, but if you
are willing to test the changes before that, you can find the patches
from http://w1.fi/p/ps/

One thing to note here is that there are still some issues with the
timeout=0 case (use of PS-Poll to fetch buffered frames) which is
enabled with "iwconfig wlan0 power on", so at this point, I would
recommend running the test either with the default wireless-testing.git
PS mode setting or by enabling power saving with "iwconfig wlan0 power
timeout 500ms" which should result in the same configuration.

I have not tested these on AR5418, but at least with AR9280, these
patches do improve stability and general functionality of the default PS
mode considerably. I have been able to run multi-hour tests without
losing connection.

- Jouni


