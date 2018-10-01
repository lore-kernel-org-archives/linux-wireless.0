Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7DCBC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 10:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9015F2084C
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 10:13:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9015F2084C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728973AbeJAQuO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 12:50:14 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:56908 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbeJAQuO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 12:50:14 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g6vCM-0002PN-RY; Mon, 01 Oct 2018 12:13:07 +0200
Message-ID: <1538388776.3126.24.camel@sipsolutions.net>
Subject: Re: [PATCH v5 1/3] cfg80211: support FTM responder
 configuration/statistics
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Date:   Mon, 01 Oct 2018 12:12:56 +0200
In-Reply-To: <1537489811-5752-2-git-send-email-pradeepc@codeaurora.org>
References: <1537489811-5752-1-git-send-email-pradeepc@codeaurora.org>
         <1537489811-5752-2-git-send-email-pradeepc@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-09-20 at 17:30 -0700, Pradeep Kumar Chitrapu wrote:
> Allow userspace to enable fine timing measurement responder
> functionality with configurable lci/civic parameters in AP mode.
> This can be done at AP start or changing beacon parameters.
> 
> A new EXT_FEATURE flag is introduced for drivers to advertise
> the capability.
> 
> Also nl80211 API support for retrieving statistics is added.

I applied this, but with some changes. Notably,

>  /**
> + * cfg80211_ftm_responder_params - FTM responder parameters

I removed this struct, since it's no longer needed.

You do use it in mac80211, but since cfg80211 doesn't use it you should
declare it as ieee80211_ftm_respodner_params and use it in mac80211
only, I think.

johannes
