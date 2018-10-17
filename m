Return-Path: <SRS0=hbYo=M5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDD71ECDE3B
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 19:53:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 98B7921476
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Oct 2018 19:53:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98B7921476
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbeJRDuc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Oct 2018 23:50:32 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:50618 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbeJRDuc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Oct 2018 23:50:32 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gCrsZ-00013B-E6; Wed, 17 Oct 2018 21:53:15 +0200
Message-ID: <48e12e055637af139094b6c1163f61c45b5ebb54.camel@sipsolutions.net>
Subject: Re: [PATCH v2 1/2] mac80211_hwsim: allow setting iftype support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Prestwood <james.prestwood@linux.intel.com>,
        linux-wireless@vger.kernel.org
Date:   Wed, 17 Oct 2018 21:53:01 +0200
In-Reply-To: <20181017193307.1780-2-james.prestwood@linux.intel.com> (sfid-20181017_212933_830456_E841649D)
References: <20181017193307.1780-1-james.prestwood@linux.intel.com>
         <20181017193307.1780-2-james.prestwood@linux.intel.com>
         (sfid-20181017_212933_830456_E841649D)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2018-10-17 at 12:33 -0700, James Prestwood wrote:
> The mac80211_hwsim driver hard codes its supported interface types. For
> testing purposes it would be valuable to allow changing these supported
> types in order to simulate actual drivers than support a limited set of

typo: than -> that

> In order to accomplish this, the ieee80211_iface_limit structure needed
> to be built dynamically to only include limit rules for iftypes that
> the user requested to enable.

That makes me wonder if you'd also want to support limiting the # of
interfaces/channels to mimic another device?

johannes

