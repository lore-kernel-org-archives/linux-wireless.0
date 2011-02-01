Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:36575 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab1BAWfE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 17:35:04 -0500
To: David Gnedt <david.gnedt@davizone.at>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: Re: [PATCH 11/18] wl1251: configure hardware en-/decryption for monitor mode
References: <4D45A5DE.70507@davizone.at> <87ipx5dqom.fsf@purkki.adurom.net>
	<4D473E9A.9050106@davizone.at>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 02 Feb 2011 00:35:00 +0200
In-Reply-To: <4D473E9A.9050106@davizone.at> (David Gnedt's message of "Mon\, 31 Jan 2011 23\:58\:34 +0100")
Message-ID: <87oc6vbcyz.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David Gnedt <david.gnedt@davizone.at> writes:

> Am 2011-01-31 16:43, schrieb Kalle Valo:
>>> Disable hardware encryption (DF_ENCRYPTION_DISABLE) and decryption
>>> (DF_SNIFF_MODE_ENABLE) via wl1251_acx_feature_cfg while monitor interface is
>>> present.
>> 
>> Why? To be able to receive encrypted frames when associated or
>> something else?
>
> DF_SNIFF_MODE_ENABLE is set for receiving encrypted frames when associated.
> DF_ENCRYPTION_DISABLE is set to allow packet injection at all, as my testing
> showed that disabling encryption per-packet doesn't work.

But doesn't this break the case when you are connected to a network
with encryption and you have a separate monitor interface at the same
time? Or even worse, as Johannes pointed out, will the frames sent
unencrypted?

-- 
Kalle Valo
