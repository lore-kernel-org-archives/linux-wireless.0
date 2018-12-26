Return-Path: <SRS0=rEuJ=PD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0353C43387
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 09:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A917221741
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Dec 2018 09:54:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="PP+Wq/rH";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jGCIa5zE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbeLZJyZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Dec 2018 04:54:25 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50978 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726421AbeLZJyZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Dec 2018 04:54:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 73AE2606AC; Wed, 26 Dec 2018 09:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545818064;
        bh=tlxEDXmyurmJghM/VX5DFJ/FHl4vpCrvf8uUdHHKk6Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PP+Wq/rHascxh7Pm2V4w9cwWBNKXoPJEHMnygV7D/GjDlOw/8UtWL5nYSJ70+87g9
         fJkjaDB9j3NHGHn7UdArt7Qam4RzSR0YOxeqwpPggZC9sDJnbZw8uBVnD/rdKnEheS
         d+97NG/BqU23yhr0usV3K5Qvrq7G82L0nP2voIOU=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id B6E376053B;
        Wed, 26 Dec 2018 09:54:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545818063;
        bh=tlxEDXmyurmJghM/VX5DFJ/FHl4vpCrvf8uUdHHKk6Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jGCIa5zE92u6rfocdV23mXHEOIZJ48dYYzIqB0i9eaku17rrOFfKDFPaOfGwI1zqk
         XkRM95+qJdD7CaLlnVXrTghwxWZ7N+Dfce1ER3OTkbXOzQwcw++jEBlaYRRiQNZFBz
         9tff0eh9GrmJeW9Q0rsxQQHVjHCAkbKyc02xuncU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 26 Dec 2018 15:24:23 +0530
From:   vamsin@codeaurora.org
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, jouni@codeaurora.org
Subject: Re: [PATCH] nl80211/cfg80211: Add support to specify band specific
 min rssi thresholds with sched scan
In-Reply-To: <49850508355f57fba6f9803416bf71c24766747b.camel@sipsolutions.net>
References: <1543566848-14819-1-git-send-email-vamsin@codeaurora.org>
 <49850508355f57fba6f9803416bf71c24766747b.camel@sipsolutions.net>
Message-ID: <a6b9ae694194e5b766b0045fe1e4fc76@codeaurora.org>
X-Sender: vamsin@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-12-18 18:39, Johannes Berg wrote:
> On Fri, 2018-11-30 at 14:04 +0530, vamsi krishna wrote:
>> 
>> The drivers with capability to filter scan results with different rssi
>> thresholds for different bands shall indicate the support to user 
>> space by
>> setting %NL80211_EXT_FEATURE_SCHED_SCAN_BAND_SPECIFIC_RSSI_THOLD in
>> wiphy->ext_features. The drivers that support this feature shall use 
>> rssi
>> values from @band_specific_min_rssi_thold for scan results filtering 
>> and
>> shall not use min_rssi_thold anymore.
> 
> Is there much point in this?
> 
> It seems to me that userspace will not really do anything different if
> it knows what's supported - it's probably easier for it (or cfg80211?)
> to just set the global min_rssi to the minimum over all bands, and 
> treat
> this as we do most things in scheduled scan - an optimisation that
> doesn't really need a feature advertisement?
> 
> I think that would simplify things somewhat.

I think the driver capability advertisement will provide more 
flexibility to users in few cases, e.g., earlier, say if userspace is 
programming -65dBm as min_rssi_thold common for all bands and with the 
new implementation it may choose to configure -60dBm for 5GHz band and 
-70dBm for 2.4GHz band for better user experience and power saving(with 
filtering out unwanted 5GHz bssids). If the user configures -60dBm and 
-70dBm thresholds for the old drivers without band specific threshold 
support, it could result in unnecessary wakeups for 5GHz bssids with 
rssi between -65dBm and -70dBm (compared to the old case of configuring 
single threshold of -65dBm). So, I think it is better to keep the 
capability advertisement.

> 
>> + * @NL80211_ATTR_SCHED_SCAN_MIN_RSSI: Nested attribute that carries 
>> the band
>> + *	specific minimum rssi thresholds for the bands defined in enum
>> + *	nl80211_band. The minimum rssi threshold value(s32) specific to a 
>> band
>> + *	shall be encapsulated in attribute with type value equals to one 
>> of the
>> + *	NL80211_BAND_* defined in enum nl80211_band. For example, the 
>> minimum
>> + *	rssi threshold value for 2.4GHz band shall be encapsulated within 
>> an
>> + *	attribute of type NL80211_BAND_2GHz. And one or more of such 
>> attributes
>> + *	will be nested within this attribute. If min rssi sub attribute is 
>> not
>> + *	included for any band, then %NL80211_SCAN_RSSI_THOLD_OFF will be 
>> used
>> + *	as minimum rssi threshold for scan result filtering.
>> + *	If a scan result received in a particular band has lesser rssi 
>> than the
>> + *	rssi threshold specified for that band, then the scan result shall 
>> be
>> + *	filtered out. The rssi thresholds specified in matchsets along 
>> with ssid
>> + *	or bssid attribute will have higher precedence than the thresholds
>> + *	mentioned in this attribute while checking rssi.
> 
> It seems that this should be with the existing
> NL80211_SCHED_SCAN_MATCH_ATTR_RSSI, not in this level namespace.

The band specific rssi thresholds that are being configured are global 
across all matchsets whereas NL80211_SCHED_SCAN_MATCH_ATTR_* attributes 
are mostly specific to each matchset. Hence I choose to define 
attributes in higher level namespace. In future, whenever we want to 
adding support for rssi thresholds per band and per matchset, we can 
define attributes within NL80211_SCHED_SCAN_MATCH_ATTR_* namespace 
level.

Thanks & Regards,
Vamsi
