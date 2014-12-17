Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36167 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751163AbaLQKvE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:51:04 -0500
Message-ID: <1418813460.2135.9.camel@sipsolutions.net> (sfid-20141217_115108_673942_883100F6)
Subject: Re: [PATCHv2] mac80211: enable TPC through mac80211 stack
From: Johannes Berg <johannes@sipsolutions.net>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Thomas =?ISO-8859-1?Q?H=FChn?= <thomas@net.t-labs.tu-berlin.de>,
	adrian@freebsd.org, haim.dreyfuss@intel.com
Date: Wed, 17 Dec 2014 11:51:00 +0100
In-Reply-To: <CAA2SeN+71_ZR_H-Mkb5+PLwVe6dhCoknh8puWUjFXf73Ab1MnA@mail.gmail.com> (sfid-20141215_144037_670662_0791986A)
References: <1417429814-9618-1-git-send-email-lorenzo.bianconi83@gmail.com>
	 <1418387190.2470.28.camel@sipsolutions.net>
	 <CAA2SeNJ6oiVRJmZS54Z6dSQDsEM10dCBqSGVmKe+QDaqLzgdWQ@mail.gmail.com>
	 <1418646586.5731.4.camel@sipsolutions.net>
	 <CAA2SeN+71_ZR_H-Mkb5+PLwVe6dhCoknh8puWUjFXf73Ab1MnA@mail.gmail.com>
	 (sfid-20141215_144037_670662_0791986A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-12-15 at 14:40 +0100, Lorenzo Bianconi wrote:

> In pending driver (ath9k) patches TPC related info in hw conf and
> bss_conf are not used for the same purpose. The first one is used to
> configure HW TPC registers, since TPC should be enabled in hw if there
> is at least one interface where TPC has been configured, whereas the
> latter it use to figure out if the transmitted frame belongs to a vif
> where TPC has been previously enabled. If I do not set TPC info in hw
> conf I have to loop over all vif every time TPC configuration is
> applied from mac80211, since ath9k uses just hw conf structure to set
> TX power info. Maybe that solution is a little bit tricky. What do you
> think? Sorry if in previous emails I was not so clear :)

But you also didn't really implement that logic in mac80211?

IMHO this is a driver quirk that the driver should worry about.

johannes

