Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:55334 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751125AbaLOM3x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2014 07:29:53 -0500
Message-ID: <1418646586.5731.4.camel@sipsolutions.net> (sfid-20141215_132957_048650_2857E031)
Subject: Re: [PATCHv2] mac80211: enable TPC through mac80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Thomas =?ISO-8859-1?Q?H=FChn?= <thomas@net.t-labs.tu-berlin.de>,
	adrian@freebsd.org, haim.dreyfuss@intel.com
Date: Mon, 15 Dec 2014 13:29:46 +0100
In-Reply-To: <CAA2SeNJ6oiVRJmZS54Z6dSQDsEM10dCBqSGVmKe+QDaqLzgdWQ@mail.gmail.com> (sfid-20141212_151608_510452_48DE24A6)
References: <1417429814-9618-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1418387190.2470.28.camel@sipsolutions.net>
	 <CAA2SeNJ6oiVRJmZS54Z6dSQDsEM10dCBqSGVmKe+QDaqLzgdWQ@mail.gmail.com>
	 (sfid-20141212_151608_510452_48DE24A6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-12-12 at 15:16 +0100, Lorenzo Bianconi wrote:

> In multi-vif scenario, TPC could be enabled just on given interfaces,
> but driver TPC registers should be configured anyway (so I used a glob
> flag). However I can move that logic in driver code, what do you
> suggest?

It seems strange that a driver would look at both bss_conf and hw conf
for the same thing - so seems it might be more understandable if it was
in the driver?

johannes

