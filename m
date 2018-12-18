Return-Path: <SRS0=MtVb=O3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D87DBC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 13:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A68A0217D7
	for <linux-wireless@archiver.kernel.org>; Tue, 18 Dec 2018 13:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726659AbeLRNJk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 18 Dec 2018 08:09:40 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:40790 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726403AbeLRNJj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Dec 2018 08:09:39 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gZF7y-0006S4-0p; Tue, 18 Dec 2018 14:09:38 +0100
Message-ID: <49850508355f57fba6f9803416bf71c24766747b.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211/cfg80211: Add support to specify band specific
 min rssi thresholds with sched scan
From:   Johannes Berg <johannes@sipsolutions.net>
To:     vamsi krishna <vamsin@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, jouni@codeaurora.org
Date:   Tue, 18 Dec 2018 14:09:36 +0100
In-Reply-To: <1543566848-14819-1-git-send-email-vamsin@codeaurora.org>
References: <1543566848-14819-1-git-send-email-vamsin@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-11-30 at 14:04 +0530, vamsi krishna wrote:
> 
> The drivers with capability to filter scan results with different rssi
> thresholds for different bands shall indicate the support to user space by
> setting %NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD in
> wiphy->ext_features. The drivers that support this feature shall use rssi
> values from @band_specific_min_rssi_thold for scan results filtering and
> shall not use min_rssi_thold anymore.

Is there much point in this?

It seems to me that userspace will not really do anything different if
it knows what's supported - it's probably easier for it (or cfg80211?)
to just set the global min_rssi to the minimum over all bands, and treat
this as we do most things in scheduled scan - an optimisation that
doesn't really need a feature advertisement?

I think that would simplify things somewhat.

> + * @NL80211_ATTR_SCHED_SCAN_MIN_RSSI: Nested attribute that carries the band
> + *	specific minimum rssi thresholds for the bands defined in enum
> + *	nl80211_band. The minimum rssi threshold value(s32) specific to a band
> + *	shall be encapsulated in attribute with type value equals to one of the
> + *	NL80211_BAND_* defined in enum nl80211_band. For example, the minimum
> + *	rssi threshold value for 2.4GHz band shall be encapsulated within an
> + *	attribute of type NL80211_BAND_2GHz. And one or more of such attributes
> + *	will be nested within this attribute. If min rssi sub attribute is not
> + *	included for any band, then %NL80211_SCAN_RSSI_THOLD_OFF will be used
> + *	as minimum rssi threshold for scan result filtering.
> + *	If a scan result received in a particular band has lesser rssi than the
> + *	rssi threshold specified for that band, then the scan result shall be
> + *	filtered out. The rssi thresholds specified in matchsets along with ssid
> + *	or bssid attribute will have higher precedence than the thresholds
> + *	mentioned in this attribute while checking rssi.

It seems that this should be with the existing
NL80211_SCHED_SCAN_MATCH_ATTR_RSSI, not in this level namespace.

johannes

