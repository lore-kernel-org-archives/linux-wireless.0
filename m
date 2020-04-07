Return-Path: <SRS0=LB6b=5X=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB49C2BA1A
	for <linux-wireless@archiver.kernel.org>; Tue,  7 Apr 2020 00:09:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CCB2F2076E
	for <linux-wireless@archiver.kernel.org>; Tue,  7 Apr 2020 00:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586218181;
	bh=qs75tEfOs2fCsYk39M8OgekZWGozE5twqSR4yC7eBIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=oea+2LE+niJ7tnoKejxG+kBKI8A/hi8dl9+3/XJ7IZZQOfm3JrzZjZsZ6JAXB5lyt
	 HCiiavWQdbHdxrYeIFyJGDrwkBqCLImM2M+o/TN8lqa0rOHCBlUW36/OfYqnyScprn
	 v41BXWzcrEV3iX5N3SzMkobC9lzNuMn5YuqPF+Fo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726579AbgDGABH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 6 Apr 2020 20:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbgDGABH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:07 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA63F2078C;
        Tue,  7 Apr 2020 00:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217666;
        bh=qs75tEfOs2fCsYk39M8OgekZWGozE5twqSR4yC7eBIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lk3RsFEMSGM6pW40XdKy8lb3uzIkjVwBmgijaz8k+kdGfw9Q/UCYNfXbg+r6nYxEF
         ZCq0kyEzDjjAQv97ok0ddUm/X15emrjR3baEmenCX9T8NE660BdxusVKnj+Kj3AA5w
         r4CcmOthPDt1q312PVII/vsoCfmDJ47VpBys/v54=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 06/35] iwlwifi: mvm: take the required lock when clearing time event data
Date:   Mon,  6 Apr 2020 20:00:28 -0400
Message-Id: <20200407000058.16423-6-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 089e5016d7eb063712063670e6da7c1a4de1a5c1 ]

When receiving a session protection end notification, the time event
data is cleared without holding the required lock. Fix it.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200306151128.a49846a634e4.Id1ada7c5a964f5e25f4d0eacc2c4b050015b46a2@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index c0b420fe5e48f..1babc4bb5194b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -785,7 +785,9 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 		if (!le32_to_cpu(notif->status)) {
 			iwl_mvm_te_check_disconnect(mvm, vif,
 						    "Session protection failure");
+			spin_lock_bh(&mvm->time_event_lock);
 			iwl_mvm_te_clear_data(mvm, te_data);
+			spin_unlock_bh(&mvm->time_event_lock);
 		}
 
 		if (le32_to_cpu(notif->start)) {
@@ -801,7 +803,9 @@ void iwl_mvm_rx_session_protect_notif(struct iwl_mvm *mvm,
 			 */
 			iwl_mvm_te_check_disconnect(mvm, vif,
 						    "No beacon heard and the session protection is over already...");
+			spin_lock_bh(&mvm->time_event_lock);
 			iwl_mvm_te_clear_data(mvm, te_data);
+			spin_unlock_bh(&mvm->time_event_lock);
 		}
 
 		goto out_unlock;
-- 
2.20.1

