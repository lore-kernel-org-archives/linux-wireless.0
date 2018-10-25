Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4378EC46475
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 23:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 001AB20652
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 23:12:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="c6Ui8siX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="c6Ui8siX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 001AB20652
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbeJZHrV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 03:47:21 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38150 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727377AbeJZHrV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 03:47:21 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D6F7360C48; Thu, 25 Oct 2018 23:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540509165;
        bh=yf/AYPLmAYhWTbvomE6+7uB4noskggHD1QGWEftlxLs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c6Ui8siXNz1I+M2s9W3o8MhReiy0Es7EsFciX97X8aere8aV7gOuqaLUwQpuVn/oy
         d+aXF/mUC30PLD6zdpeuf9aXGLGEjjHxUImB9PWG4WOR7nSiuT09BEuPb/cm+h2kLe
         blmugVw0We+XgWBb2EoVhhtFhUy2aVMK5wS2za8g=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 7AC196028B;
        Thu, 25 Oct 2018 23:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540509165;
        bh=yf/AYPLmAYhWTbvomE6+7uB4noskggHD1QGWEftlxLs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c6Ui8siXNz1I+M2s9W3o8MhReiy0Es7EsFciX97X8aere8aV7gOuqaLUwQpuVn/oy
         d+aXF/mUC30PLD6zdpeuf9aXGLGEjjHxUImB9PWG4WOR7nSiuT09BEuPb/cm+h2kLe
         blmugVw0We+XgWBb2EoVhhtFhUy2aVMK5wS2za8g=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 25 Oct 2018 16:12:45 -0700
From:   Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Subject: Re: [PATCH] mac80211: support FTM responder configuration/statistics
In-Reply-To: <c832f9007e0a844d3335a0cd9996818f49df2311.camel@sipsolutions.net>
References: <1538623160-25886-1-git-send-email-pradeepc@codeaurora.org>
 (sfid-20181004_051935_494006_E9A4C858)
 <c832f9007e0a844d3335a0cd9996818f49df2311.camel@sipsolutions.net>
Message-ID: <765cbdd596e96b7cf73239a4e04b06a7@codeaurora.org>
X-Sender: pradeepc@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> 
> I just realized that this is broken in nl80211_channel_switch() and
> ieee80211_set_csa_beacon(), doing a CSA will always disable FTM unless
> it was actually included in the new configuration.
Hi Johannes

oops..Yes, there is a bug in the patch. The code below, I think, must 
fix this issue.
Please let me know your comments..

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 51622333d460..70d6de29425b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2934,19 +2934,20 @@ static int 
ieee80211_start_radar_detection(struct wiphy *wiphy,
                 memcpy(pos, beacon->probe_resp, beacon->probe_resp_len);
                 pos += beacon->probe_resp_len;
         }
-       if (beacon->ftm_responder)
+       if (beacon->ftm_responder != -1) {
                 new_beacon->ftm_responder = beacon->ftm_responder;
-       if (beacon->lci) {
-               new_beacon->lci_len = beacon->lci_len;
-               new_beacon->lci = pos;
-               memcpy(pos, beacon->lci, beacon->lci_len);
-               pos += beacon->lci_len;
-       }
-       if (beacon->civicloc) {
-               new_beacon->civicloc_len = beacon->civicloc_len;
-               new_beacon->civicloc = pos;
-               memcpy(pos, beacon->civicloc, beacon->civicloc_len);
-               pos += beacon->civicloc_len;
+               if (beacon->lci) {
+                       new_beacon->lci_len = beacon->lci_len;
+                       new_beacon->lci = pos;
+                       memcpy(pos, beacon->lci, beacon->lci_len);
+                       pos += beacon->lci_len;
+               }
+               if (beacon->civicloc) {
+                       new_beacon->civicloc_len = beacon->civicloc_len;
+                       new_beacon->civicloc = pos;
+                       memcpy(pos, beacon->civicloc, 
beacon->civicloc_len);
+                       pos += beacon->civicloc_len;
+               }
         }

         return new_beacon;


> 
> Doing the trivial thing:
> 
>  	memset(&params, 0, sizeof(params));
> +	params.beacon_after.ftm_responder = -1;
This would not be needed then.
> 
> in nl80211_channel_switch() will not help because then mac80211 will
> lose all the extra configuration, and will actually store -1 into its
> enabled value which is really strange.
> 
> I'd appreciate if you could take a look at this.
> 
> Thanks,
> johannes
