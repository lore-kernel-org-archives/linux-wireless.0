Return-Path: <SRS0=ggvw=MV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60942C64EB0
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 20:08:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13A7E214C5
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Oct 2018 20:08:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13A7E214C5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727620AbeJJD1J (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Oct 2018 23:27:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:3396 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbeJJD1J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Oct 2018 23:27:09 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Oct 2018 13:08:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,361,1534834800"; 
   d="scan'208";a="77493538"
Received: from jprestwo.jf.intel.com ([10.54.74.38])
  by fmsmga008.fm.intel.com with ESMTP; 09 Oct 2018 13:08:32 -0700
Message-ID: <0b8356b90053c16e674905ca78707d6a19de0701.camel@linux.intel.com>
Subject: Re: [PATCH] mac80211_hwsim: allow setting custom features/iftypes
From:   James Prestwood <james.prestwood@linux.intel.com>
To:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Date:   Tue, 09 Oct 2018 13:12:17 -0700
In-Reply-To: <1539114071.3687.134.camel@sipsolutions.net>
References: <20181009174829.15163-1-james.prestwood@linux.intel.com>
         (sfid-20181009_194449_357742_49BD7697) <1539114071.3687.134.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.1-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-09 at 21:41 +0200, Johannes Berg wrote:
> On Tue, 2018-10-09 at 10:48 -0700, James Prestwood wrote:
> > The current driver hard codes various features, ext features and
> > supported
> > interface types when a new radio is created. This patch adds
> > several new
> > hwsim attributes so user space can specify specific features the
> > radio should
> > have:
> > 
> > - HWSIM_ATTR_FEATURE_SUPPORT
> > 	Bit field of nl80211_feature_flags flags
> > - HWSIM_ATTR_EXT_FEATURE_SUPPORT
> > 	Variable length bit field where bits map to
> > nl80211_ext_feature_index
> > 	values.
> > - HWSIM_ATTR_IFTYPE_SUPPORT
> > 	Nested attribute of flags containing all supported interface
> > types.
> > 	Each flag attribute sets support for an interface type.
> 
> This seems rather wrong, most (extended) features require the
> driver/device to actually *do* something.
> 
> Let's say you enable NL80211_EXT_FEATURE_TXQS - but then nothing
> actually happens when you try to configure those. Or let's say you
> enable NL80211_FEATURE_TX_POWER_INSERTION but then nothing actually
> happens when sending the frame...

Ok, that makes sense. The intent here was to test logic for detecting
and handling supported driver features/iftypes, rather than actually
using the features. But I do understand it would be strange for anyone
trying to enable a feature, to find that all it does it set a feature
bit (although this is exactly what we want :)). Would it be acceptable
(for now at least) if we just included the iftype piece? I can pull
that out into a new patch if so.

> 
> johannes
