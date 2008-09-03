Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:43336 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751398AbYICMJW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 08:09:22 -0400
Date: Wed, 3 Sep 2008 15:07:36 +0300
From: Jouni Malinen <j@w1.fi>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Zhu Yi <yi.zhu@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	LKML <linux-kernel@vger.kernel.org>, reinette.chatre@intel.com,
	linux-wireless@vger.kernel.org,
	Jan-Espen Pettersen <sigsegv@radiotube.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: new: regression iwl3945/mac80211 endless after suspend
	associate/deassociate loop
Message-ID: <20080903120736.GQ17345@jm.kir.nu> (sfid-20080903_140928_012738_14272BDD)
References: <20080901160658.GA11063@google.com> <1220319536.28282.128.camel@debian.sh.intel.com> <4b0be9b641de902cb7de4ad50686f6e1.squirrel@secure.sipsolutions.net> <20080902130429.GB19172@google.com> <1220362201.3176.4.camel@borkbork.foobar.com> <20080902145840.GE19172@google.com> <1220368238.8041.4.camel@borkbork.foobar.com> <20080902172409.GJ17345@jm.kir.nu> <20080902205022.GA8230@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080902205022.GA8230@google.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 02, 2008 at 11:50:23PM +0300, Michael S. Tsirkin wrote:

> Could you tell me which bits are needed, and don't include
> security info? I wouldn't want to post the PSK, etc.

As long as you don't include -K on the command line, wpa_supplicant
should not include PSK or password or any other keys, etc. in the debug
log. It will include MAC addresses, though (and they are useful for
understanding what is happening).

> Hmm, since it manages to reassociate with -rc4 I would guess not.
> In any case killing wpa_supplicant after reboot and restarting it does not
> seem to help.

OK. If wpa_supplicant restart does not resolve the issue, this points
towards something in the kernel getting into an unexpected state. And
yes, that would indeed mean that it has nothing to do with the fix I
mentioned.

-- 
Jouni Malinen                                            PGP id EFC895FA
