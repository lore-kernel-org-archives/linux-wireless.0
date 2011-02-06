Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:60702 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1BFOFS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 09:05:18 -0500
Message-ID: <4D4EAA97.90709@davizone.at>
Date: Sun, 06 Feb 2011 15:05:11 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: Kalle Valo <kvalo@adurom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 11/18] wl1251: configure hardware en-/decryption for monitor
 mode
References: <4D45A5DE.70507@davizone.at> <87ipx5dqom.fsf@purkki.adurom.net>	<4D473E9A.9050106@davizone.at> <87oc6vbcyz.fsf@purkki.adurom.net>
In-Reply-To: <87oc6vbcyz.fsf@purkki.adurom.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 2011-02-01 23:35, schrieb Kalle Valo:
> But doesn't this break the case when you are connected to a network
> with encryption and you have a separate monitor interface at the same
> time? Or even worse, as Johannes pointed out, will the frames sent
> unencrypted?

If you add a monitor interface, it will break associated (encryption enabled)
managed interfaces (until mac80211 tries to reassociate). Nevertheless it
shouldn't send out unencrypted frames because of the added check in tx.c.

I couldn't find any mac80211 API function to renegotiate hw encryption, so I
originally did an awful hack to force reassociation on the managed interface. I
haven't included that patch in this patchset.

By the way I forgot that DF_SNIFF_MODE_ENABLE is also necessary for receiving
encrypted frames, which can't be decrypted in firmware (else they would be
corrupted).
