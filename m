Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:36866 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372Ab3CPSTb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:31 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 01/25] rt2800: do not crash if spec->channels is NULL
Date: Sat, 16 Mar 2013 19:19:29 +0100
Message-Id: <1363457993-15541-2-git-send-email-stf_xl@wp.pl> (sfid-20130316_191935_566607_C9242F13)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

In case the spec->channels was not specified, print warning instead
of hard crash the kernel.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a658b4b..182e598 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -5213,6 +5213,9 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 		spec->channels = rf_vals_3x;
 	}
 
+	if (WARN_ON_ONCE(!spec->channels))
+		return -ENODEV;
+
 	/*
 	 * Initialize HT information.
 	 */
-- 
1.7.4.4

