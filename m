Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:54841 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab0JTUwi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 16:52:38 -0400
Subject: Re: [PATCH] ssb: Clear RETRY_TIMEOUT in PCI Configuration for
 normal devices
From: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W Linville <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org, linux-wireless@vger.kernel.org
In-Reply-To: <4cbf03d5.sBoVK5FZiEsbJ8xu%Larry.Finger@lwfinger.net> (sfid-20101020_165935_779270_769119B3)
References: <4cbf03d5.sBoVK5FZiEsbJ8xu%Larry.Finger@lwfinger.net>
	 (sfid-20101020_165935_779270_769119B3)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 20 Oct 2010 22:52:21 +0200
Message-ID: <1287607941.2023.1.camel@maggie>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-10-20 at 09:59 -0500, Larry Finger wrote: 
> The previous patch of this type fixed the case where a PCI device is behind
> an SSB->PCI bridge as found on an embedded device. This one treats the normal
> case of a "normal" Broadcom wireless PCI core on an SSB interconnect.

Note that the other patch is not needed anymore, if this is applied.

Also note that this patch will also have an effect on b44 hardware.
Do we want that?

> MMIO log traces obtained using the Broadcom wl hybrid driver show that
> the RETRY_TIMEOUT register (0x41) in PCI configuration space is cleared
> if non-zero. Similar code found in other drivers such as ipw2100 show
> this operation is needed to keep PCI Tx retries from interfering with
> C3 CPU state. There are no known cases where omission of this code has
> caused a problem, but this patch is offered just in case such a situation
> occurs.

-- 
Greetings Michael.

