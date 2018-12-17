Return-Path: <SRS0=RnVe=O2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A831DC43387
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 11:03:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6D37A206A2
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Dec 2018 11:03:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NVfAv1kL";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NVfAv1kL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbeLQLDG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Dec 2018 06:03:06 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:40938 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbeLQLDG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Dec 2018 06:03:06 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9ECA16058E; Mon, 17 Dec 2018 11:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545044585;
        bh=+h8Xzc1V8UFky2r7DCFL8v4aLwszy7Tiio2kZ6vWqZc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NVfAv1kL2LUvjkJ3SF8iud/9M+F2zNK11tkmvdmBpMantExOL86OTnBoYmG6ufnq+
         55wgh3tfL68hLToyZDZVZXiWQ23OVJpfx2TLhT++BjrJcnQIfNWYz3hkBgiB2JVoVj
         TVi7e7L3Sd0cvV9qpiiEOV8Nnmn/B5Ai/RXe0x2o=
Received: from purkki.adurom.net (purkki.adurom.net [80.68.90.206])
        (using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6B98B60585;
        Mon, 17 Dec 2018 11:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545044585;
        bh=+h8Xzc1V8UFky2r7DCFL8v4aLwszy7Tiio2kZ6vWqZc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=NVfAv1kL2LUvjkJ3SF8iud/9M+F2zNK11tkmvdmBpMantExOL86OTnBoYmG6ufnq+
         55wgh3tfL68hLToyZDZVZXiWQ23OVJpfx2TLhT++BjrJcnQIfNWYz3hkBgiB2JVoVj
         TVi7e7L3Sd0cvV9qpiiEOV8Nnmn/B5Ai/RXe0x2o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6B98B60585
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Ahmad Masri <amasri@codeaurora.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com
Subject: Re: [PATCH 1/2] cfg80211: Add Automatic Channel Selection (ACS) offload for AP
References: <1544968691-20679-1-git-send-email-amasri@codeaurora.org>
        <1544968691-20679-2-git-send-email-amasri@codeaurora.org>
Date:   Mon, 17 Dec 2018 13:03:01 +0200
In-Reply-To: <1544968691-20679-2-git-send-email-amasri@codeaurora.org> (Ahmad
        Masri's message of "Sun, 16 Dec 2018 15:58:10 +0200")
Message-ID: <87zht476vu.fsf@purkki.adurom.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ahmad Masri <amasri@codeaurora.org> writes:

> Add ACS offload to let the device select a channel for AP from
> a list of channels that the user-space provides. ACS can customize
> the method of AP channel selection and add parameters like traffic
> load, number of APs on channel and more.
>
> Change-Id: I18cb8460b9418512ac7ac9f76fe8f7f379f2478b
> Signed-off-by: Ahmad Masri <amasri@codeaurora.org>

No Change-Id, please.

> @@ -4662,6 +4680,7 @@ struct wireless_dev {
>  	unsigned long cac_start_time;
>  	unsigned int cac_time_ms;
>  
> +	bool acs_started;
>  #ifdef CONFIG_CFG80211_WEXT

Empty line before ifdef? Just like it had before your patch.

> +void cfg80211_acs_result(struct net_device *netdev,
> +			 const struct cfg80211_chan_def *chandef,
> +			 enum nl80211_acs_status status, gfp_t gfp)
> +{
> +	struct wireless_dev *wdev = netdev->ieee80211_ptr;
> +	struct wiphy *wiphy = wdev->wiphy;
> +	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
> +
> +	if (WARN_ON(!wdev->acs_started))
> +		return;
> +
> +	switch (status) {
> +	case NL80211_ACS_SUCCESS:
> +		if (!chandef) {
> +			WARN_ON(1);
> +			goto out;
> +		}

if (WARN_ON(!chandef))
	goto out;

-- 
Kalle Valo
