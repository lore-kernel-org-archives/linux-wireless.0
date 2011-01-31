Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:51465 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751693Ab1AaPws (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 10:52:48 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 16/18] wl1251: fix channel switching in monitor mode
References: <4D45A7A0.5010408@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 31 Jan 2011 17:52:47 +0200
In-Reply-To: <4D45A7A0.5010408@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 19\:02\:08 +0100")
Message-ID: <87aaihdq9c.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> Use the ENABLE_RX command for channel switching when no interface is
> present (monitor mode only). The advantage of ENABLE_RX is that it
> leaves the tx data path disabled in firmware, whereas the usual JOIN
> command seems to transmit some frames at firmware level.

But what about packet injection in that case? Doesn't use ENABLE_RX
make it impossible to inject packets?

-- 
Kalle Valo
