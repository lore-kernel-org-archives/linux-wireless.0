Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D358C282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 07:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 541CA2176F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 07:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfDQHDD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 03:03:03 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53500 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728335AbfDQHDC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 03:03:02 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hGeau-0006f6-4i; Wed, 17 Apr 2019 10:02:56 +0300
Message-ID: <05f0923dce988a9c4cfb870013c49ca4136afbdb.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Laura Abbott <labbott@redhat.com>, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, stable <stable@vger.kernel.org>
Date:   Wed, 17 Apr 2019 10:02:54 +0300
In-Reply-To: <20190330093152.GB14300@kroah.com>
References: <20190122152151.16139-24-gregkh@linuxfoundation.org>
         <03bb68be-8e42-a463-2d57-3be051dc2016@redhat.com>
         <20190327012600.GA3649@kroah.com>
         <5660d50d-6cbf-3b36-6e6c-312b1617ed23@redhat.com>
         <20190327015346.GA17979@kroah.com>
         <5f9c8beda0e925b079aa9342ce1c9523659837a4.camel@coelho.fi>
         <20190330092247.GA14300@kroah.com> <20190330093152.GB14300@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] iwlwifi: properly check debugfs dentry before using it
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2019-03-30 at 10:31 +0100, Greg Kroah-Hartman wrote:
> debugfs can now report an error code if something went wrong instead
> of
> just NULL.  So if the return value is to be used as a "real" dentry,
> it
> needs to be checked if it is an error before dereferencing it.
> 
> This is now happening because of ff9fb72bc077 ("debugfs: return error
> values, not NULL").  If multiple iwlwifi devices are in the system,
> this
> can cause problems when the driver attempts to create the main
> debugfs
> directory again.  Later on in the code we fail horribly by trying to
> dereference a pointer that is an error value.
> 
> Reported-by: Laura Abbott <labbott@redhat.com>
> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: Intel Linux Wireless <linuxwifi@intel.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: stable <stable@vger.kernel.org> # 5.0
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
> b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
> index 2453ceabf00d..6925527d8457 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
> @@ -774,8 +774,7 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm
> *mvm, struct ieee80211_vif *vif)
>  		return;
>  
>  	mvmvif->dbgfs_dir = debugfs_create_dir("iwlmvm", dbgfs_dir);
> -
> -	if (!mvmvif->dbgfs_dir) {
> +	if (IS_ERR_OR_NULL(mvmvif->dbgfs_dir)) {
>  		IWL_ERR(mvm, "Failed to create debugfs directory under
> %pd\n",
>  			dbgfs_dir);
>  		return;

Thanks! I've applied this internally and will send upstream for v5.1-
rc* following our normal upstreaming process.

I added the other Reported-by that Laura asked for and added "mvm:" to
the subject.

--
Cheers,
Luca.

