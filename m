Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95952C282C0
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:44:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 662CD21903
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 20:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfAYUoh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 15:44:37 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:39426 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbfAYUog (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 15:44:36 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gn8L5-0005Dd-5u; Fri, 25 Jan 2019 21:44:35 +0100
Message-ID: <ea2b998e692235f0d7e4314d9b010eeac20e403f.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211/cfg80211: Add support to specify band specific
 min rssi thresholds with sched scan
From:   Johannes Berg <johannes@sipsolutions.net>
To:     vamsin@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, jouni@codeaurora.org
Date:   Fri, 25 Jan 2019 21:44:34 +0100
In-Reply-To: <86e677e70f890b0e9bd85973228753e9@codeaurora.org>
References: <1543566848-14819-1-git-send-email-vamsin@codeaurora.org>
         <49850508355f57fba6f9803416bf71c24766747b.camel@sipsolutions.net>
         <a6b9ae694194e5b766b0045fe1e4fc76@codeaurora.org>
         <c5f276af0189d31d247c43e3ef79dad634568b37.camel@sipsolutions.net>
         <86e677e70f890b0e9bd85973228753e9@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-01-22 at 17:00 +0530, vamsin@codeaurora.org wrote:

> > > > It seems that this should be with the existing
> > > > NL80211_SCHED_SCAN_MATCH_ATTR_RSSI, not in this level namespace.
> > > 
> > > The band specific rssi thresholds that are being configured are global
> > > across all matchsets whereas NL80211_SCHED_SCAN_MATCH_ATTR_* 
> > > attributes
> > > are mostly specific to each matchset. Hence I choose to define
> > > attributes in higher level namespace. In future, whenever we want to
> > > adding support for rssi thresholds per band and per matchset, we can
> > > define attributes within NL80211_SCHED_SCAN_MATCH_ATTR_* namespace
> > > level.
> > 
> > But why do we want global ones now?
> > 
> 
> The global thresholds were there earlier as well. Earlier, we were using 
> a matchset with only rssi attribute without any ssid/bssid attribute 
> within the matchset. I thought having global attributes for specifying 
> global thresholds is better way going forward and avoids unnecessary 
> confusion. Mostly, same thresholds will be used for all ssids/bssids in 
> general rather than thresholds specific to ssid/bssid. However, I 
> couldn't see any disadvantage of using global attributes for this case, 
> please let me know if you see any disadvantage/concern with this.

I just think it's more complex code, overall.

To me we now have sort of a fork in the road

global RSSI ---> per-matchset RSSI
           \
            \--> global band-specific RSSI

so it seems somebody will want to introduce per-matchset band-specific
RSSI eventually, and that just makes it even more complex?

What's the downside of going to per-matchset band-specific RSSI?

johannes

