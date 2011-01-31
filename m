Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:56644 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1AaPvU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 10:51:20 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 15/18] wl1251: disable power saving in monitor mode
References: <4D45A79E.7040801@davizone.at> <4D45B7D5.2030408@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 31 Jan 2011 17:51:18 +0200
In-Reply-To: <4D45B7D5.2030408@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 20\:11\:17 +0100")
Message-ID: <87ei7tdqbt.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> Force power saving off while monitor interface is present.

Again, why? 

Maybe to avoid dropping frames when associated? That would make sense.
But on the other hand someone might want to have power save enabled
when using monitor mode, for example when debugging power save related
issues.

Nevertheless, I think mac80211 is the correct place to do this, not
the driver.

-- 
Kalle Valo
