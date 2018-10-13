Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5D3AC28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 06:48:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8823D20652
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 06:48:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8823D20652
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbeJMOYd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 10:24:33 -0400
Received: from mga07.intel.com ([134.134.136.100]:11310 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725978AbeJMOYd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 10:24:33 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Oct 2018 23:48:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,375,1534834800"; 
   d="scan'208";a="270998755"
Received: from mhaavist-mobl.ger.corp.intel.com ([10.252.0.169])
  by fmsmga005.fm.intel.com with ESMTP; 12 Oct 2018 23:48:34 -0700
Message-ID: <8d352f03737a0c44751e7b2355e46681071ccc0d.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: check return value of
 rs_rate_from_ucode_rate()
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date:   Sat, 13 Oct 2018 09:48:33 +0300
In-Reply-To: <20181013064608.31952-1-luca@coelho.fi>
References: <20181013064608.31952-1-luca@coelho.fi>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2018-10-13 at 09:46 +0300, Luca Coelho wrote:
> From: Luca Coelho <luciano.coelho@intel.com>
> 
> The rs_rate_from_ucode_rate() function may return -EINVAL if the rate
> is invalid, but none of the callsites check for the error,
> potentially
> making us access arrays with index IWL_RATE_INVALID, which is larger
> than the arrays, causing an out-of-bounds access.  This will trigger
> KASAN warnings, such as the one reported in the bugzilla issue
> mentioned below.
> 
> This fixes https://bugzilla.kernel.org/show_bug.cgi?id=200659
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---

Kalle,

Just for the record, as we discussed on IRC, please take this patch
directly to wireless-drivers-next for 4.20 so I don't need to send a
pull-req just for it.

--
Cheers,
Luca.

