Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8422BC10F03
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 20:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C07820823
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 20:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbfCDUjl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 15:39:41 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:37963 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbfCDUjl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 15:39:41 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1N2jO8-1h6MTk0psC-01343O; Mon, 04 Mar 2019 21:39:28 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Avraham Stern <avraham.stern@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: fix 64-bit division
Date:   Mon,  4 Mar 2019 21:38:42 +0100
Message-Id: <20190304203924.2111146-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:13EZ5ioXLeca3oDvMvnCC57FRaccHP0KkoFmR49OnkNxuNVJvQc
 41NyjHrRl/9BY5rDFB2nJPGdb1UBSbFSt2I75lD+xL+v5fFZipAXUaSt4xb9nCl82Qd+4JO
 aQiQQNPxErP6jawROrzHXPYSP7HSSvrDM4NzNGFakNCcfO0JbTXvApA6knoFSkCTzVeVLEP
 wvWwscEI8I6R3EGPVptew==
X-UI-Out-Filterresults: notjunk:1;V03:K0:GIf2ikZWptk=:KKmIE00iaWcF6F9QVVLJq7
 6kIsUPRoGhR/C4fBzu3QZRrcS9jRDVmGsq9lUyGgXBZtLLL6xjDgrn1X1OW/eVSfaHpYR5YBR
 g2tyP2c8rEggz9/fkAwbMQ9HJv1p/hx4c5CpfqBqOlio++yce8PHiA3SnXIc/79A5AVWiKIF6
 ph/f67wwzq0qNdL4+K6Jr39TBKfOdODYG2jISqvg7mi0qUaB8xvy5q8rNBW6afmeIXPb9iifo
 8YkziKT8tzFZilVWzEJ2t45be7yJay86mpzRakq46e/BZE+5jvj79wSlk6FI9iZMJYQuiBD3D
 s4OVXPlJ4iXpK6ZQi+yEJgGsVBc4+z4L8Z4zW7jv4/C9s+yipd2eeMqZeLspCYALLBDIQtsTD
 NwYYKYreD5Wl+/KX3dLB4k28lABedVkHhEndMOoHTd3mjjB/7WiP2oaGdX/W8Mzyz2CiTOpyo
 i4AMM38AxofZzQon3dNvq1mHWynZe5733LSXsgyq+qgfTkm0Nk8i5yeDCJQCrGqJFAQqsEVJ2
 lPj1arY5w265+TWzkxaaAzIJnJA9nLabchbn5W1toJvBFvippkcUank9HImSNocGku9f+8p/Q
 i1wEg7lx901Pjtgw7D8YOi5pxhL8/5J1az0Qa4bhl5meGnKKO+6Yym6mLEvZMA4C9D/c1+VPf
 cqmUtFblvJuBH6oW4Hzvp1CySY8Owoy95eVO85MzHh0BDJXbKGz5O+FRiQGSvmwQ7DqyJIr1K
 4KA1lEPM41f3Yarbnx6gZAekQABJZNm80TOvsA==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

do_div() expects unsigned operands and otherwise triggers a warning like:

drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c:465:2: error: comparison of distinct pointer types ('typeof ((rtt_avg)) *' (aka 'long long *') and 'uint64_t *' (aka 'unsigned long long *')) [-Werror,-Wcompare-distinct-pointer-types]
        do_div(rtt_avg, 6666);
        ^~~~~~~~~~~~~~~~~~~~~
include/asm-generic/div64.h:222:28: note: expanded from macro 'do_div'
        (void)(((typeof((n)) *)0) == ((uint64_t *)0));  \
               ~~~~~~~~~~~~~~~~~~ ^  ~~~~~~~~~~~~~~~
1 error generated.

Change the do_div() to the simpler div_s64() that can handle
negative inputs correctly.

Fixes: 937b10c0de68 ("iwlwifi: mvm: add debug prints for FTM")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
index e9822a3ec373..94132cfd1f56 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
@@ -460,9 +460,7 @@ static int iwl_mvm_ftm_range_resp_valid(struct iwl_mvm *mvm, u8 request_id,
 static void iwl_mvm_debug_range_resp(struct iwl_mvm *mvm, u8 index,
 				     struct cfg80211_pmsr_result *res)
 {
-	s64 rtt_avg = res->ftm.rtt_avg * 100;
-
-	do_div(rtt_avg, 6666);
+	s64 rtt_avg = div_s64(res->ftm.rtt_avg * 100, 6666);
 
 	IWL_DEBUG_INFO(mvm, "entry %d\n", index);
 	IWL_DEBUG_INFO(mvm, "\tstatus: %d\n", res->status);
-- 
2.20.0

