Return-Path: <SRS0=0pM2=P6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB23EC282C3
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 11:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79C9E20879
	for <linux-wireless@archiver.kernel.org>; Tue, 22 Jan 2019 11:30:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lXmk+pQW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lXmk+pQW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728138AbfAVLaZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 06:30:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:36770 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728010AbfAVLaZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 06:30:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DD4CA60850; Tue, 22 Jan 2019 11:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548156624;
        bh=3uUPbZu6bVtaZu3WQckKoHWZ/Y83jefeJgOI84VwumY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lXmk+pQW0bPIRcIAz4XJQzCENlS23kFQloqnhGIildECG7IGBdLWSRNzpOIZL5eqm
         9vJXAyFL9SYtkW5eSkrtwBpK3jvgh7R10WhQZCTMhVuYTPCYo3OvyCRgNurcFihyrZ
         gFINGq9LgBxsAZUhXFoQZC5280WGMhoSgoXECR3s=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 6835A6063A;
        Tue, 22 Jan 2019 11:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548156624;
        bh=3uUPbZu6bVtaZu3WQckKoHWZ/Y83jefeJgOI84VwumY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lXmk+pQW0bPIRcIAz4XJQzCENlS23kFQloqnhGIildECG7IGBdLWSRNzpOIZL5eqm
         9vJXAyFL9SYtkW5eSkrtwBpK3jvgh7R10WhQZCTMhVuYTPCYo3OvyCRgNurcFihyrZ
         gFINGq9LgBxsAZUhXFoQZC5280WGMhoSgoXECR3s=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 22 Jan 2019 17:00:24 +0530
From:   vamsin@codeaurora.org
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, jouni@codeaurora.org
Subject: Re: [PATCH] nl80211/cfg80211: Add support to specify band specific
 min rssi thresholds with sched scan
In-Reply-To: <c5f276af0189d31d247c43e3ef79dad634568b37.camel@sipsolutions.net>
References: <1543566848-14819-1-git-send-email-vamsin@codeaurora.org>
 <49850508355f57fba6f9803416bf71c24766747b.camel@sipsolutions.net>
 <a6b9ae694194e5b766b0045fe1e4fc76@codeaurora.org>
 <c5f276af0189d31d247c43e3ef79dad634568b37.camel@sipsolutions.net>
Message-ID: <86e677e70f890b0e9bd85973228753e9@codeaurora.org>
X-Sender: vamsin@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-01-15 18:55, Johannes Berg wrote:

> 
>> > It seems that this should be with the existing
>> > NL80211_SCHED_SCAN_MATCH_ATTR_RSSI, not in this level namespace.
>> 
>> The band specific rssi thresholds that are being configured are global
>> across all matchsets whereas NL80211_SCHED_SCAN_MATCH_ATTR_* 
>> attributes
>> are mostly specific to each matchset. Hence I choose to define
>> attributes in higher level namespace. In future, whenever we want to
>> adding support for rssi thresholds per band and per matchset, we can
>> define attributes within NL80211_SCHED_SCAN_MATCH_ATTR_* namespace
>> level.
> 
> But why do we want global ones now?
> 

The global thresholds were there earlier as well. Earlier, we were using 
a matchset with only rssi attribute without any ssid/bssid attribute 
within the matchset. I thought having global attributes for specifying 
global thresholds is better way going forward and avoids unnecessary 
confusion. Mostly, same thresholds will be used for all ssids/bssids in 
general rather than thresholds specific to ssid/bssid. However, I 
couldn't see any disadvantage of using global attributes for this case, 
please let me know if you see any disadvantage/concern with this.

Thanks,
Vamsi
