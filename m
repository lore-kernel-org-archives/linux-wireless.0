Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:40748 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755752AbYKCQsu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 11:48:50 -0500
Message-ID: <490F2B6C.9090002@openwrt.org> (sfid-20081103_174852_988997_5757C55B)
Date: Mon, 03 Nov 2008 17:48:44 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Michael Buesch <mb@bu3sch.de>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: No ProbeResp - assume out of range
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com> <200811022303.54476.mb@bu3sch.de> <1ba2fa240811021442o178c98a1pa920b863b60d9293@mail.gmail.com> <43e72e890811021458h1444d350v33a5e5b984b76495@mail.gmail.com> <20081103002558.GA14153@tesla>
In-Reply-To: <20081103002558.GA14153@tesla>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> OK I found the issue with ath5k, no beacons were being passed at all, I'll post
> a patch.
Why not configure the beacon miss interrupt instead of passing beacons to
mac80211 in STA mode? That should save some battery on Laptops because it 
won't cause 10 extra wakeups every second.

- Felix
