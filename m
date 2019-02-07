Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A18E6C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 19:06:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F8AD218D3
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 19:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549566376;
	bh=7BG/ivVuXTI84oQ9cTKhJV8pAFjaL1F4tb8KlP/bB/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=sB60b8B8t1QSVOb5GwDUpCvXY/eW4Z590BTQnlVGmeCKKvE5tlt9xENtZeb/z7FU1
	 bcheXDCovDXgxWIBcNWwr8HVKnbohnCy2D5LjdWi+Lv3rNeVF2+JClSDAXVaQGdMTB
	 ZZSsHRxZbY7lyn09JBlwcCApcUl82SeVrZbSb6sY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbfBGTGK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 14:06:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:38270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726902AbfBGTGK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 14:06:10 -0500
Received: from garbanzo.lan (c-73-71-40-85.hsd1.ca.comcast.net [73.71.40.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 212C021919;
        Thu,  7 Feb 2019 19:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549566369;
        bh=7BG/ivVuXTI84oQ9cTKhJV8pAFjaL1F4tb8KlP/bB/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jaZKtHrOAlEJphoKX7oEemvccNru293qge4e7bvpzDldQaLoPAVx+lOue7G74cmiX
         q4Wn8jGHkbO6ywA39jC4mV6wDwOq9rEsasrE/JR+Duy6dDKcXJ9vxfEmNqfXG190QJ
         LuzB+xmlWfSaapa+6El1uG5Qv951pRyofejB7H4Y=
From:   "Luis R. Rodriguez" <mcgrof@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     akpm@linux-foundation.org, josh@joshtriplett.org,
        rishabhb@codeaurora.org, kubakici@wp.pl, maco@android.com,
        andy.gross@linaro.org, david.brown@linaro.org,
        bjorn.andersson@linaro.org, linux-wireless@vger.kernel.org,
        keescook@chromium.org, shuah@kernel.org, mfuzzey@parkeon.com,
        zohar@linux.vnet.ibm.com, dhowells@redhat.com,
        pali.rohar@gmail.com, tiwai@suse.de, arend.vanspriel@broadcom.com,
        zajec5@gmail.com, nbroeking@me.com, markivx@codeaurora.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, dwmw2@infradead.org,
        torvalds@linux-foundation.org, Abhay_Salunke@dell.com,
        jewalt@lgsinnovations.com, cantabile.desu@gmail.com, ast@fb.com,
        andresx7@gmail.com, dan.rue@linaro.org, brendanhiggins@google.com,
        yzaikin@google.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 2/3] Revert "selftests: firmware: remove use of non-standard diff -Z option"
Date:   Thu,  7 Feb 2019 11:06:01 -0800
Message-Id: <20190207190602.502-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190207190602.502-1-mcgrof@kernel.org>
References: <20190207190602.502-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

This reverts commit f70b472e937bb659a7b7a14e64f07308e230888c.

This breaks testing on Debian, and this patch was NACKed anyway.
The proper way to address this is a quirk for busybox as that is
where the issue is present.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 tools/testing/selftests/firmware/fw_filesystem.sh | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/firmware/fw_filesystem.sh b/tools/testing/selftests/firmware/fw_filesystem.sh
index 466cf2f91ba0..a4320c4b44dc 100755
--- a/tools/testing/selftests/firmware/fw_filesystem.sh
+++ b/tools/testing/selftests/firmware/fw_filesystem.sh
@@ -155,8 +155,11 @@ read_firmwares()
 {
 	for i in $(seq 0 3); do
 		config_set_read_fw_idx $i
-		# Verify the contents match
-		if ! diff -q "$FW" $DIR/read_firmware 2>/dev/null ; then
+		# Verify the contents are what we expect.
+		# -Z required for now -- check for yourself, md5sum
+		# on $FW and DIR/read_firmware will yield the same. Even
+		# cmp agrees, so something is off.
+		if ! diff -q -Z "$FW" $DIR/read_firmware 2>/dev/null ; then
 			echo "request #$i: firmware was not loaded" >&2
 			exit 1
 		fi
@@ -168,7 +171,7 @@ read_firmwares_expect_nofile()
 	for i in $(seq 0 3); do
 		config_set_read_fw_idx $i
 		# Ensures contents differ
-		if diff -q "$FW" $DIR/read_firmware 2>/dev/null ; then
+		if diff -q -Z "$FW" $DIR/read_firmware 2>/dev/null ; then
 			echo "request $i: file was not expected to match" >&2
 			exit 1
 		fi
-- 
2.18.0

