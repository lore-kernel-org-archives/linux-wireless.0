Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from foss.arm.com ([217.140.101.70]:54186 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754973AbcL0Sww (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Dec 2016 13:52:52 -0500
From: Mark Rutland <mark.rutland@arm.com>
To: linux-kernel@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com, kvalo@codeaurora.org,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        netdev@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/2] ath9k: kill of ACCESS_ONCE() in MAC drivers
Date: Tue, 27 Dec 2016 18:49:57 +0000
Message-Id: <1482864599-19995-1-git-send-email-mark.rutland@arm.com> (sfid-20161227_195310_848261_CA2F8FF0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For several reasons, it would be beneficial to kill off ACCESS_ONCE()
tree-wide, in favour of {READ,WRITE}_ONCE(). These work with aggregate
types, more obviously document their intended behaviour, and are
necessary for tools like KTSAN to work correctly (as otherwise reads and
writes cannot be instrumented separately).

While it's possible to script a tree-wide conversion using Coccinelle,
some cases such as the ath9k MAC drivers require some manual
intervention to ensure that the resulting code remains legible. This
series moves the ath9k MAC drivers over to {READ,WRITE}_ONCE(). In both
cases this is functionally equivalent to the below Coccinelle script
being applied, though the existing formatting is retained.

----
virtual patch

@ depends on patch @
expression E1, E2;
@@

- ACCESS_ONCE(E1) = E2
+ WRITE_ONCE(E1, E2)

@ depends on patch @
expression E;
@@

- ACCESS_ONCE(E)
+ READ_ONCE(E)
----

Thanks,
Mark.

Mark Rutland (2):
  ath9k: ar9002_mac: kill off ACCESS_ONCE()
  ath9k: ar9003_mac: kill off ACCESS_ONCE()

 drivers/net/wireless/ath/ath9k/ar9002_mac.c | 64 ++++++++++----------
 drivers/net/wireless/ath/ath9k/ar9003_mac.c | 92 ++++++++++++++---------------
 2 files changed, 78 insertions(+), 78 deletions(-)

-- 
2.7.4
