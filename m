Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED89AC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:33:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5C7E2146F
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 09:33:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NGdarJyN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="M4j9lctT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726041AbfBKJd5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 04:33:57 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:37002 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbfBKJd5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 04:33:57 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 192A3605FC; Mon, 11 Feb 2019 09:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549877636;
        bh=oifOcT/9F65h7tcMn4uf0CwZ8XqFZNVGfLdx3smeDFo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NGdarJyNVTc5bwkQBr4vor97B2+2JQ2MjeaY/WoNS7dhHmaRMyN36vDI/0TEMUKJG
         NwCyRFRD5EnmCiXwmIdBD/Zjf0uBihUCcmG/ToSn9HH5mabyZxXjEnS8bCqrf7JB1v
         6ihBbZJ8u/1KeQtRZsl4wqFKWU3P0KzngOJkr8s4=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 5112E601CF;
        Mon, 11 Feb 2019 09:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1549877635;
        bh=oifOcT/9F65h7tcMn4uf0CwZ8XqFZNVGfLdx3smeDFo=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=M4j9lctT1OKXdTyMaeois1Hhj3TeGtdGPTZbEjQBrK6R5+6Yy/arxqVEeuA8Ytgz/
         qqtkSNkc0/AFnKctfvnHvqrY7STPEdp8fhAYZA1CcYRBcX1LY/jPPKZkycJjFH1BXq
         XhHtdL6GShL13HZISnh4gv1sqQc1f1vTMXUOJjnA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 5112E601CF
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath10k: report tx airtime provided by fw
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1542298483-15879-1-git-send-email-mpubbise@codeaurora.org>
References: <1542298483-15879-1-git-send-email-mpubbise@codeaurora.org>
To:     Manikanta Pubbisetty <mpubbise@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190211093356.192A3605FC@smtp.codeaurora.org>
Date:   Mon, 11 Feb 2019 09:33:55 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Manikanta Pubbisetty <mpubbise@codeaurora.org> wrote:

> If supported, update transmit airtime in mac80211 with the airtime
> values reported by the firmware. TX airtime of the PPDU is reported
> via HTT data TX completion indication message.
> 
> A new service flag 'WMI_SERVICE_REPORT_AIRTIME' is added to advertise
> the firmware support. For firmwares which do not support this feature,
> TX airtime is calculated in the driver using TX bitrate.
> 
> Hardwares tested : QCA9984
> Firmwares tested : 10.4-3.6.1-00841
> 
> Signed-off-by: Manikanta Pubbisetty <mpubbise@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

I had some conflicts, please carefully check my resolution in the pending branch:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=pending&id=1baca5592c99c9d61924956c56c620d371b61d96

$ git am -s --reject 10684687.mbox
Applying: ath10k: report tx airtime provided by fw
Checking patch drivers/net/wireless/ath/ath10k/core.c...
Hunk #1 succeeded at 2631 (offset 32 lines).
Checking patch drivers/net/wireless/ath/ath10k/htt.h...
Hunk #1 succeeded at 571 (offset 7 lines).
Hunk #2 succeeded at 584 (offset 7 lines).
Hunk #3 succeeded at 877 (offset 7 lines).
Checking patch drivers/net/wireless/ath/ath10k/htt_rx.c...
Hunk #1 succeeded at 2220 (offset 217 lines).
Hunk #2 succeeded at 2249 (offset 217 lines).
Hunk #3 succeeded at 2286 (offset 217 lines).
Checking patch drivers/net/wireless/ath/ath10k/mac.c...
Hunk #1 succeeded at 4007 (offset 40 lines).
error: while searching for:
                wiphy_ext_feature_set(ar->hw->wiphy,
                                      NL80211_EXT_FEATURE_ACK_SIGNAL_SUPPORT);

        if (ath10k_peer_stats_enabled(ar))
                wiphy_ext_feature_set(ar->hw->wiphy,
                                      NL80211_EXT_FEATURE_AIRTIME_FAIRNESS);
        /*

error: patch failed: drivers/net/wireless/ath/ath10k/mac.c:8615
Checking patch drivers/net/wireless/ath/ath10k/txrx.c...
Checking patch drivers/net/wireless/ath/ath10k/wmi.h...
error: while searching for:
        WMI_SERVICE_SPOOF_MAC_SUPPORT,
        WMI_SERVICE_TX_DATA_ACK_RSSI,
        WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,

        /* keep last */
        WMI_SERVICE_MAX,

error: patch failed: drivers/net/wireless/ath/ath10k/wmi.h:205
error: while searching for:
        WMI_10_4_SERVICE_PEER_TID_CONFIGS_SUPPORT,
        WMI_10_4_SERVICE_VDEV_BCN_RATE_CONTROL,
        WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
};

static inline char *wmi_service_name(int service_id)

error: patch failed: drivers/net/wireless/ath/ath10k/wmi.h:359
error: while searching for:
        SVCSTR(WMI_SERVICE_RESET_CHIP);
        SVCSTR(WMI_SERVICE_TX_DATA_ACK_RSSI);
        SVCSTR(WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT);
        default:
                return NULL;
        }

error: patch failed: drivers/net/wireless/ath/ath10k/wmi.h:474
error: while searching for:
               WMI_SERVICE_TX_DATA_ACK_RSSI, len);
        SVCMAP(WMI_10_4_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT,
               WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT, len);
}

#undef SVCMAP

error: patch failed: drivers/net/wireless/ath/ath10k/wmi.h:786
Hunk #5 succeeded at 2989 (offset -7 lines).
Applied patch drivers/net/wireless/ath/ath10k/core.c cleanly.
Applied patch drivers/net/wireless/ath/ath10k/htt.h cleanly.
Applied patch drivers/net/wireless/ath/ath10k/htt_rx.c cleanly.
Applying patch drivers/net/wireless/ath/ath10k/mac.c with 1 reject...
Hunk #1 applied cleanly.
Rejected hunk #2.
Applied patch drivers/net/wireless/ath/ath10k/txrx.c cleanly.
Applying patch drivers/net/wireless/ath/ath10k/wmi.h with 4 rejects...
Rejected hunk #1.
Rejected hunk #2.
Rejected hunk #3.
Rejected hunk #4.
Hunk #5 applied cleanly.
Patch failed at 0001 ath10k: report tx airtime provided by fw

-- 
https://patchwork.kernel.org/patch/10684687/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

