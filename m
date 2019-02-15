Return-Path: <SRS0=7xxp=QW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D875C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D8588206B6
	for <linux-wireless@archiver.kernel.org>; Fri, 15 Feb 2019 11:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436757AbfBOLyT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 15 Feb 2019 06:54:19 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:38994 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404678AbfBOLyS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Feb 2019 06:54:18 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1guc4O-0006GL-Pl; Fri, 15 Feb 2019 12:54:17 +0100
Message-ID: <63fecadcf3f38f24b547143d9d53b3454adc417a.camel@sipsolutions.net>
Subject: Re: [RFC PATCH v3 08/12] iwlwifi: dvm - EXT_KEY_ID A-MPDU API update
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 15 Feb 2019 12:54:15 +0100
In-Reply-To: <20190210210620.31181-9-alexander@wetzel-home.de>
References: <20190210210620.31181-1-alexander@wetzel-home.de>
         <20190210210620.31181-9-alexander@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2019-02-10 at 22:06 +0100, Alexander Wetzel wrote:
> When using Extended Key ID mac80211 drops @IEEE80211_TX_CTL_AMPDU for
> the last packet which can be added to a A-MPDU in preparation.
> 
> Don't throw a warning and just handle the frame as if
> @IEEE80211_TX_CTL_AMPDU would have been set.
> 
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
> 
> I cold not figure out so far how to make sure the card will not mix
> A-MPDU frames. Looks like that is handled fully in the HW and I didn't
> find any interface to influence it. (It even may work already, I have
> some problems to capture A-MPDU frames with A-MPDU information intact
> and the topic was pretty low on the list so far. After all it works...)

You can't really do that, as far as I can tell, unfortunately. So this
might be better in a "compat on steroids" mode?

johannes


