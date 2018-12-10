Return-Path: <SRS0=yVm+=OT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00F1DC5CFFE
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 20:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6C6920821
	for <linux-wireless@archiver.kernel.org>; Mon, 10 Dec 2018 20:40:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B6C6920821
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arndb.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729314AbeLJUkA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 10 Dec 2018 15:40:00 -0500
Received: from mout.kundenserver.de ([212.227.126.131]:54873 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727598AbeLJUkA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Dec 2018 15:40:00 -0500
Received: from wuerfel.lan ([109.192.41.194]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MiMIY-1h8HGH1VCw-00fWBg; Mon, 10 Dec 2018 21:39:47 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sara Sharon <sara.sharon@intel.com>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Lior Cohen <lior2.cohen@intel.com>,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: fix false-positive maybe-uninitialized warning
Date:   Mon, 10 Dec 2018 21:39:06 +0100
Message-Id: <20181210203945.2147135-1-arnd@arndb.de>
X-Mailer: git-send-email 2.18.0
X-Provags-ID: V03:K1:O/jKqBh1BL1p5TCwdbxUlYQTDOi/eGS8hsSGhgVOJ3Hb2mqCxtZ
 sDu/MKNTk2oKcaWhF/gOxcQtpTJ0wIq2If56JTi1mxXA8j5APMt59ZrDWlTga4NYUAT4+3W
 8IfjbckCL1/Le77pS4a1h+et4r8BKUK0ZQDbEbrvrCRKbHJedZEJOT4X8wSMsyW+fhWFlqz
 22f8lgD9TCv0iI7NqNJJQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gm+OUDBcYAo=:xHdWXU3ZePBqCxTGkWAdpy
 huhsvYIqIuzHqGxzKKN+2hCDNJ3/VTEJ3S0ELXH++umaoSo9oTHbaEKwBBrlW69EpeCHxAjZY
 +/wwhsGC4yLpqVGs/nJH2dqXyQl4flPLQNyF3AWhnoSjxBZamtCKCKtfpl771k0ojn4Vdz2+l
 XLhknLrmtbzHJBPj5fUzYtGUun1QBwqwKrQ0nxc6R9TFyUV1BuADzvF9CYiy/MJmfwjKIPxPf
 yMjeKkwiF403jcZDknkGFaxDlsAQIdGYqYx4h9LjkediBiMhJfPe3zh50BUnY0ItKbA6OYe0O
 EzIVVE1cTFM/ejHo4l/NK9Av5w4N3Uk2ekH/0AGBXiRHXIQgwDb6GJiNdaZpynXcRKSW5Pm1o
 zcUIBUFyXugMXBIEavfKAyF95TvRucznTI79nG4uI5m03F3u2waVgVyEnUpI0JVzBawElp9WT
 XUgBm2fHTvOkm0+d/cBhICun9XixekYBC7cX286XFo2LJMCI3xBOzdLwcNdqeCrVXyQ6JuWbT
 A2bFsKw/ZOAnAiZc0hHA6STJHW0XBnnEtE3O0Ixz3kEkCKgsEjRjPOxcyHSCZvlYmQWCRWlOJ
 8125dGvr33F+giiASqNVojTb6y8/2tlGU4DWjiSvF7+4eBMriZcJb3nY4H79GRzSl2C1mUAt/
 40XsLDUilVdFSkt7RZ2iMoZjQpa2pXWIAplokTHVaU3VO9HywxU623G2ohYo1f8Du93cFk6/B
 Lv4y9tAH4aQiVeACfD5ErZY4WMOxFtONj2FMew==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

With CONFIG_NO_AUTO_INLINE, we run into a silly warning when
gcc fails to remember that n_profiles is constant across
the function call to iwl_mvm_sar_set_profile:

drivers/net/wireless/intel/iwlwifi/mvm/fw.c: In function 'iwl_mvm_sar_get_ewrd_table':
drivers/net/wireless/intel/iwlwifi/mvm/fw.c:746:9: error: 'ret' may be used uninitialized in this function [-Werror=maybe-uninitialized]

Marking that function 'inline' avoids the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index c5168abe107c..07676408146b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -629,10 +629,10 @@ static int iwl_mvm_config_ltr(struct iwl_mvm *mvm)
 }
 
 #ifdef CONFIG_ACPI
-static int iwl_mvm_sar_set_profile(struct iwl_mvm *mvm,
-				   union acpi_object *table,
-				   struct iwl_mvm_sar_profile *profile,
-				   bool enabled)
+static inline int iwl_mvm_sar_set_profile(struct iwl_mvm *mvm,
+					   union acpi_object *table,
+					   struct iwl_mvm_sar_profile *profile,
+					   bool enabled)
 {
 	int i;
 
-- 
2.18.0

