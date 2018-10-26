Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C26AECDE44
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 07:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E04CC20834
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 07:28:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E04CC20834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbeJZQEc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 12:04:32 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:54002 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbeJZQEb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 12:04:31 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gFwXs-0004GY-HX; Fri, 26 Oct 2018 09:28:37 +0200
Message-ID: <389c2e4819c83330a3b652f2a45ff024ec94cd2c.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: support FTM responder configuration/statistics
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Date:   Fri, 26 Oct 2018 09:28:15 +0200
In-Reply-To: <765cbdd596e96b7cf73239a4e04b06a7@codeaurora.org>
References: <1538623160-25886-1-git-send-email-pradeepc@codeaurora.org>
         (sfid-20181004_051935_494006_E9A4C858) <c832f9007e0a844d3335a0cd9996818f49df2311.camel@sipsolutions.net>
         <765cbdd596e96b7cf73239a4e04b06a7@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

Actually, I think my suggestion _would_ in fact fix the whole issue.

> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 51622333d460..70d6de29425b 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2934,19 +2934,20 @@ static int 
> ieee80211_start_radar_detection(struct wiphy *wiphy,
>                  memcpy(pos, beacon->probe_resp, beacon->probe_resp_len);
>                  pos += beacon->probe_resp_len;
>          }
> -       if (beacon->ftm_responder)
> +       if (beacon->ftm_responder != -1) {

This doesn't make sense without the change I suggested, since if we
don't do the change I suggested, beacon->ftm_responder will never
actually be -1.

I'd change it like this, fixing the memory overflow bug along the way:

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 51622333d460..818aa0060349 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2891,7 +2891,7 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
 
 	len = beacon->head_len + beacon->tail_len + beacon->beacon_ies_len +
 	      beacon->proberesp_ies_len + beacon->assocresp_ies_len +
-	      beacon->probe_resp_len;
+	      beacon->probe_resp_len + beacon->lci_len + beacon->civicloc_len;
 
 	new_beacon = kzalloc(sizeof(*new_beacon) + len, GFP_KERNEL);
 	if (!new_beacon)
@@ -2934,8 +2934,9 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
 		memcpy(pos, beacon->probe_resp, beacon->probe_resp_len);
 		pos += beacon->probe_resp_len;
 	}
-	if (beacon->ftm_responder)
-		new_beacon->ftm_responder = beacon->ftm_responder;
+
+	/* might copy -1, meaning no changes requested */
+	new_beacon->ftm_responder = beacon->ftm_responder;
 	if (beacon->lci) {
 		new_beacon->lci_len = beacon->lci_len;
 		new_beacon->lci = pos;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 744b5851bbf9..8d763725498c 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -7870,6 +7870,7 @@ static int nl80211_channel_switch(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	memset(&params, 0, sizeof(params));
+	params.beacon_csa.ftm_responder = -1;
 
 	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
 	    !info->attrs[NL80211_ATTR_CH_SWITCH_COUNT])


If that seems good to you I'll submit the patch.

johannes

