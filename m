Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43155 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab3DMQS0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Apr 2013 12:18:26 -0400
Message-ID: <1365869899.1089.0.camel@jlt4.sipsolutions.net> (sfid-20130413_181832_851013_7C4187B4)
Subject: Re: [RFC/RFT] mwl8k: don't expose non-standard rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Jonas Gorski <jogo@openwrt.org>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>
Date: Sat, 13 Apr 2013 18:18:19 +0200
In-Reply-To: <CAJ-VmokacZUw1Wru_0w1XaVRoZWP6nOMcdKo=1yhP-C9rbifHg@mail.gmail.com> (sfid-20130413_162928_260950_E23BA078)
References: <1365849071-2389-1-git-send-email-jogo@openwrt.org>
	 <CAJ-VmokacZUw1Wru_0w1XaVRoZWP6nOMcdKo=1yhP-C9rbifHg@mail.gmail.com>
	 (sfid-20130413_162928_260950_E23BA078)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2013-04-13 at 07:29 -0700, Adrian Chadd wrote:
> Hi,
> 
> On 13 April 2013 03:31, Jonas Gorski <jogo@openwrt.org> wrote:
> > Do not advertise the non standard rates 22 Mbps and 72 Mbps to mac80211,
> > they will make it into the probe responses and cause clients checking them
> > to refuse association, e.g. wpa_supplicant says:
> 
> Are these "turbo" mode rates? ie, 40MHz wide channels with pre-11n
> rates on them?

22 actually *is* a standard rate, it's just that almost nobody
implements it.

The original problem seems a bit strange though, seems those should just
not be marked basic?

johannes

