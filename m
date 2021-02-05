Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CC82C433DB
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Feb 2021 18:07:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1341164DD4
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Feb 2021 18:07:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233660AbhBEQYv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Feb 2021 11:24:51 -0500
Received: from mout.kundenserver.de ([212.227.17.24]:42709 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbhBEQWN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Feb 2021 11:22:13 -0500
Received: from evilbit.green-communications.fr ([92.154.77.116]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.119]) with ESMTPSA (Nemesis)
 id 1N6svJ-1m0EzP3GSF-018O3Y; Fri, 05 Feb 2021 19:01:44 +0100
From:   Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
To:     seth.forshee@canonical.com
Cc:     wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: [PATCH] wireless-regdb: Do not hardcode 'sforshee' in the certificate commonName
Date:   Fri,  5 Feb 2021 19:00:54 +0100
Message-Id: <20210205180054.1031-1-nicolas.cavallari@green-communications.fr>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:ymhD0qZqklLWUvwlb16UebgKbX/qusgP7xT0Q7xb+o8aqcuNdRc
 FESPXkkADLtcCdDFZN5ELcJJpEQShtxeZDIPCq7EHbr6jpaBHVNBN2huT1+Oh3umdiE9ig1
 YPS+07c8ee//uI2pgWTsas/We5tPrfZX1vLiYCiJ3l8l2IipYiDh/MAWwDo2gwsgiKP542B
 1QsJV7LUn91jBLnsg1DeQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:qEToY0s+9CY=:2RIaRdQcBFix8XlMktlUHo
 RE/KPyPxj6iWFF1+Qckz2KTnOaFASs3RITBV65x1BzjCKdW/kkFFBoK50PovTmsBqRwtsOnJL
 76HROO6bBvPykYN6DOfJp5ZECP2AhgrGVG2Pfex7C+Gv0vWwULViYMaK8DE859vUFS7UbzkCk
 FMHyPoXKQv1Q44ELf9w1rma8/yDEMLfR8Vn4iW1J/ovX4FaSaJ6pkg4VmTdducwQE7FlEunUm
 IQCqiRN+NSEkrMPCB8PQWI/zpmQf/CAtEJNACPoHsjoGF7e8M6gHHN9krhDwvkIk/YHiD7qan
 0ZWYsGZIzt118IkgkFWGMnSHYclzKfxQbrn38cFPanNjRqv8D9QWGIWPtAdGCorhbMD57iUDm
 iPgC95Wl94tBT7R9RSop/PkisOxDtoTrj1se9tXZ/KxdEUWHxsCF3nV2gkhj7lBT53Ea/AHdQ
 dk515HNojOYMv5eCC7k1EyxdXpzOkac=
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

gen-pubcert.sh hardcodes the 'sforshee' common name when generating the
certificate.  Make it depend on REGDB_AUTHOR instead, which defaults to
$(whoami).

Signed-off-by: Nicolas Cavallari <nicolas.cavallari@green-communications.fr>
---
 Makefile       | 2 +-
 gen-pubcert.sh | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 2f1ed93..02176ec 100644
--- a/Makefile
+++ b/Makefile
@@ -80,7 +80,7 @@ $(REGDB_PUBKEY): $(REGDB_PRIVKEY)
 
 $(REGDB_PUBCERT): $(REGDB_PRIVKEY)
 	@echo "Generating certificate for $(REGDB_AUTHOR)..."
-	./gen-pubcert.sh $(REGDB_PRIVKEY) $(REGDB_PUBCERT)
+	./gen-pubcert.sh $(REGDB_PRIVKEY) $(REGDB_PUBCERT) $(REGDB_AUTHOR)
 	@echo $(REGDB_PUBKEY) > .custom
 
 
diff --git a/gen-pubcert.sh b/gen-pubcert.sh
index 1a4d579..a7e8538 100755
--- a/gen-pubcert.sh
+++ b/gen-pubcert.sh
@@ -1,7 +1,7 @@
 #!/bin/bash
 
-if [[ $# -ne 2 ]]; then
-	echo "Usage: $0 priv-key out-file"
+if [[ $# -ne 3 ]]; then
+	echo "Usage: $0 priv-key out-file common-name"
 	exit 1
 fi
 
@@ -13,6 +13,6 @@ openssl req -new -key "$1" -days 36500 -utf8 -nodes -batch \
 		string_mask = utf8only
 		prompt = no
 		[ req_distinguished_name ]
-		commonName = sforshee
+		commonName = $3
 		EOF
 	)
-- 
2.30.0

