Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14780C64EB0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 19:41:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C35A0214C4
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 19:41:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C35A0214C4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbeJJC74 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 22:59:56 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:58412 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbeJJC74 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 22:59:56 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g9xsh-00023j-Kd; Tue, 09 Oct 2018 21:41:23 +0200
Message-ID: <1539114071.3687.134.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: allow setting custom features/iftypes
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Prestwood <james.prestwood@linux.intel.com>,
        linux-wireless@vger.kernel.org
Date:   Tue, 09 Oct 2018 21:41:11 +0200
In-Reply-To: <20181009174829.15163-1-james.prestwood@linux.intel.com> (sfid-20181009_194449_357742_49BD7697)
References: <20181009174829.15163-1-james.prestwood@linux.intel.com>
         (sfid-20181009_194449_357742_49BD7697)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 (3.26.6-1.fc27) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-09 at 10:48 -0700, James Prestwood wrote:
> The current driver hard codes various features, ext features and supported
> interface types when a new radio is created. This patch adds several new
> hwsim attributes so user space can specify specific features the radio should
> have:
> 
> - HWSIM_ATTR_FEATURE_SUPPORT
> 	Bit field of nl80211_feature_flags flags
> - HWSIM_ATTR_EXT_FEATURE_SUPPORT
> 	Variable length bit field where bits map to nl80211_ext_feature_index
> 	values.
> - HWSIM_ATTR_IFTYPE_SUPPORT
> 	Nested attribute of flags containing all supported interface types.
> 	Each flag attribute sets support for an interface type.

This seems rather wrong, most (extended) features require the
driver/device to actually *do* something.

Let's say you enable NL80211_EXT_FEATURE_TXQS - but then nothing
actually happens when you try to configure those. Or let's say you
enable NL80211_FEATURE_TX_POWER_INSERTION but then nothing actually
happens when sending the frame...

johannes
