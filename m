Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:47594 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760155Ab3DBIKl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Apr 2013 04:10:41 -0400
Message-ID: <515A9288.3000806@openwrt.org> (sfid-20130402_101050_229027_98915A28)
Date: Tue, 02 Apr 2013 10:10:48 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	John Crispin <blogic@openwrt.org>,
	users@rt2x00.serialmonkey.com
Subject: Re: [PATCH] rt2x00: rt2x00pci: fix build error on Ralink RT3x5x SoCs
References: <1364568747-28907-1-git-send-email-juhosg@openwrt.org> <20130401192414.GE3526@tuxdriver.com>
In-Reply-To: <20130401192414.GE3526@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.04.01. 21:24 keltezéssel, John W. Linville írta:
> I reckon that this is OK, since it is mostly just moving code around
> to satisfy build requirements.  But, it doesn't seem to apply to the
> wireless.git tree...?

Hm, you are right. The patch was based on the master branch of the
wireless-testing tree. It is my fault that I did not try it on wireless.git, sorry.

It fails to apply to the wireless.git tree because it depends on the following
change in wireless-testing.git:

commit 3a703ab5fba5b00292c1e7e964783c304f43fef7
Author: Tim Gardner <tim.gardner@canonical.com>
Date:   Mon Feb 18 12:56:28 2013 -0700

    rt2x00: rt2x00pci_regbusy_read() - only print register access failure once

    BugLink: http://bugs.launchpad.net/bugs/1128840

    It appears that when this register read fails it never recovers, so
    I think there is no need to repeat the same error message ad infinitum.

    Cc: Ivo van Doorn <IvDoorn@gmail.com>
    Cc: Gertjan van Wingerde <gwingerde@gmail.com>
    Cc: Helmut Schaa <helmut.schaa@googlemail.com>
    Cc: "John W. Linville" <linville@tuxdriver.com>
    Cc: linux-wireless@vger.kernel.org
    Cc: users@rt2x00.serialmonkey.com
    Cc: netdev@vger.kernel.org
    Cc: stable@vger.kernel.org
    Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Given the fact that this change is quite simple, it fixes a bug and it is marked
for stable, would it be possible to include that too into wireless.git?

Alternatively, I can rework my patch to be compatible with wireless.git, but
that will cause conflicts with the aforementioned change in wireless-testing.

-Gabor

