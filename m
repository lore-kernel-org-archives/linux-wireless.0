Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:41325 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752692AbZBYAt7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Feb 2009 19:49:59 -0500
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=iso-8859-1
Date: Wed, 25 Feb 2009 01:49:55 +0100
From: "Alina Friedrichsen" <x-alina@gmx.net>
In-Reply-To: <1235439633.4455.33.camel@johannes.local>
Message-ID: <20090225004955.227080@gmx.net> (sfid-20090225_015003_659829_97B88D6E)
MIME-Version: 1.0
References: <20090221231800.227280@gmx.net>	
 (sfid-20090222_001831_559891_2537405E)
 <1235439633.4455.33.camel@johannes.local>
Subject: Re: [PATCH v3] mac80211: Give it some time to do the TSF sync
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Johannes!

> Please elaborate on what this does. This uses the assumption that
> reset_tsf() makes it start at 0, and that then the hardware won't syn=
c
> up until N seconds etc.

The ath5k and ath9k drivers do so. If a driver/hardware don't, it cause=
s other problems. For example ("iwconfig wlan0 essid new_ibss") if the =
sync isn't done before the first beacon is send and the TSF of the old =
IBSS-Network was higher the the TSF of the new one, so the all nodes of=
 the new network now sync to the higher TSF of the old network.

Regards
Alina

--=20
Computer Bild Tarifsieger! GMX FreeDSL - Telefonanschluss + DSL
f=FCr nur 17,95 =BF/mtl.!* http://dsl.gmx.de/?ac=3DOM.AD.PD003K11308T45=
69a
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
