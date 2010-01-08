Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from www.piware.de ([213.9.93.70]:34578 "EHLO mail.piware.de"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab0AHRnh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jan 2010 12:43:37 -0500
Date: Fri, 8 Jan 2010 18:32:48 +0100
From: Martin Pitt <martin.pitt@ubuntu.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, mb@bu3sch.de,
	stefano.brivio@polimi.it, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] b43: Declare all possible firmware files.
Message-ID: <20100108173248.GB2546@piware.de>
References: <20100107183517.A322FF88D8@sepang.rtg.net>
 <4B463088.1020000@lwfinger.net>
 <4B4633CE.30906@canonical.com>
 <4B46367F.2020306@lwfinger.net>
 <4B463953.1030806@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4B463953.1030806@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tim Gardner [2010-01-07 12:43 -0700]:
> AFAIK Jockey only needs to be able to tell if _any_ of the firmware
> files have been installed and could therefore make an install decision
> based on just one firmware file name.

Correct.

> Martin - if thats the case, then we need only list one firmware file in
> the modinfo, correct?

Right. If that's not practical to fix on the kernel side for some
reason, we could also put in a quirk into the Broadcom handler in
update-notifier. (Right now it just listens for FIRMWARE subsystem
uevents and checksc if the value of it exists as a file).

This was originally introduced for the DVB-T driver firmware packages,
but if we could make it work for b43 as well, this would be nice.

Thanks!

Martin
