Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:30972 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256AbYJ0O1Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 10:27:25 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2158157rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 27 Oct 2008 07:27:24 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18693.53054.116942.355275@localhost.localdomain> (sfid-20081027_152731_505123_42BF3958)
Date: Mon, 27 Oct 2008 19:55:02 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [RFC] mac80211: Re-enable aggregation
In-Reply-To: <1224773201.6002.35.camel@johannes.berg>
References: <18684.16351.638713.791015@gargle.gargle.HOWL>
	<18684.18492.94865.480736@gargle.gargle.HOWL>
	<1224493957.18024.47.camel@johannes.berg>
	<18684.20459.335157.171344@gargle.gargle.HOWL>
	<1224495531.18024.55.camel@johannes.berg>
	<18684.24323.743610.871307@gargle.gargle.HOWL>
	<1224505349.27899.17.camel@johannes.berg>
	<18684.51206.771543.514682@localhost.localdomain>
	<1ba2fa240810201446x429e0b5aud3f20e2fadb19f1@mail.gmail.com>
	<1224669827.28639.54.camel@johannes.berg>
	<1ba2fa240810220459m1dcffd24k58cf6b72c688913c@mail.gmail.com>
	<1224696170.30459.12.camel@johannes.berg>
	<18688.15460.336059.400706@gargle.gargle.HOWL>
	<1224773201.6002.35.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> We have this "ampdu_ack_map" parameter in the TX status which could be
> set by the driver. But that assumes we only want a single TX status for
> all A-MPDU frames, do we really? Or do we want to split them up and
> handle it all in mac80211?

I wasn't aware of this parameter at all. Looks useful.

Atheros HW reports the Block Ack bitmap of the entire aggregate.
So passing that up to mac80211, and letting mac80211 handle retransmissions would work.
I am not sure about Intel.

Sujith

