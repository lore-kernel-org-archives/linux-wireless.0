Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1064C43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 11:07:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BC0AD206A2
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 11:07:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BVB71fji";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BVB71fji"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbeLQLHm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 06:07:42 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42980 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbeLQLHm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 06:07:42 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D9F4C6074E; Mon, 17 Dec 2018 11:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545044861;
        bh=CzyPa2myFUjgN0yp+3SkKglynmipAKXaE3OUMJsA8YM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BVB71fjivkwU+eAv/Jnq3gZCz/gUwJbaMoJJg32TOALi7/LVs70Xd8GKi21R4I6oG
         a/6/gq17NpVpDNd+04yuzl3M7+aqM5w18baRvQKDHZ4WDnyA3Z+GuhgwTQxrchYFEd
         WHb+PLkn0NzxceN/CgNh9JuMJtqncP+PK0JNWgCU=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 95C9760585;
        Mon, 17 Dec 2018 11:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545044861;
        bh=CzyPa2myFUjgN0yp+3SkKglynmipAKXaE3OUMJsA8YM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BVB71fjivkwU+eAv/Jnq3gZCz/gUwJbaMoJJg32TOALi7/LVs70Xd8GKi21R4I6oG
         a/6/gq17NpVpDNd+04yuzl3M7+aqM5w18baRvQKDHZ4WDnyA3Z+GuhgwTQxrchYFEd
         WHb+PLkn0NzxceN/CgNh9JuMJtqncP+PK0JNWgCU=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 95C9760585
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ahmad Masri <amasri@codeaurora.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 2/2] wil6210: add implementation of acs cfg80211_ops
References: <1544968691-20679-1-git-send-email-amasri@codeaurora.org>
        <1544968691-20679-3-git-send-email-amasri@codeaurora.org>
Date:   Mon, 17 Dec 2018 13:07:38 +0200
In-Reply-To: <1544968691-20679-3-git-send-email-amasri@codeaurora.org> (Ahmad
        Masri's message of "Sun, 16 Dec 2018 15:58:11 +0200")
Message-ID: <87va3s76o5.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ahmad Masri <amasri@codeaurora.org> writes:

> Add ACS to cfg80211 operations that the device handles and performs.
> wil6210 reports NL80211_EXT_FEATURE_ACS_OFFLOAD indicating a support
> for acs operation through cfg80211_ops.
>
> ACS is performed by the driver and the FW. Once ACS operation is
> called the driver builds a WMI command with the requested channels
> and sends the command to the FW. The FW performs ACS scan on the
> channels and reports for each channel the following:
> 1- Number of beacon received on channel
> 2- channel busy time
> 3- transmit time
> 4- receive time
> 5- noise level
> The driver uses the above information to select the best channel
> to start the AP, and reports it to the host.

What's the point? Why is it better that wil6210 makes the decision
instead of hostapd?

> User may use debugfs acs_ch_weight to set a different weights
> for the channels.

Debugfs does not sound like the best interface for that, shouldn't it go
via nl80211?

> Change-Id: I8e13296fad0c9fa8b15788fd37c23d825d41d8e5

No Change-Id, please.

-- 
Kalle Valo
