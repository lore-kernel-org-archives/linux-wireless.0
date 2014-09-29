Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:34621 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbaI2Hzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 03:55:32 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21545.4248.512297.913983@gargle.gargle.HOWL> (sfid-20140929_095539_513131_B805BA78)
Date: Mon, 29 Sep 2014 13:26:08 +0530
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath: Add support for tracing
In-Reply-To: <87r3yu3oje.fsf@kamboji.qca.qualcomm.com>
References: <1411804665-6954-1-git-send-email-sujith@msujith.org>
	<87vbo72bb7.fsf@kamboji.qca.qualcomm.com>
	<21544.64579.558712.465388@gargle.gargle.HOWL>
	<87r3yu3oje.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> You mean ath_printk() & friends? But that doesn't require tracing code
> to be in ath.ko as well, right? If I understood correctly, trace.c could
> be under ath9k directory and the kconfig option could be
> ATH9K_TRACEPOINTS.
> 
> I think it's just misleading and confusing for the user to call it
> "Atheros wireless tracing" when it only affects ath9k. It's easier to
> understand if each driver has it's own "tracing" kconfig option.

We have CONFIG_ATH_DEBUG, which is used by ath9k and ath9k_htc.
I think it is okay to have CONFIG_ATH_TRACEPOINTS, which can be
used by ath9k/ath9k_htc too.

The original motive of ath.ko was to have a common module with
debugging facilities that can be shared by Atheros drivers. But,
each driver has ended up reinventing things. Since it is mentioned
in the help text that ath9k is the only driver making use of
ATH_DEBUG/ATH_TRACEPOINTS, I don't think it is confusing.

Sujith
