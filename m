Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50565
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030485AbXBLXYH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Feb 2007 18:24:07 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: d80211: current TKIP hwcrypto implementation seems to be broken
Date: Tue, 13 Feb 2007 00:23:53 +0100
Cc: "Jouni Malinen" <jkm@devicescape.com>, "Jiri Benc" <jbenc@suse.cz>,
	linux-wireless@vger.kernel.org
References: <200702041344.19117.mb@bu3sch.de> <200702122239.31778.mb@bu3sch.de> <1ba2fa240702121515p7edd3682j87070b564cb08897@mail.gmail.com>
In-Reply-To: <1ba2fa240702121515p7edd3682j87070b564cb08897@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200702130023.53271.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 13 February 2007 00:15, Tomas Winkler wrote:
> I fetching this from my "dusty" memory so I hope I'm right about it.
> TKIP phase1 one can be precomputed in advance. There's no runtime

Phase1 key changes on iv32 wrap.

> dependency after key exchange.
> Cached keys can be provided by supplicant. Usually u want to keep 2 or
> 3 cached TKIP phase1 for smooth decryption. As in QoS sequence

Hardware (bcm43xx at least) can only have one key at a time.
There's no point in caching, as phase1 key calculation is cheap
and can be done on-the-run. The expensive part it uploading it to HW.

> counters are kept per AC, you might get into gentle state of receiving
> packets for the old key. If  you hold more then one  phase1 you might
> be able decrypt the packets that doesn't match current phase1 in
> software.

You can generate the new key then. There is no point in wasting memory
by precomputation of the keys.

-- 
Greetings Michael.
