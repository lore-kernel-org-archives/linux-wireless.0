Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE5B2C43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:25:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE00820657
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 13:25:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727937AbfAONZV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 08:25:21 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56698 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727451AbfAONZU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 08:25:20 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gjOiV-0007kO-0g; Tue, 15 Jan 2019 14:25:19 +0100
Message-ID: <c5f276af0189d31d247c43e3ef79dad634568b37.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211/cfg80211: Add support to specify band specific
 min rssi thresholds with sched scan
From:   Johannes Berg <johannes@sipsolutions.net>
To:     vamsin@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, jouni@codeaurora.org
Date:   Tue, 15 Jan 2019 14:25:17 +0100
In-Reply-To: <a6b9ae694194e5b766b0045fe1e4fc76@codeaurora.org>
References: <1543566848-14819-1-git-send-email-vamsin@codeaurora.org>
         <49850508355f57fba6f9803416bf71c24766747b.camel@sipsolutions.net>
         <a6b9ae694194e5b766b0045fe1e4fc76@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

> > Is there much point in this?
> > 
> > It seems to me that userspace will not really do anything different if
> > it knows what's supported - it's probably easier for it (or cfg80211?)
> > to just set the global min_rssi to the minimum over all bands, and 
> > treat
> > this as we do most things in scheduled scan - an optimisation that
> > doesn't really need a feature advertisement?
> > 
> > I think that would simplify things somewhat.
> 
> I think the driver capability advertisement will provide more 
> flexibility to users in few cases, e.g., earlier, say if userspace is 
> programming -65dBm as min_rssi_thold common for all bands and with the 
> new implementation it may choose to configure -60dBm for 5GHz band and 
> -70dBm for 2.4GHz band for better user experience and power saving(with 
> filtering out unwanted 5GHz bssids). If the user configures -60dBm and 
> -70dBm thresholds for the old drivers without band specific threshold 
> support, it could result in unnecessary wakeups for 5GHz bssids with 
> rssi between -65dBm and -70dBm (compared to the old case of configuring 
> single threshold of -65dBm). So, I think it is better to keep the 
> capability advertisement.

Ok, fair enough.

> > It seems that this should be with the existing
> > NL80211_SCHED_SCAN_MATCH_ATTR_RSSI, not in this level namespace.
> 
> The band specific rssi thresholds that are being configured are global 
> across all matchsets whereas NL80211_SCHED_SCAN_MATCH_ATTR_* attributes 
> are mostly specific to each matchset. Hence I choose to define 
> attributes in higher level namespace. In future, whenever we want to 
> adding support for rssi thresholds per band and per matchset, we can 
> define attributes within NL80211_SCHED_SCAN_MATCH_ATTR_* namespace 
> level.

But why do we want global ones now?

johannes

