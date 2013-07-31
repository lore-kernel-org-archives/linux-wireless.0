Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kvm.w1.fi ([128.177.28.162]:49400 "EHLO
	jmaline2.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755201Ab3GaHZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Jul 2013 03:25:49 -0400
Date: Wed, 31 Jul 2013 10:25:31 +0300
From: Jouni Malinen <j@w1.fi>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Greear <greearb@candelatech.com>,
	Paul Stewart <pstew@chromium.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: 802.11 infrastructure for regression testing - upstream /
 mac80211 / cfg80211
Message-ID: <20130731072531.GA3956@w1.fi> (sfid-20130731_092552_305095_587A0575)
References: <CAB=NE6Vm18RcDYQn+QoEzSG202HezT0rqV_hwb_UOzyecstu5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAB=NE6Vm18RcDYQn+QoEzSG202HezT0rqV_hwb_UOzyecstu5w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 30, 2013 at 05:53:31PM -0700, Luis R. Rodriguez wrote:
> AFAICT mac80211_hwism should and likely already is used for a slew of
> core API changes / tests. Addressing testing using that shoud
> hopefully address tons of testings and find a lot of issues. We'd then
> just need vendors to replicate behaviour on top of their drivers. The
> core test stuff though still needs to be available.

I have automated tests running mainly from wpa_supplicant/hostapd
regression testing view point on top of mac80211_hwsim. The test cases
are in hostap.git:
http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=tree;f=tests/hwsim;hb=HEAD

These tests are run automatically on all hostap.git commits in a simple
Buildbot setup: http://buildbot.w1.fi:8010/

There's currently 51 test cases covering relatively large set of basic
functionality (and various corner cases, too). I'm hoping to extend this
to cover all common use cases and lot of protocol conformance testing
for that matter. In addition, I use this for development time testing,
so new tests show up at the same time with new functionality.

These tests are currently run on top of a single cfg80211/mac80211
version that I'm updating manually every now and then. I have found
regressions on those components, too, and not just
wpa_supplicant/hostapd, so it would sound useful to get this running
automatically on cfg80211/mac80211 snapshots, too, to get faster reports
on regressions. My buildbot.w1.fi server is a very low-end virtual
server, so it won't be able to do this, but if someone has a bit more
beefier server available, it would be straightforward to extend this
type of Buildbot setup to trigger both on hostap.git and
wireless-testing.git commits to run the tests. The server would need to
be able to run kvm and build kernel.

Obviously mac80211_hwsim tests won't cover everything, but so far, I've
been quite happy with the coverage it can give for testing
wpa_supplicant, hostapd, cfg80211, and mac80211.

-- 
Jouni Malinen                                            PGP id EFC895FA
