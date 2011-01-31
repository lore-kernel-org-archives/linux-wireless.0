Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:57257 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756045Ab1AaQCJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 11:02:09 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 17/18] wl1251: enable tx path in monitor mode if necessary for packet injection
References: <4D45A79A.1030102@davizone.at> <4D45B7DC.3060303@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 31 Jan 2011 18:02:06 +0200
In-Reply-To: <4D45B7DC.3060303@davizone.at> (David Gnedt's message of "Sun\, 30 Jan 2011 20\:11\:24 +0100")
Message-ID: <8762t5dptt.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> If necessary enable the tx path in monitor mode for packet injection using
> the JOIN command with BSS_TYPE_STA_BSS and zero BSSID.

Ok, this answers my question, you send TX_ENABLE command during the
first frame transmission. I have to admit that it sounds a bit
hackish. I would prefer to keep the driver as simple as possible,
makes it easier to maintain it that way.

I would like to step back and first look at the problem you are trying
to solve and maybe there's a way we can fix the join command. Was it
something to do with firmware sending extra frames? Unfortunately TI
firmwares are notorious for that.

-- 
Kalle Valo
