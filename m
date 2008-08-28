Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:49650 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750AbYH1Q52 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 12:57:28 -0400
Date: Thu, 28 Aug 2008 19:56:18 +0300
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	ltp-list <ltp-list@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni.Malinen@atheros.com
Subject: Re: [TESTING] Wireless mesh networking (802.11s) draft support
Message-ID: <20080828165618.GK4863@jm.kir.nu> (sfid-20080828_185732_888236_D479B241)
References: <1219698032.5434.6.camel@subratamodak.linux.ibm.com> <20080825214625.GL6007@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080825214625.GL6007@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 25, 2008 at 02:46:25PM -0700, Luis R. Rodriguez wrote:

> Mesh code is GPLv2 right now. What I'd recommend is to get mesh support
> added into mac80211_hwsim driver and then you can test mesh code without
> even having any wireless hardware.

That would be quite useful addition for automated tests that anyone can
run.

> At the third Linux wireless summit in Ottawa we briefly spoke about
> automating testing for wireless. We should try to automate this first
> with mac80211_hwsim and some scripts to do basic tests. Mesh testing can
> be added once mac8021_hwsim gets support for Mesh.

I've started collecting test cases for mac80211_hwsim. It would be
interesting to see whether these could be integrated into LTP somehow
and allow people to run a set of tests in fully scripted way. These
tests are described in hostap.git tree mac80211_hwsim/tests
subdirectories:
http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=tree;f=mac80211_hwsim/tests

The current instructions for running the commands (*/test.txt) are more
for a person than a script, but the changes to get test running would be
trivial (i.e., just run hostapd and wpa_supplicant on background).
Larger task is in adding some functionality to verify that the test
passed and then finish with cleaning up (killing daemons from background
and unload mac80211_hwsim).

-- 
Jouni Malinen                                            PGP id EFC895FA
