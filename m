Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.zhaw.ch ([160.85.104.51]:61872 "EHLO mx2.zhaw.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755912AbZLWNSN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 08:18:13 -0500
From: Tobias Klauser <tklauser@distanz.ch>
To: "John W. Linville" <linville@tuxdriver.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH] iwlwifi: Storage class should be before const qualifier
Date: Wed, 23 Dec 2009 14:18:11 +0100
Message-Id: <1261574291-9384-1-git-send-email-tklauser@distanz.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The C99 specification states in section 6.11.5:

The placement of a storage-class specifier other than at the beginning
of the declaration specifiers in a declaration is an obsolescent
feature.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
index fe511cb..b93e491 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rs.c
@@ -150,7 +150,7 @@ static s32 expected_tpt_mimo3_40MHz[4][IWL_RATE_COUNT] = {
 };
 
 /* mbps, mcs */
-const static struct iwl_rate_mcs_info iwl_rate_mcs[IWL_RATE_COUNT] = {
+static const struct iwl_rate_mcs_info iwl_rate_mcs[IWL_RATE_COUNT] = {
 	{  "1", "BPSK DSSS"},
 	{  "2", "QPSK DSSS"},
 	{"5.5", "BPSK CCK"},
-- 
1.6.3.3

