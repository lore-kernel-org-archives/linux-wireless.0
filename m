Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from w1.fi ([128.177.27.249]:47230 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab1AZOE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jan 2011 09:04:57 -0500
Date: Wed, 26 Jan 2011 16:04:44 +0200
From: Jouni Malinen <j@w1.fi>
To: Arik Nemtsov <arik@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH v2 0/6] Probe-resp offloading support
Message-ID: <20110126140444.GA30373@jm.kir.nu>
References: <1295816579-28925-1-git-send-email-arik@wizery.com>
 <1295869283.3639.7.camel@jlt3.sipsolutions.net>
 <AANLkTi=cSdi_i=RBtcp_aLG92S3xdMvJEMSfVdqX=qAK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTi=cSdi_i=RBtcp_aLG92S3xdMvJEMSfVdqX=qAK@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 24, 2011 at 11:21:44PM +0200, Arik Nemtsov wrote:
> Well a wiphy flag won't do here. Probe requests may be filtered in
> some modes (AP-mode) but needed in others (p2p?).
> I think flexibility is a nice added bonus here. A FW can decide to
> handle most standard probe-requests and simply not pass them up.
> Others ("complicated" ones) it can pass up to hostapd and expect it to reply.

Hmm.. So would the design be that upper layers (mac80211/hostapd) would
not see the Probe Request frames that the firmware replies to? What
would be criteria in selecting what is a "standard" and what is a
"complicated" Probe Request?

One thing that came up when I was thinking about a bit more is that even
with WPS 1.0, the Probe Request frames with WSC IE must be passed up to
hostapd for PBC session overlap detection and to support external
Registrars. So even if you could reply to those Probe Request frames in
firmware, they would still need to be indicated to hostapd and hostapd
(or something else in the system) would need to know that a duplicated
response should not be sent. Similar needs for receiving Probe Request
frames apply for P2P and potentially for some other protocols, too.

What is the main point of replying to Probe Request frames in the
firmware? Reduced latency? Reduced power consumption of the host CPU?
Something else? The former could be achieved even if the frame were
passed up; the latter would be difficult to achieve if WPS or P2P is
enabled without implementing large part of the protocol in the
firmware..

-- 
Jouni Malinen                                            PGP id EFC895FA
