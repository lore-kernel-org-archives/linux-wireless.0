Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99607C282C4
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 19:06:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66369218D3
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 19:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549566395;
	bh=SrI+UkKmM8ViKNKzUoYpm11/pnksSPr7YRdHRNABJF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=nUjnxR5hXi6GfPStgOJFpGY+ohdW+4+x4AZojZBb1Jh8DUph1tN1ngK3LsEiGGVf9
	 JAnToNurjPdXoAS6sDLjFDqikizq+NPufGa+rSIIITeKEVXGiwA+818qHZRHzv/558
	 q8rnTLiYyQRZhh51aS8VwIyv5BWpCQr2574a+A1U=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727073AbfBGTG3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 14:06:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:38246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726774AbfBGTGI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 14:06:08 -0500
Received: from garbanzo.lan (c-73-71-40-85.hsd1.ca.comcast.net [73.71.40.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8E5021916;
        Thu,  7 Feb 2019 19:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549566367;
        bh=SrI+UkKmM8ViKNKzUoYpm11/pnksSPr7YRdHRNABJF4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qlhdrDuqT9gVySgPEgiNEf9dgsMcuxEoMsKOKqChNfnogEzUSHQ4HX9AVQndZ5iKg
         /x6WHEPFt/aBtAEi5LvYx+GV6pNwOuSpqOnuCBdB1Scpw4INW0VeWVrguZaOz5k6AC
         eWHTiISJqVBA9JdyvswUQZSIrm6ivyfyeJR/9ji4=
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
Subject: [PATCH 1/3] Revert "selftests: firmware: add CONFIG_FW_LOADER_USER_HELPER_FALLBACK to config"
Date:   Thu,  7 Feb 2019 11:06:00 -0800
Message-Id: <20190207190602.502-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20190207190602.502-1-mcgrof@kernel.org>
References: <20190207190602.502-1-mcgrof@kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

This reverts commit 7492902e8d22b568463897fa967c0886764cf034.

The commit tried to address an issue discovered by Dan where he got
a message saying:

'usermode helper disabled so ignoring test'.

Dans's commit is forcing CONFIG_FW_LOADER_USER_HELPER_FALLBACK but just
having CONFIG_FW_LOADER_USER_HELPER suffices to emulate the_FALLBACK
functionality.

Dan's commit is trying to fix an issue which is hidden from a previous
commit. That issue will be addressed properly next.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 tools/testing/selftests/firmware/config | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/firmware/config b/tools/testing/selftests/firmware/config
index 913a25a4a32b..bf634dda0720 100644
--- a/tools/testing/selftests/firmware/config
+++ b/tools/testing/selftests/firmware/config
@@ -1,6 +1,5 @@
 CONFIG_TEST_FIRMWARE=y
 CONFIG_FW_LOADER=y
 CONFIG_FW_LOADER_USER_HELPER=y
-CONFIG_FW_LOADER_USER_HELPER_FALLBACK=y
 CONFIG_IKCONFIG=y
 CONFIG_IKCONFIG_PROC=y
-- 
2.18.0

