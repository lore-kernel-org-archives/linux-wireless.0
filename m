Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53425 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346AbZBTSf4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Feb 2009 13:35:56 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH 0/6] b43: Use spatch to convert register accesses
Date: Fri, 20 Feb 2009 19:19:15 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200902201854.22114.mb@bu3sch.de> (sfid-20090220_193600_338639_966D5D8B)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some time ago I rejected a bunch of patches that converted the
PHY/radio register accesses to the new API. That was due to the patches
being created manually. This introduces a huge potential to add new bugs.

However, this is an excellent task for coccinelle/spatch.
So here's a series of patches, to convert the API usage, that were generated
with spatch. This should keep the chances of breaking something as low as possible.

This reduces the .ko size by about 6 kiB.

The used semantic patches will be included in the patch headers.

John, please queue these patches for the next feature release.

-- 
Greetings, Michael.
