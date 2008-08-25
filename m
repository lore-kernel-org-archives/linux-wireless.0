Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39379 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512AbYHYVq0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 17:46:26 -0400
Date: Mon, 25 Aug 2008 14:46:25 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
CC: Luis Carlos Cobo <luisca@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	ltp-list <ltp-list@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	<Jouni.Malinen@atheros.com>
Subject: Re: [TESTING] Wireless mesh networking (802.11s) draft support
Message-ID: <20080825214625.GL6007@tesla> (sfid-20080825_234630_202184_B79D09AC)
References: <1219698032.5434.6.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1219698032.5434.6.camel@subratamodak.linux.ibm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 25, 2008 at 02:00:31PM -0700, Subrata Modak wrote:
> Hi Luis/Johannes/John,
> 
> The Wireless mesh networking (802.11s) draft support has been added to
> Linux 2.6.26. We at LTP (http://ltp.sourceforge.net/,
> https://sourceforge.net/projects/ltp/) are trying to expand the test
> coverage of all the untouched areas of kernel. With this drive in mind,
> may i know if the testing infrastructure of Wireless mesh networking can
> be shared with LTP under GPLv2. It would be a shot-in-the-arm for Linux
> testing community, and, we can decide on how this can be best integrated
> into LTP.

Mesh code is GPLv2 right now. What I'd recommend is to get mesh support
added into mac80211_hwsim driver and then you can test mesh code without
even having any wireless hardware.

At the third Linux wireless summit in Ottawa we briefly spoke about
automating testing for wireless. We should try to automate this first
with mac80211_hwsim and some scripts to do basic tests. Mesh testing can
be added once mac8021_hwsim gets support for Mesh.

Here are two scripts which create an AP and one which creates a STA with
the different encryption setups available.

http://www.winlab.rutgers.edu/~mcgrof/qa/create-ap.sh.txt
http://www.winlab.rutgers.edu/~mcgrof/qa/create-client.sh.txt

Similar type of scripts can be used to create different topologies and
test environments. Later on once this is polished we can test the actual
hardware with different drivers. But this should be a roadmap to start
IMO.

Let me know what you think.

For more information on mac80211_hwsim please see:

Documentation/networking/mac80211_hwsim/README

  Luis
