Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:47273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaAGPyb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 10:54:31 -0500
Message-ID: <1389110063.4645.21.camel@jlt4.sipsolutions.net> (sfid-20140107_165434_115561_98DCE522)
Subject: Re: [RFC] cfg80211: Advertise maximum associated STAs in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <j@w1.fi>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 07 Jan 2014 16:54:23 +0100
In-Reply-To: <20140106081151.GA1613@w1.fi>
References: <20140106081151.GA1613@w1.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-01-06 at 10:11 +0200, Jouni Malinen wrote:
> This allows drivers to advertise the maximum number of associated
> stations they support in AP mode (including P2P GO). User space
> applications can use this for cleaner way of handling the limit (e.g.,
> hostapd rejecting IEEE 802.11 authentication without manual
> configuration of the limit) or to figure out what type of use cases can
> be executed with multiple devices before trying and failing.

In theory, I think this is fine. In practice, I'm not sure it really
covers things too well, and some drivers like iwlwifi might end up not
being able to set it. The reason is that we have a limit of ~16 stations
internally, but some may be used for BSS/P2P-client interfaces and some
are used internally. In addition, when TDLS will be added, concurrency
might mean that we'd have to set this to a very low number although it
is likely that you'd never have P2P-GO, BSS clientand TDLS all together.

Since the current auth/assoc state machine is rather racy with mac80211
etc. anyway, wouldn't it be better to instead make hostapd take
advantage of my kernel commit d582cffbcd04eae0bd8a83b05648bfd54bfd21c9
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Fri Oct 26 17:53:44 2012 +0200

    nl80211/mac80211: support full station state in AP mode

With that, hostapd/wpa_s can add the station to the kernel, in
unauthenticated state, before sending the authentication frame, and
respond negatively if the addition fails. After auth frame ACK it would
set to authenticated state and then after association set to associated
state. This would also more accurately reflect the state to the driver,
which might be helpful for some drivers.

Additionally, it would go some way towards fixing the race between
station addition and EAPOL RX, I believe there are some scenarios (WSC?
WAPI?) where the station sends the first EAPOL(-equivalent) frame, and
currently stations are added only after transmitting the assoc response,
so that those frames may be dropped erroneously.

johannes

