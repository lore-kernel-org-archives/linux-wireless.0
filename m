Return-Path: <SRS0=+bZT=NF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E53F3ECDE47
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 10:45:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B62922082D
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Oct 2018 10:45:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B62922082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbeJYTRB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Oct 2018 15:17:01 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:40412 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbeJYTRB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Oct 2018 15:17:01 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gFd8B-00081C-8x; Thu, 25 Oct 2018 12:44:47 +0200
Message-ID: <c832f9007e0a844d3335a0cd9996818f49df2311.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: support FTM responder configuration/statistics
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Date:   Thu, 25 Oct 2018 12:44:29 +0200
In-Reply-To: <1538623160-25886-1-git-send-email-pradeepc@codeaurora.org> (sfid-20181004_051935_494006_E9A4C858)
References: <1538623160-25886-1-git-send-email-pradeepc@codeaurora.org>
         (sfid-20181004_051935_494006_E9A4C858)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Pradeep,

On Wed, 2018-10-03 at 20:19 -0700, Pradeep Kumar Chitrapu wrote:
> New bss param ftm_responder is used to notify the driver to
> enable fine timing request (FTM) responder role in AP mode.

I just realized that this is broken in nl80211_channel_switch() and
ieee80211_set_csa_beacon(), doing a CSA will always disable FTM unless
it was actually included in the new configuration.

Doing the trivial thing:

 	memset(&params, 0, sizeof(params));
+	params.beacon_after.ftm_responder = -1;

in nl80211_channel_switch() will not help because then mac80211 will
lose all the extra configuration, and will actually store -1 into its
enabled value which is really strange.

I'd appreciate if you could take a look at this.

Thanks,
johannes

