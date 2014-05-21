Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:41205 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaEUQER (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 May 2014 12:04:17 -0400
Message-ID: <1400688233.4136.8.camel@jlt4.sipsolutions.net> (sfid-20140521_180421_260091_F7282561)
Subject: Re: [PATCH] wireless-regdb: add DFS CAC time parameter
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 21 May 2014 18:03:53 +0200
In-Reply-To: <CAB=NE6WiuydxR62dvua_OEyV+sqxvH8aOUHOBLS3ePz1dGCLAw@mail.gmail.com> (sfid-20140520_204832_656990_FF6AC676)
References: <1399624824-9204-1-git-send-email-janusz.dziedzic@tieto.com>
	 <CAB=NE6UuZFDLdA-KW=ohaFwXjj_3wSY84cj3-KPO7HoKREPHOA@mail.gmail.com>
	 <20140520142453.GB13981@tuxdriver.com>
	 <CALhHN=qtxwww9hQ7XxK8tan3+4eSoXo3D_g9YLD0QhQDPcDUmg@mail.gmail.com>
	 <20140520180832.GD13981@tuxdriver.com>
	 <1400610273.4474.6.camel@jlt4.sipsolutions.net>
	 <CAB=NE6WiuydxR62dvua_OEyV+sqxvH8aOUHOBLS3ePz1dGCLAw@mail.gmail.com>
	 (sfid-20140520_204832_656990_FF6AC676)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-20 at 11:48 -0700, Luis R. Rodriguez wrote:

> > I think we should, but if we can't then at least can we cut to an
> > extensible format?

I don't see any way to extend the format right now.

There's a wrinkle with making it more extensible too though - if we do
that then we must be extremely careful that future older crda versions
(i.e. the next version that we're about to write) will not parse a newer
extended file more permissively, so our extensions are limited anyway.

Looks like the format update really is needed, which probably means we
should change the scripts to generate two databases and change the
filename, or so?

johannes

