Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF178C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 19:06:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A271621928
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 19:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1549566369;
	bh=qQePyKiEXE/Hn7ce6szlMM+ctSmtbkJXzd4bC8GSlF8=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=FcApRkghQN0E5jf9uF7iXy3uyFAO2M1z43aWBGoMysw3YC15teBWMKWOAgMKsaKAp
	 5vwsQ/OdhG9XM1kHkCFV5il1+XQK/QE0HUSpG5SDExfRpCxqPZfacagQrSGcOLHga1
	 OIZKY85Ruhdd0lZewbuT4G3Eexx96BBQmhqh1VFw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726889AbfBGTGI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 14:06:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:38150 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbfBGTGH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 14:06:07 -0500
Received: from garbanzo.lan (c-73-71-40-85.hsd1.ca.comcast.net [73.71.40.85])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C6332175B;
        Thu,  7 Feb 2019 19:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1549566366;
        bh=qQePyKiEXE/Hn7ce6szlMM+ctSmtbkJXzd4bC8GSlF8=;
        h=From:To:Cc:Subject:Date:From;
        b=JO6gzwG6IstErq6Z8Qlu4jrAzHjh7E1I1cpV+F3hgOWyOSpcD4FdQ5fcOD0E1wP2r
         VXvMScriTuzRgX995HnjAaNhf92LIlZ7V0zQ8E8ScAxyy56QiLoQ5bW/B5SSC6TTE2
         P1uO0N/yBum0c73KkWG8d3ckldpjM9jvqrN7HyaU=
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
Subject: [PATCH 0/3] firmware_loader: few selftest fixes
Date:   Thu,  7 Feb 2019 11:05:59 -0800
Message-Id: <20190207190602.502-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.18.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

Greg,

I've found that Dan's patches really broke firmware testing. I've
identified a proper fix for the issue he found, its the last patch. This
series reverts his two patches which break testing, and fixes the issue
he was running into. I leave it to him as exercise to add a busybox bash
quirk for the bash issue he found with diff.

His patches are merged on v5.0-rc1 as such these should go to Linus
tree as well. They are regressions on v5.0-rc1. Please let me know if
there are any questions.

  Luis

Luis Chamberlain (3):
  Revert "selftests: firmware: add CONFIG_FW_LOADER_USER_HELPER_FALLBACK
    to config"
  Revert "selftests: firmware: remove use of non-standard diff -Z
    option"
  selftests: firmware: fix verify_reqs() return value

 tools/testing/selftests/firmware/config           | 1 -
 tools/testing/selftests/firmware/fw_filesystem.sh | 9 ++++++---
 tools/testing/selftests/firmware/fw_lib.sh        | 2 +-
 3 files changed, 7 insertions(+), 5 deletions(-)

-- 
2.18.0

