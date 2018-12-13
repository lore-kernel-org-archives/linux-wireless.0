Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42BCBC65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 10:23:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05C6E20882
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 10:23:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05C6E20882
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbeLMKXn (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 05:23:43 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:59294 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725949AbeLMKXn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 05:23:43 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gXO9c-0002vq-9v; Thu, 13 Dec 2018 11:23:40 +0100
Message-ID: <703d7c377a5a1ea5b0b4ee77bbfd01d8f2dfd8d2.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v1] cfg80211/nl80211: add support for AID assignment
 by driver
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sarada Prasanna Garnayak <sarada.prasanna.garnayak@intel.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 13 Dec 2018 11:23:39 +0100
In-Reply-To: <20181212180928.42117-1-sarada.prasanna.garnayak@intel.com>
References: <20181212180928.42117-1-sarada.prasanna.garnayak@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On Wed, 2018-12-12 at 23:39 +0530, Sarada Prasanna Garnayak wrote:
> Add support for getting and free association ID if the station
> association ID management handled by the WLAN driver/firmware.
> 
> Add cfg80211 driver ops and nl80211 API and CMD to request
> the WLAN driver to assign an AID for a station during association
> and release the AID of the station from the WLAN driver/firmware
> station database on disassociation from the AP.

I think this should state why it's needed - i.e. why the implied "use
lowest possible AID" assignment scheme isn't sufficient for some/your
driver(s). That scheme has advantages in the TIM Element for example, so
deviating from it might cause other issues.

> + * @get_sta_aid: Get an AID for the station from the driver if AID assignment
> + *	is managed by the WLAN driver/hardware/firmware.

This seems reasonable, but let me think about it more below.

> + * @free_sta_aid: Release the AID of the station from the station database
> + *	on disassociation from the AP if AID assignment is managed by
> + *	the WLAN driver/hardware/firmware.

I'm not convinced this makes sense. The station entry will be freed by
hostapd anyway, and in that case the AID is freed implicitly. I see no
reason to split these operations.

In fact, I'm not sure we need an allocation operation either, since we
should be able to assign one when the station entry is added.

> +	int (*get_sta_aid)(struct wiphy *wiphy, struct net_device *dev,
> +			   u16 *sta_aid, const u8 *mac_addr);

If we do this, we should probably *return* the AID, that doesn't overlap
with error return values since AIDs are positive and error codes
negative.

> + * @NL80211_CMD_GET_STA_AID: Request association ID for a station if the station
> + *	association ID management handled by the driver/firmware/hardware
> + *	specified by %NL80211_ATTR_MAC and %NL80211_ATTR_STA_AID.
> + *
> + * @NL80211_CMD_FREE_STA_AID: Free association ID of a station if the station
> + *	association ID management handled by the driver/firmware/hardware
> + *	with specified by %NL80211_ATTR_STA_AID.

Same comments as above of course apply to the nl80211 API.

However, in any case, I don't really see why we need this at all.

Normally, the flow (nowadays) is to add a station when it authenticates,
and so at that point the AID could be assigned by the driver in the
station entry. We need to think about the capabilities for this, and how
to force hostapd to actually do this flow (or have the driver accept
AIDs from hostapd if it's an old version?)

johannes

