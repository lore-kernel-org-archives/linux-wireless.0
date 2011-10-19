Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:40420 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721Ab1JSPzk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Oct 2011 11:55:40 -0400
Date: Wed, 19 Oct 2011 11:55:20 -0400
From: Pavel Roskin <proski@gnu.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Joerg Pommnitz <pommnitz@yahoo.com>,
	Bob Copeland <me@bobcopeland.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>
Subject: Re: [ath5k-devel] Performance regression between Madwifi/net80211
 and ath5k/mac80211
Message-ID: <20111019115520.79cfaef8@mj> (sfid-20111019_175543_563437_37F52320)
In-Reply-To: <CAJ-VmokZibCys+9ZLg6yEbauJfbgErbezMcTZ2SjPmR9SMgQ7w@mail.gmail.com>
References: <loom.20110621T215346-191@post.gmane.org>
 <BANLkTik0umam7S+E1oog0LTEErMz-dZamg@mail.gmail.com>
 <1308750102.64154.YahooMailRC@web161214.mail.bf1.yahoo.com>
 <1308750416.29571.10.camel@jlt3.sipsolutions.net>
 <1308753669.17439.YahooMailRC@web161208.mail.bf1.yahoo.com>
 <1308754204.29571.15.camel@jlt3.sipsolutions.net>
 <1308755270.21489.YahooMailRC@web161204.mail.bf1.yahoo.com>
 <BANLkTi=Ob1H7XdG5-21SnjkuyVF9xw+xBA@mail.gmail.com>
 <1319018802.31281.YahooMailNeo@web161205.mail.bf1.yahoo.com>
 <CAJ-VmokZibCys+9ZLg6yEbauJfbgErbezMcTZ2SjPmR9SMgQ7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 19 Oct 2011 19:33:53 +0800
Adrian Chadd <adrian@freebsd.org> wrote:

> .. does madwifi have that net80211 "aggressive mode" by default, where
> it overrides the best-effort WME queue parameters to allow for
> bursting?

I tried madwifi-0.9.4 snapshot on a CM9 card, and I got:

# iwpriv ath0 get_abolt
ath0      get_abolt:218  

218 is 0xda, which means that the following capabilities are enabled:

IEEE80211_ABOLT_TURBO_PRIME
IEEE80211_ABOLT_FAST_FRAME
IEEE80211_ABOLT_BURST
IEEE80211_ABOLT_XR
IEEE80211_ABOLT_AR

And those are not enabled:

IEEE80211_ABOLT_TURBO_G
IEEE80211_ABOLT_COMPRESSION
IEEE80211_ABOLT_WME_ELE

I would just unset all capabilities and retry.

> I see exactly that difference in FreeBSD (33mbit vs 22mbit) when I
> disable that aggressive mode code.

-- 
Regards,
Pavel Roskin
