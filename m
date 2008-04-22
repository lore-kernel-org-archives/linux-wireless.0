Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40218 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760015AbYDVO4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2008 10:56:48 -0400
Message-ID: <480DFCB4.3040104@trash.net> (sfid-20080422_165740_861110_32672F95)
Date: Tue, 22 Apr 2008 16:56:52 +0200
From: Patrick McHardy <kaber@trash.net>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Roy Marples <uberlord@gentoo.org>,
	"Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: prism54 regression in current -git
References: <480D6CA4.8040205@trash.net> <1208874998.17364.7.camel@localhost.localdomain>
In-Reply-To: <1208874998.17364.7.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Tue, 2008-04-22 at 06:42 +0200, Patrick McHardy wrote:
>> The patch "prism54: set carrier flags correctly" makes my
>> prism54 device in AP mode come up without a carrier, which
>> in causes IPv6 to not add a link-local address, which in
>> turn causes radvd (configured to announce routes on that
>> device) to refuse to start, breaking IPv6 for the entire
>> network.
>>
>> I didn't check whether a carrier is detected once a client
>> associates, but in any case it seems to me that a device
>> in AP mode should always indicate a carrier.
> 
> Should always indicate a carrier _when it's configured and up_.  If you
> just go 'iwconfig eth1 mode master' it shouldn't, but if you do:
> 
> ifconfig eth1 up
> iwconfig eth1 mode master essid foobar
> 
> then it should.

Yes, it was up and running of course. No carrier though.
