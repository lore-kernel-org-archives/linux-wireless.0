Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57180 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969Ab0KTRBS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 12:01:18 -0500
Received: by yxf34 with SMTP id 34so3329448yxf.19
        for <linux-wireless@vger.kernel.org>; Sat, 20 Nov 2010 09:01:18 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 20 Nov 2010 17:01:16 +0000
Message-ID: <AANLkTimvn-S9WaaCFNsGYzJT8GDu1Ky=2LR2fw6PPjd8@mail.gmail.com>
Subject: libertas cfg80211 support causes slab corruption
From: Daniel Drake <dsd@laptop.org>
To: hs4233@mail.mn-solutions.de
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The following commit causes slab corruption:

commit ff9fc791940f9ff51387c35f9332efe5007154f1
Author: Holger Schurig <hs4233@mail.mn-solutions.de>
Date:   Tue Oct 6 16:31:54 2009 +0200

    libertas: first stab at cfg80211 support



Can be easily reproduced with SLAB (not SLUB) with CONFIG_DEBUG_SLAB.

Load libertas_sdio. No need to bring the interface up or scan or
anything. Unload the module. wait a couple of seconds, and:

[   30.043335] Slab corruption: size-16384 start=eb728000, len=16384
[   30.049661] 270: 6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b 6b

(note that you may see another single-byte of slab corruption in
addition to the above. revert the patch mentioned at
http://lists.infradead.org/pipermail/libertas-dev/2010-November/003352.html
before testing)

Any ideas?

Thanks,
Daniel
