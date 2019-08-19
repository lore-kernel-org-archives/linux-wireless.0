Return-Path: <SRS0=IsUp=WP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD0AC3A59D
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 10:16:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7BA5D2189F
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 10:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbfHSKQG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Aug 2019 06:16:06 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38972 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbfHSKQG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Aug 2019 06:16:06 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hzeho-0007hK-Uq; Mon, 19 Aug 2019 12:16:05 +0200
Message-ID: <3a8edc6691a03ed3c253d95811d5fd6cae453a03.camel@sipsolutions.net>
Subject: Re: [PATCH] cfg80211: VLAN offload support for set_key and
 set_sta_vlan
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jouni Malinen <jouni@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Gurumoorthi Gnanasambandhan <gguru@codeaurora.org>
Date:   Mon, 19 Aug 2019 12:16:03 +0200
In-Reply-To: <20190815133825.8131-1-jouni@codeaurora.org> (sfid-20190815_153916_400716_E56EEDCF)
References: <20190815133825.8131-1-jouni@codeaurora.org>
         (sfid-20190815_153916_400716_E56EEDCF)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2019-08-15 at 16:38 +0300, Jouni Malinen wrote:
> From: Gurumoorthi Gnanasambandhan <gguru@codeaurora.org>
> 
> This provides an alternative mechanism for AP VLAN support where a
> single netdev is used with VLAN tagged frames instead of separate
> netdevs for each VLAN without tagged frames from the WLAN driver.
> 
> By setting NL80211_EXT_FEATURE_VLAN_OFFLOAD flag the driver indicates
> support for a single netdev with VLAN tagged frames. Separate
> VLAN-specific netdevs are added using vcongig similar to Ethernet.
> NL80211_CMD_NEW_KEY and NL80211_CMD_SET_STATION will optionally specify
> vlan_id using NL80211_ATTR_VLAN_ID.

Without really looking at the specifics, it might be relatively simple
to support this in mac80211?

johannes

