Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05757C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 19:06:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C82B421904
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 19:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549566381;
	bh=f6IAsmxcib3626amipBaJwyrzYE00bHxbndnxtncDjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=wxh5d2zudOyIFPuSYwkXqqHevg1od615HeqsvabkE9ezOqupBQG/cndCRNBgS9G5E
	 9PYEsu/LsAbi9i9dNuF+zuIEexjaZiUWodmAOSajeVvv2gP3qrXrCbS6/dS+7Wp8rt
	 lnn6S93cT62ChdKdGG1Pko6lZnZh+wHWLixahY4Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfBGTGQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 14:06:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:38334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbfBGTGL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 14:06:11 -0500
Received: from garbanzo.lan (c-73-71-40-85.hsd1.ca.comcast.net [73.71.40.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CBF321927;
        Thu,  7 Feb 2019 19:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549566370;
        bh=f6IAsmxcib3626amipBaJwyrzYE00bHxbndnxtncDjw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tWlupUSQApHVPoRb4yxPw+dhCh0u9mcZDYg+YYbxtTZG8l7Jwk7wl9MSlCXNWKxc9
         kR3/L2WkCscZkS6Ga6/rNM1QHmyhuxUuz7buayR++VX7p8EOhxk7Gwv5nivwDfnbzH
         jevkl3lvnXh4mnlM24mz12/vUue6Yn+86fYxGoBA=
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
        linux-fsdevel@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, stable@vger.kernel.org
Subject: [PATCH 3/3] selftests: firmware: fix verify_reqs() return value
Date:   Thu,  7 Feb 2019 11:06:02 -0800
Message-Id: <20190207190602.502-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190207190602.502-1-mcgrof@kernel.org>
References: <20190207190602.502-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

commit a6a9be9270c87 ("selftests: firmware: return Kselftest Skip code
for skipped tests") by Shuah modified failures to return the special
error code of $ksft_skip (4). We have a corner case issue where we
*do* want to verify_reqs().

Cc: <stable@vger.kernel.org> # >= 4.18
Fixes: a6a9be9270c87 ("selftests: firmware: return Kselftest Skip code for for skipped tests")
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 tools/testing/selftests/firmware/fw_lib.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/firmware/fw_lib.sh b/tools/testing/selftests/firmware/fw_lib.sh
index 6c5f1b2ffb74..1cbb12e284a6 100755
--- a/tools/testing/selftests/firmware/fw_lib.sh
+++ b/tools/testing/selftests/firmware/fw_lib.sh
@@ -91,7 +91,7 @@ verify_reqs()
 	if [ "$TEST_REQS_FW_SYSFS_FALLBACK" = "yes" ]; then
 		if [ ! "$HAS_FW_LOADER_USER_HELPER" = "yes" ]; then
 			echo "usermode helper disabled so ignoring test"
-			exit $ksft_skip
+			exit 0
 		fi
 	fi
 }
-- 
2.18.0

