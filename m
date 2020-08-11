Return-Path: <SRS0=WbHW=BV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 180BCC433DF
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Aug 2020 14:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEEDD20716
	for <linux-wireless@archiver.kernel.org>; Tue, 11 Aug 2020 14:02:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QsiLhW8J"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgHKOCc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 11 Aug 2020 10:02:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:50578 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728767AbgHKOCa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Aug 2020 10:02:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597154548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=SgyJE5z7EIbqui8zp079gmXNR4ujowSS+mR+zDN1ANU=;
        b=QsiLhW8JaxALncazUpZEzs24UZ1oGyLPyNPb2qnO0NwkqRczl2WZrQ2nk0v10VJ+wU5Z04
        lxvZgH4P/qrvzCJIXlHfgetVOFum9BNJGoC0jcidWk5HH5eWyTovQruUU2tvzQbB69Fvaw
        kWQQEBEgcKhRkoVTrpv1p+Y85cexLd4=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-bByH-ihGPUqMaTjk2Qc6-g-1; Tue, 11 Aug 2020 10:02:27 -0400
X-MC-Unique: bByH-ihGPUqMaTjk2Qc6-g-1
Received: by mail-qv1-f71.google.com with SMTP id f1so9684049qvx.13
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2020 07:02:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=SgyJE5z7EIbqui8zp079gmXNR4ujowSS+mR+zDN1ANU=;
        b=tli5bYj8C//xMTD1BDu6+eMtIf1jHJTyWkBYa0N8q2BInMlmIG0nF2YA+TdErcITpK
         SIusStz8HYGzR/ly3WB/lKwTJYuHRjOSlfhAPFlZzCLTuYK5PEmQn4pOzf1IudXXlR8O
         xFsObA0mqZzz449tevhEuc1Q4fjPxPgOmDeOBWl7J+7Qgpcf1kamHz0JdwWi7OkRjixV
         lXIdetLlC4/Gti03BgKuD2vxgp7IP+xGr4Ne3NBQgiNFD03AFxJS2MXILe374BOIOStZ
         LhkGRBtAjNXIWPWrUH1X8+q2ObVQK13Vzl0KjJtFVIamrCO3TPJbBb9drn94Oc4m3esM
         5MNw==
X-Gm-Message-State: AOAM530pxWSkgQAznRfzrrMJ15Pm1V6IqU9m3tAzlRNTEuaI6oYx8NCM
        S4YO9KdTwZpwWfDtt3rdWMSzkZOv4lW23onY4Z6MAYLYwIhOHRw4jHfuHNmhruLHlyd64KnfGzS
        APy4xAg+e3OozTdL3pSvDxiqu34g=
X-Received: by 2002:a37:a7cc:: with SMTP id q195mr1308261qke.110.1597154546525;
        Tue, 11 Aug 2020 07:02:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw366l3R5s3TvVY4PxkrGfdyG3vc+gh1kf15sl4qCHXt7bTIdrb6+TrU8ogRMSgvCoM/y7eKA==
X-Received: by 2002:a37:a7cc:: with SMTP id q195mr1308207qke.110.1597154545969;
        Tue, 11 Aug 2020 07:02:25 -0700 (PDT)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id y24sm18891721qtv.71.2020.08.11.07.02.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 07:02:24 -0700 (PDT)
From:   trix@redhat.com
To:     jussi.kivilinna@iki.fi, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH] rndis_wlan: tighten check of rndis_query_oid return
Date:   Tue, 11 Aug 2020 07:02:19 -0700
Message-Id: <20200811140219.8412-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.1
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Tom Rix <trix@redhat.com>

clang static analysis reports this problem

rndis_wlan.c:3147:25: warning: Assigned value is garbage or undefined
                wiphy->max_num_pmkids = le32_to_cpu(caps.num_pmkids);
                                      ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The setting of caps happens here, with a call to rndis_query_oid()

	retval = rndis_query_oid(usbdev,
	if (retval >= 0) {

Reviewing rndis_query_oid() shows that on success 0 is returned,
failure is otherwise.  So the retval check is not tight enough.
So tighten the retval check.  Similar problem in
rndis_wlan_get_caps().

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/wireless/rndis_wlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index 8852a1832951..75b5d545b49e 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -3112,7 +3112,7 @@ static int rndis_wlan_get_caps(struct usbnet *usbdev, struct wiphy *wiphy)
 	retval = rndis_query_oid(usbdev,
 				 RNDIS_OID_802_11_NETWORK_TYPES_SUPPORTED,
 				 &networks_supported, &len);
-	if (retval >= 0) {
+	if (!retval) {
 		n = le32_to_cpu(networks_supported.num_items);
 		if (n > 8)
 			n = 8;
@@ -3137,7 +3137,7 @@ static int rndis_wlan_get_caps(struct usbnet *usbdev, struct wiphy *wiphy)
 	retval = rndis_query_oid(usbdev,
 				 RNDIS_OID_802_11_CAPABILITY,
 				 &caps, &len);
-	if (retval >= 0) {
+	if (!retval) {
 		netdev_dbg(usbdev->net, "RNDIS_OID_802_11_CAPABILITY -> len %d, "
 				"ver %d, pmkids %d, auth-encr-pairs %d\n",
 				le32_to_cpu(caps.length),
-- 
2.18.1

