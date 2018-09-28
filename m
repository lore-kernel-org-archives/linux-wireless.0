Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E6DC43382
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 05:31:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA3C32170E
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 05:31:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org AA3C32170E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728375AbeI1Lxw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 07:53:52 -0400
Received: from mga04.intel.com ([192.55.52.120]:4213 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726060AbeI1Lxw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 07:53:52 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Sep 2018 22:31:54 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.54,313,1534834800"; 
   d="scan'208";a="73747337"
Received: from jaroslaw-mobl.ger.corp.intel.com ([10.252.20.75])
  by fmsmga007.fm.intel.com with ESMTP; 27 Sep 2018 22:31:52 -0700
Message-ID: <1edaefd839f58180a3c058a30fc74c73808b239f.camel@intel.com>
Subject: Re: [PATCH v2] iwlwifi: mvm: enable sending HE_AIR_SNIFFER command
 via debugfs
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     kvalo@codeaurora.org
Cc:     arend.vanspriel@broadcom.com, linux-wireless@vger.kernel.org,
        Shaul Triebitz <shaul.triebitz@intel.com>,
        Liad Kaufman <liad.kaufman@intel.com>,
        Ido Yariv <idox.yariv@intel.com>
Date:   Fri, 28 Sep 2018 08:31:51 +0300
In-Reply-To: <20180928052328.5965-1-luca@coelho.fi>
References: <f2e1d9b93487a74bccdbb680a1f43bae6271657f.camel@coelho.fi>
         <20180928052328.5965-1-luca@coelho.fi>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.0-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-09-28 at 08:23 +0300, Luca Coelho wrote:
> From: Shaul Triebitz <shaul.triebitz@intel.com>
> 
> In order to receive TB (Trigger Based) PPDU in monitor mode,
> the Driver must send the HE_AIR_SNIFFER_CONFIG_CMD host command.
> Enable that via debugfs.
> 
> Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
> Signed-off-by: Ido Yariv <idox.yariv@intel.com>
> Signed-off-by: Shaul Triebitz <shaul.triebitz@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
> 
> In v2:
> 
> * renamed set_aid to he_sniffer_params as suggested by Arend;
> * removed duplicate debugfs file creation;

I got confused (since I did this a long time ago), but actually what I
did here was to make the debugfs entry write-only since we were not
using the read op anyway.

--
Luca.

