Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B71A5C43381
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 14:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BF8220856
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 14:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfDAODF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 10:03:05 -0400
Received: from nbd.name ([46.4.11.11]:49084 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726882AbfDAODF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 10:03:05 -0400
Received: from p548c8605.dip0.t-ipconnect.de ([84.140.134.5] helo=[192.168.45.69])
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <john@phrozen.org>)
        id 1hAxWe-0002oq-V9; Mon, 01 Apr 2019 16:03:01 +0200
Subject: Re: [RFC V3 2/2] ath10k: add tx hw 802.11 encapusaltion offloading
 support
To:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
References: <20190401131416.22646-1-john@phrozen.org>
 <20190401131416.22646-3-john@phrozen.org>
From:   John Crispin <john@phrozen.org>
Message-ID: <b7be0488-46ce-f57a-35fd-a00479e0764d@phrozen.org>
Date:   Mon, 1 Apr 2019 16:02:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190401131416.22646-3-john@phrozen.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 01/04/2019 15:14, John Crispin wrote:
> @@ -5185,6 +5214,23 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
>   		break;
>   	}
>   
> +	switch (vif->type) {
> +	case NL80211_IFTYPE_AP:
> +		hw_encap = 1;
> +		break;
> +	case NL80211_IFTYPE_STATION:
> +//		if (!sdata->u.mgd.use_4addr)
> +			hw_encap = 1;
> +		break;
> +	case NL80211_IFTYPE_AP_VLAN:
> +//		if (!sdata->wdev.use_4addr)
> +			hw_encap = 1;
> +		break;
> +	default:
> +		break;
> +	}
> +	ieee80211_set_hw_80211_encap(vif, ar->ethernetmode & hw_encap);
> +
>   	/* Using vdev_id as queue number will make it very easy to do per-vif
>   	 * tx queue locking. This shouldn't wrap due to interface combinations
>   	 * but do a modulo for correctness sake and prevent using offchannel tx

Hi

I am not sure what the best way to handle the 4addr mode is. sdata is 
part of the subsystem and is not exposed to the drivers.Calling  
ieee80211_set_hw_80211_encap() from within the driver looked best to me 
at first glance and would avoid adding an extra op call to figure out if 
the if encap is supported. Any pointers on what the preferred solution 
would look like are welcome.

     John

