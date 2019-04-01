Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5CBFC10F05
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 15:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8819D20880
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 15:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727190AbfDAPja (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 11:39:30 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:45246 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726905AbfDAPja (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 11:39:30 -0400
Received: by mail-qt1-f195.google.com with SMTP id v20so11086468qtv.12
        for <linux-wireless@vger.kernel.org>; Mon, 01 Apr 2019 08:39:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gBxLW53d+ZRCybLNVSS/VBL4MZakdmMI6ZYXMCl28Y8=;
        b=IgO6WMdqK3qbdbDVp3yevB/po3M62kdaKhSe9+0Y2LJ7tFLSci1hJ0XoTMK1p6q9B6
         M8cVY3PxG03m3idxVeoVBLOkEOJ0NAxjfhvQnh6wKCIN13GzslrMG9c27cPYYOPTDxEo
         73bvaVXkJIeCZHFhLG6HmxnJr5hFcUdSPlRzIOhT6h4oaMjg9zSthF/fhvPtQbY4ZLab
         Ok1yjNa4SpiGl9VXQma2CXaT2lNAX6qt50Yr15gODsQ3pqjNXm5g6Vx7R72FejXgnNrr
         5c73BSZaWHahVd2CvDzItkaZ7PNWFnKhQavXZCdVv5YsZaxCdrsuZbx/DVcyEE4aqbc/
         eW6A==
X-Gm-Message-State: APjAAAVdBFT1utjBLxhx0JzZc/ja1ThqFcvCTvrZhFNTWaHLMIafW6b1
        qQrastMcXt6DmHgZcBrSeIv2RQ==
X-Google-Smtp-Source: APXvYqxsZTTAvWfeUg60NgDxZkZg2oN5HSx4K1OFnKed7mF5ZJSQGr2dZgLeYsN60aceHRNRrPf6Fw==
X-Received: by 2002:ac8:18e6:: with SMTP id o35mr53823517qtk.80.1554133169725;
        Mon, 01 Apr 2019 08:39:29 -0700 (PDT)
Received: from ?IPv6:2601:602:9800:dae6::fa4a? ([2601:602:9800:dae6::fa4a])
        by smtp.gmail.com with ESMTPSA id w8sm5440314qki.54.2019.04.01.08.39.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Apr 2019 08:39:28 -0700 (PDT)
Subject: Re: [PATCH] iwlwifi: properly check debugfs dentry before using it
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luca Coelho <luca@coelho.fi>
Cc:     linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>,
        stable <stable@vger.kernel.org>
References: <20190122152151.16139-24-gregkh@linuxfoundation.org>
 <03bb68be-8e42-a463-2d57-3be051dc2016@redhat.com>
 <20190327012600.GA3649@kroah.com>
 <5660d50d-6cbf-3b36-6e6c-312b1617ed23@redhat.com>
 <20190327015346.GA17979@kroah.com>
 <5f9c8beda0e925b079aa9342ce1c9523659837a4.camel@coelho.fi>
 <20190330092247.GA14300@kroah.com> <20190330093152.GB14300@kroah.com>
From:   Laura Abbott <labbott@redhat.com>
Message-ID: <50bffbea-69b5-71f4-0b9c-aead1ffc54da@redhat.com>
Date:   Mon, 1 Apr 2019 08:39:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <20190330093152.GB14300@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/30/19 2:31 AM, Greg Kroah-Hartman wrote:
> debugfs can now report an error code if something went wrong instead of
> just NULL.  So if the return value is to be used as a "real" dentry, it
> needs to be checked if it is an error before dereferencing it.
> 
> This is now happening because of ff9fb72bc077 ("debugfs: return error
> values, not NULL").  If multiple iwlwifi devices are in the system, this
> can cause problems when the driver attempts to create the main debugfs
> directory again.  Later on in the code we fail horribly by trying to
> dereference a pointer that is an error value.
> 
> Reported-by: Laura Abbott <labbott@redhat.com>

Can you add

Reported-by:  Gabriel Ramirez <gabriello.ramirez@gmail.com>

for the bugzilla reporter who took the time to do the bisect?
I'll ask for testing as well.

> Cc: Johannes Berg <johannes.berg@intel.com>
> Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Cc: Luca Coelho <luciano.coelho@intel.com>
> Cc: Intel Linux Wireless <linuxwifi@intel.com>
> Cc: Kalle Valo <kvalo@codeaurora.org>
> Cc: stable <stable@vger.kernel.org> # 5.0
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
> index 2453ceabf00d..6925527d8457 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
> @@ -774,8 +774,7 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
>   		return;
>   
>   	mvmvif->dbgfs_dir = debugfs_create_dir("iwlmvm", dbgfs_dir);
> -
> -	if (!mvmvif->dbgfs_dir) {
> +	if (IS_ERR_OR_NULL(mvmvif->dbgfs_dir)) {
>   		IWL_ERR(mvm, "Failed to create debugfs directory under %pd\n",
>   			dbgfs_dir);
>   		return;
> 

