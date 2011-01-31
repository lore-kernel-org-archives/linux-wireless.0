Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:49632 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756743Ab1AaW6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 17:58:42 -0500
Message-ID: <4D473E9A.9050106@davizone.at>
Date: Mon, 31 Jan 2011 23:58:34 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 11/18] wl1251: configure hardware en-/decryption for monitor
 mode
References: <4D45A5DE.70507@davizone.at> <87ipx5dqom.fsf@purkki.adurom.net>
In-Reply-To: <87ipx5dqom.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 2011-01-31 16:43, schrieb Kalle Valo:
>> Disable hardware encryption (DF_ENCRYPTION_DISABLE) and decryption
>> (DF_SNIFF_MODE_ENABLE) via wl1251_acx_feature_cfg while monitor interface is
>> present.
> 
> Why? To be able to receive encrypted frames when associated or
> something else?

DF_SNIFF_MODE_ENABLE is set for receiving encrypted frames when associated.
DF_ENCRYPTION_DISABLE is set to allow packet injection at all, as my testing
showed that disabling encryption per-packet doesn't work.
