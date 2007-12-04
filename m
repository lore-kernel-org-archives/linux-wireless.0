Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:49800 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751356AbXLDKFs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 05:05:48 -0500
Date: Tue, 4 Dec 2007 11:01:35 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Message-ID: <20071204110135.1835a57e@morte> (sfid-20071204_100550_877701_10ECE38E)
In-Reply-To: <1196756103.7476.12.camel@localhost>
References: <1196622331.7472.4.camel@localhost>
	<20071203041608.3af3b462@morte>
	<1196679780.7470.9.camel@localhost>
	<20071203125402.76562f26@morte>
	<1196683144.7470.14.camel@localhost>
	<20071203130602.49ab7234@morte>
	<40f31dec0712031442q51a658abwfde965dae3fb6b72@mail.gmail.com>
	<20071204024146.15689ee3@morte>
	<1196756103.7476.12.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 04 Dec 2007 09:15:03 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> Um, if Nick says the device has problems transmitting frames, IMHO this
> will make it quite impossible to get the PID rate control right by
> tuning parameters. Of course you can set the failed frames percentage
> target to 100, but that's certainly not what we want.

Ok, sure. But to some degree, having problems in transmitting frames
because of driver issues is an approximation of a noisy environment.
However, we can't do so much in this specific case.

> Just an idea for your hack: wouldn't it be easier if we had all these
> parameters accessible via debugfs instead of module parameters? Also, it
> might be useful to have the parameters in sysfs so they can be changed
> also for production systems, once mac80211 is stable.

They are in sysfs. You just need to set perm to 0644. But this is racy, and
you should implement some locking, and I just didn't want to bother about
this. It's not racy, if you make sure that the interface is down while you
write parameters. Of course, if we want these parameters to get into
mac80211, proper locking should be implemented.


--
Ciao
Stefano
