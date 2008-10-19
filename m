Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:20520 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999AbYJSGBh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Oct 2008 02:01:37 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: inform userspace of probe/auth/assoc timeout
References: <1224186284.11127.3.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Sun, 19 Oct 2008 09:01:05 +0300
In-Reply-To: <1224186284.11127.3.camel@johannes.berg> (ext Johannes Berg's message of "Thu\, 16 Oct 2008 21\:44\:44 +0200")
Message-ID: <873ait6s4e.fsf@nokia.com> (sfid-20081019_080201_095183_F64F1E1E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> I noticed that when for some reason [1] the probe or auth times
> out, wpa_supplicant doesn't realise this and only tries the next
> AP when it runs into its own timeout, which is ten seconds, and
> that's quite long. Fix this by making mac80211 notify userspace
> that it didn't associate.

Earlier this week I received an internal bug report about this.
Excellent timing for providing a fix. Thank you, Johannes :)

> Might be worth backporting to stable?

I have to backport the patch anyway so I can provide the patch. But I
don't think this being that important bug to be fixed in stable
series. We have had this bug in mac80211 always, right?

-- 
Kalle Valo
