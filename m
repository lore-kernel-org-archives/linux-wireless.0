Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76E08C04EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 11:25:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EF0D20851
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 11:25:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qg3Wozk1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EF0D20851
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbeLDLAY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 06:00:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:45660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727313AbeLDLAY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 06:00:24 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFA262087F;
        Tue,  4 Dec 2018 11:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1543921223;
        bh=ni+OWb1bl6qqyHm6IZMorifIhmCA5+auQvp+PGDj8lE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qg3Wozk1lvdF4G3XXhMq85TfVesz5T1/IELYVfLe03RO+5noQbBzksL+Uaqdt9MHR
         ws/vwieH6PDbIZRP447wntFsUOkafNqJkiAlRXcwf+24o5ealArJCjzGpxdfWkGOW3
         w72IfAALnkYBCHqrCy4mFyzgZxM/lBw65Kw4gqME=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        youling257 <youling257@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 4.19 129/139] staging: rtl8723bs: Add missing return for cfg80211_rtw_get_station
Date:   Tue,  4 Dec 2018 11:50:10 +0100
Message-Id: <20181204103656.051356146@linuxfoundation.org>
X-Mailer: git-send-email 2.19.2
In-Reply-To: <20181204103649.950154335@linuxfoundation.org>
References: <20181204103649.950154335@linuxfoundation.org>
User-Agent: quilt/0.65
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 8561fb31a1f9594e2807681f5c0721894e367f19 upstream.

With Androidx86 8.1, wificond returns "failed to get
nl80211_sta_info_tx_failed" and wificondControl returns "Invalid signal
poll result from wificond". The fix is to OR sinfo->filled with
BIT_ULL(NL80211_STA_INFO_TX_FAILED).

This missing bit is apparently not needed with NetworkManager, but it
does no harm in that case.

Reported-and-Tested-by: youling257 <youling257@gmail.com>
Cc: linux-wireless@vger.kernel.org
Cc: youling257 <youling257@gmail.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -1277,7 +1277,7 @@ static int cfg80211_rtw_get_station(stru
 
 		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_PACKETS);
 		sinfo->tx_packets = psta->sta_stats.tx_pkts;
-
+		sinfo->filled |= BIT_ULL(NL80211_STA_INFO_TX_FAILED);
 	}
 
 	/* for Ad-Hoc/AP mode */


