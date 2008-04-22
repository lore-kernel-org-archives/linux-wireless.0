Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752351AbYDVOkc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 10:40:32 -0400
Subject: Re: prism54 regression in current -git
From: Dan Williams <dcbw@redhat.com>
To: Patrick McHardy <kaber@trash.net>
Cc: Roy Marples <uberlord@gentoo.org>,
	"Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <480D6CA4.8040205@trash.net>
References: <480D6CA4.8040205@trash.net>
Content-Type: text/plain
Date: Tue, 22 Apr 2008 10:36:38 -0400
Message-Id: <1208874998.17364.7.camel@localhost.localdomain> (sfid-20080422_164118_809199_A4A93C29)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-04-22 at 06:42 +0200, Patrick McHardy wrote:
> The patch "prism54: set carrier flags correctly" makes my
> prism54 device in AP mode come up without a carrier, which
> in causes IPv6 to not add a link-local address, which in
> turn causes radvd (configured to announce routes on that
> device) to refuse to start, breaking IPv6 for the entire
> network.
> 
> I didn't check whether a carrier is detected once a client
> associates, but in any case it seems to me that a device
> in AP mode should always indicate a carrier.

Should always indicate a carrier _when it's configured and up_.  If you
just go 'iwconfig eth1 mode master' it shouldn't, but if you do:

ifconfig eth1 up
iwconfig eth1 mode master essid foobar

then it should.

Dan


