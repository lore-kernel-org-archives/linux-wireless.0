Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:40324 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752655AbYHMWso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Aug 2008 18:48:44 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 13 Aug 2008 15:48:44 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <mcgrof@gmail.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Add new regulatory infrastructure
Date: Wed, 13 Aug 2008 15:48:40 -0700
Message-ID: <1218667722-1832-1-git-send-email-lrodriguez@atheros.com> (sfid-20080814_004847_778243_C4140CFB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds the new regulatory infrastructure
with edits and feedback taken into account from our dicussions
at the OLS Linux wireless summit #3, namely:

  * We use udev to communicate to userspace now
  * kmalloc() a regulatory domain structure with one
    call instead of two
  * allow drivers to provide their own built regulatory domain
    structure, without any alpha2 attached to it

To pass regulatory domains to the kernel you need CRDA, which you
can build and install from:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/crda.git

This patch series only adds regulatory_hint() suppor to zd1211rw,
others will come as we go. Letting users set the regulatory
domain will also be added soon through iw.

  Luis
