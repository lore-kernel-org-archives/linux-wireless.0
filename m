Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45623 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab0H2LPo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Aug 2010 07:15:44 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH 0/4] wl1271 -> wl1251 port patches
References: <1282074415-6168-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 29 Aug 2010 14:15:41 +0300
In-Reply-To: <1282074415-6168-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Tue\, 17 Aug 2010 22\:46\:51 +0300")
Message-ID: <87y6bp7jqa.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> There are even more wl1271 patches that could be applicable to wl1251.
> Kalle, could you take a look at the list below? I could try porting if
> you think any of those make sense.
>
> Adding disconnect command, it seems to be also used by TI driver:
> 25a7dc6d22adda590be4932ebc772ea35914880c
> c7f43e451ba40e66a89d51e63bc21a57824592f2

This is good to do also in wl1251.

> powersave fail handling:
> 19ad0715d8d9acc259ef02f83df767df2cf1eafe

I don't like the fact that driver handles the retries, I prefer
mac80211 doing all that. But we can do it in the driver first and
later on add support to mac80211.

> not masking interrupts while processing:
> 4aa05917051b01da037a80c3207b48aee252eed2

Looks good to me.

> connection monitoring control:
> 6ccbb92ead9379d7de2cc25cd950d15a8d22e0c9
> a9af092b524614dd3fc7b52bde7c87f8b82cd2a6

AFAIK wl1251 doesn't support this.

> broken ps-poll handling:
> 90494a90bea010af47547880634e0f1c52824a7d

Again I would not like the driver to handle this, too much logic in
the driver for my taste. But maybe again as a first step to do this in
the driver and later on improve mac80211.

> improved queue stopping:
> 06f7bc7db79fabe6b2ec16eff0f59e4acc21eb72

This is important. Denis Carikli already sent a patch for this, but I
haven't tested it yet.

-- 
Kalle Valo
