Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E0B3C433FE
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Feb 2022 02:33:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237324AbiBWCeB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Feb 2022 21:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237512AbiBWCdJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Feb 2022 21:33:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66275C875;
        Tue, 22 Feb 2022 18:31:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8DD3BB81CA7;
        Wed, 23 Feb 2022 02:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99613C340EB;
        Wed, 23 Feb 2022 02:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645583470;
        bh=Gj0iWRHvzKvEEd9PMj+e/nxm3CPNPPbzzqd6+h5mdpk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UkxdGCOA1BSb1FZYDeps3UPMw9Fz7KOUW5QYv/KW6HM3tGTQgvOb3/n+wW8gazf73
         F6UodAknZm3e5kwiptyJfo4GuYjBwblbghw4rpe7vTTjw8hnbTcMJaff1RyHui3iXm
         NxURPCeB0tKlWSakzJUtEi+EFBYnB4fYVRn/wf2+1J8Rauf5vuXHAdXzpsG9QU3ssf
         9R+ab3mKfDs0uX3uXnyxERRFJM61RB0WQWAohPMFF06dJk5i6InJg6CfDAvqhnwdcV
         scbbokgjg7ko5Egk+AgvvrYgjKXo1fqBFQ286jhFF/7GIG8FF+/p6MK9KomQRARttW
         xpHDCo6id22qw==
Date:   Tue, 22 Feb 2022 20:39:05 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Subject: [PATCH 5/6][next] ath6kl: wmi: Replace one-element array with
 flexible-array  member in struct wmi_disconnect_event
Message-ID: <4a42b591109202589cb1cf87df13daef02eb75f9.1645583264.git.gustavoars@kernel.org>
References: <cover.1645583264.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1645583264.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Replace one-element array with flexible-array member in struct
wmi_disconnect_event.

It's also worth noting that due to the flexible array transformation,
the size of struct wmi_disconnect_event changed (now the size is 1 byte
smaller), and in order to preserve the logic of before the transformation,
the following change is needed:

        -       if (len < sizeof(struct wmi_disconnect_event))
        +       if (len <= sizeof(struct wmi_disconnect_event))

This issue was found with the help of Coccinelle and audited and fixed,
manually.

Link: https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
Link: https://github.com/KSPP/linux/issues/79
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
Hi!

It'd be great if someone can confirm or comment on the following
changes described in the changelog text:

        -       if (len < sizeof(struct wmi_disconnect_event))
        +       if (len <= sizeof(struct wmi_disconnect_event))

Thanks

 drivers/net/wireless/ath/ath6kl/wmi.c | 2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index ccdccead688e..645fb6cae3be 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -1023,7 +1023,7 @@ static int ath6kl_wmi_disconnect_event_rx(struct wmi *wmi, u8 *datap, int len,
 	struct wmi_disconnect_event *ev;
 	wmi->traffic_class = 100;
 
-	if (len < sizeof(struct wmi_disconnect_event))
+	if (len <= sizeof(struct wmi_disconnect_event))
 		return -EINVAL;
 
 	ev = (struct wmi_disconnect_event *) datap;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 6b064e669d87..6a7fc07cd9aa 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -1596,7 +1596,7 @@ struct wmi_disconnect_event {
 	u8 disconn_reason;
 
 	u8 assoc_resp_len;
-	u8 assoc_info[1];
+	u8 assoc_info[];
 } __packed;
 
 /*
-- 
2.27.0

