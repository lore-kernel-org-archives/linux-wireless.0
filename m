Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F44C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 09:27:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6091E2086E
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 09:27:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6091E2086E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbeIZPjD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 11:39:03 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38852 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727157AbeIZPjC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 11:39:02 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g565z-00019J-3p; Wed, 26 Sep 2018 11:26:59 +0200
Message-ID: <1537954007.28767.10.camel@sipsolutions.net>
Subject: Re: [PATCH] New functionality for aborting ongoing CAC.
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Enrique Giraldo <hgiraldos@gmail.com>,
        linux-wireless@vger.kernel.org
Cc:     Enrique Giraldo <enrique.giraldo@galgus.net>
Date:   Wed, 26 Sep 2018 11:26:47 +0200
In-Reply-To: <20180925081933.28553-1-enrique.giraldo@galgus.net> (sfid-20180925_103015_233939_9CC2DC4E)
References: <20180925081933.28553-1-enrique.giraldo@galgus.net>
         (sfid-20180925_103015_233939_9CC2DC4E)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-09-25 at 10:19 +0200, Enrique Giraldo wrote:
> Add NL80211_CMD_ABORT_CAC to the nl80211 interface.

As Arend pointed out, this really needs a much better commit message.

Please also adjust the subject to have a proper prefix etc. See
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
for some help with that.

> @@ -3227,6 +3228,7 @@ struct cfg80211_ops {
>  	int	(*scan)(struct wiphy *wiphy,
>  			struct cfg80211_scan_request *request);
>  	void	(*abort_scan)(struct wiphy *wiphy, struct wireless_dev *wdev);
> +	void	(*abort_cac)(struct wiphy *wiphy, struct wireless_dev *wdev);

This is fine, you can add in the middle of the struct.

> 
> @@ -1220,6 +1223,7 @@ enum nl80211_commands {
>  	NL80211_CMD_WIPHY_REG_CHANGE,
>  
>  	NL80211_CMD_ABORT_SCAN,
> +	NL80211_CMD_ABORT_CAC,
>  
>  	NL80211_CMD_START_NAN,

This is *not* OK, as the comments here indicate, we must never add
anything in the middle of this enum, doing so breaks userspace ABI.

johannes
