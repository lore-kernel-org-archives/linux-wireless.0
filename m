Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:58725 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646AbYH1QEz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Aug 2008 12:04:55 -0400
Date: Thu, 28 Aug 2008 19:04:01 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: VLAN testing (and mac80211_hwsim test cases in general)
Message-ID: <20080828160401.GG4863@jm.kir.nu> (sfid-20080828_180458_932748_C3E6131D)
References: <20080617154008.883383150@localhost> <1215625246.3246.40.camel@johannes.berg> <1215626936.3246.45.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1215626936.3246.45.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 09, 2008 at 08:08:56PM +0200, Johannes Berg wrote:

> Just realised that it doesn't handle VLANs properly. Could you add a
> static MAC/VLAN mapping to hostapd to make VLANs possible without
> setting up radius? :)

In order to get more people testing this, I finally gave in and added
that option into hostapd ;-), so now you can do this without having to
set up a RADIUS server. To make things even easier, I made an example
configuration and test instructions for mac80211_hwsim available:

http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=tree;f=mac80211_hwsim/tests/0002-vlan


I started collecting mac80211_hwsim test cases into mac80211_hwsim/tests
directory in hostap.git. I hope this will make it easy for developers to
test mac80211 features. For the time being, this is for manual testing,
but hopefully at some point these tests can be run automatically with a
script (e.g., daily or whenever wireless-testing changes, etc.). The
test.txt file includes the commands needed to run both the AP and
client(s). Some additional infrastructure would be needed to validate
the end results and start/stop wpa_supplicant and hostapd in the
background.

-- 
Jouni Malinen                                            PGP id EFC895FA
