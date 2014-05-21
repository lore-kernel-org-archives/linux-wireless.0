Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41663 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752091AbaEUTJi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 15:09:38 -0400
Message-ID: <1400699356.4136.13.camel@jlt4.sipsolutions.net> (sfid-20140521_210943_112167_09682A94)
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 21 May 2014 21:09:16 +0200
In-Reply-To: <20140521180020.GA13656@tuxdriver.com>
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
	 <CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
	 <20140520142453.GB13981@tuxdriver.com>
	 <CALhHN=qtxwww9hQ7XxK8tan3+4eSoXo3D_g9YLD0QhQDPcDUmg@mail.gmail.com>
	 <20140520180832.GD13981@tuxdriver.com>
	 <1400610273.4474.6.camel@jlt4.sipsolutions.net>
	 <CAB=NE6WiuydxR62dvua_OEyV+sqxvH8aOUHOBLS3ePz1dGCLAw@mail.gmail.com>
	 <1400688233.4136.8.camel@jlt4.sipsolutions.net>
	 <20140521180020.GA13656@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-21 at 14:00 -0400, John W. Linville wrote:

> The 'do not parse more permissively' would seem to be a problem if
> we still produce an older format too, no?  I mean, wouldn't we have
> to simply drop new rules to produce an older binary?  Even worse if
> we left the old binary in place, since then you could never update
> any rules for old crda installations at all.

That's true, in a sense.

> It seems like forcing a crda update to use any new format-breaking
> rules might just be the right thing.  Can we make crda choke and die
> loudly when it sees an unknown format?  Will the current crda do that?

It will, yes. If the version number is mismatched it'll print "Invalid
database version" (to stderr) and exit.

johannes

