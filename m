Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 102C0C07E85
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:12:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D755720851
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 12:12:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D755720851
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbeLCMM5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 07:12:57 -0500
Received: from mga14.intel.com ([192.55.52.115]:48411 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726488AbeLCMMv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 07:12:51 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Dec 2018 04:12:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,310,1539673200"; 
   d="scan'208";a="115188124"
Received: from ggrimlan-mobl1.ger.corp.intel.com ([10.252.29.76])
  by orsmga002.jf.intel.com with ESMTP; 03 Dec 2018 04:12:02 -0800
Message-ID: <00e6245fa1f945960f501cb50175fbbcc870e19f.camel@intel.com>
Subject: Re: [PATCH 05/15] iwlwifi: don't define OTP_LOW_IMAGE_SIZE per
 family, but per size
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 03 Dec 2018 14:12:01 +0200
In-Reply-To: <874lc06w3p.fsf@kamboji.qca.qualcomm.com>
References: <20181123112631.29360-1-luca@coelho.fi>
         <20181123112631.29360-6-luca@coelho.fi>
         <874lc06w3p.fsf@kamboji.qca.qualcomm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2018-11-29 at 12:01 +0200, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Luca Coelho <luciano.coelho@intel.com>
> > 
> > Using OTP_LOW_IMAGE_SIZE_FAMILY_8000/9000/22000 only obfuscates the
> > actual values, since these 3 are the same.  Redefine the values per
> > size so it's easier to understand and compare the different
> > configurations.
> > 
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> [...]
> 
> > --- a/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
> > +++ b/drivers/net/wireless/intel/iwlwifi/cfg/1000.c
> > @@ -48,7 +48,7 @@
> >  static const struct iwl_base_params iwl1000_base_params = {
> >  	.num_of_queues = IWLAGN_NUM_QUEUES,
> >  	.max_tfd_queue_size = 256,
> > -	.eeprom_size = OTP_LOW_IMAGE_SIZE,
> > +	/* .eeprom_size = OTP_LOW_IMAGE_SIZE_2K, */
> 
> Why this is commented out?

Nice catch! I have no idea what happened here, this was never commented
out in our internal tree... I'll send v2.

--
Luca.

