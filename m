Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1FE7C43334
	for <linux-wireless@archiver.kernel.org>; Wed,  8 Jun 2022 02:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbiFHCzZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 7 Jun 2022 22:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442550AbiFHCwf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Jun 2022 22:52:35 -0400
Received: from alexa-out.qualcomm.com (alexa-out.qualcomm.com [129.46.98.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053761A43C3
        for <linux-wireless@vger.kernel.org>; Tue,  7 Jun 2022 17:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1654647900; x=1686183900;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hlSiFHR4ZysHbi7t0JzTMdVqRHsFwkY40C5oQWFVqEY=;
  b=e5/tb617CColUDvK64itAt5e2c+h3gCiMjmQ+pu+mU/XhLwz0aQJmkE9
   90O3uFk8pbUs3uOAzSlWtsPD4UrTnhHuXBo7X/6TDKxwg8AN+xOYThHMl
   47eBrg+/qopdnOAA2n6zptSj4rH+DcTY2vGFH6cKXMB1mOHM5GLahW5Fn
   0=;
Received: from ironmsg07-lv.qualcomm.com ([10.47.202.151])
  by alexa-out.qualcomm.com with ESMTP; 07 Jun 2022 17:24:20 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg07-lv.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2022 17:24:20 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Tue, 7 Jun 2022 17:24:19 -0700
Received: from [10.110.12.119] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Tue, 7 Jun 2022
 17:24:18 -0700
Message-ID: <25ed0281-0880-1e8f-154c-53ee056e8879@quicinc.com>
Date:   Tue, 7 Jun 2022 17:24:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC v2] cfg80211: Indicate MLO connection info in connect and
 roam callbacks
Content-Language: en-US
To:     Veerendranath Jakkam <quic_vjakkam@quicinc.com>,
        <johannes@sipsolutions.net>
CC:     <linux-wireless@vger.kernel.org>
References: <1654536690-12588-1-git-send-email-quic_vjakkam@quicinc.com>
From:   Jeff Johnson <quic_jjohnson@quicinc.com>
In-Reply-To: <1654536690-12588-1-git-send-email-quic_vjakkam@quicinc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 6/6/2022 10:31 AM, Veerendranath Jakkam wrote:
> The MLO links used for connection with an MLD AP are decided by the
> driver in case of SME offloaded to driver.
> 
> Add support for the drivers to indicate the information of links used
> for MLO connection in connect and roam callbacks, update the connected
> links information in wdev from connect/roam result sent by driver.
> Also, send the connected links information to userspace.
> 
> Add a netlink flag attribute to indicate that userspace supports
> handling of MLO connection. Drivers must not do MLO connection when this
> flag is not set. This is to maintain backwards compatibility with older
> supplicant versions which doesn't have support for MLO connection.
> 
> Signed-off-by: Veerendranath Jakkam <quic_vjakkam@quicinc.com>
> ---
[snip]
I had one bikeshed observation...

> @@ -17176,6 +17199,38 @@ void nl80211_send_connect_result(struct cfg80211_registered_device *rdev,
>   	       nla_put(msg, NL80211_ATTR_PMKID, WLAN_PMKID_LEN, cr->fils.pmkid)))))
>   		goto nla_put_failure;
>   
> +	if (cr->valid_links) {
> +		int i = 0;

perhaps = 1? see below

> +		struct nlattr *nested;
> +
> +		nested = nla_nest_start(msg, NL80211_ATTR_MLO_LINKS);
> +		if (!nested)
> +			goto nla_put_failure;
> +
> +		for_each_valid_link(cr, link) {
> +			struct nlattr *nested_mlo_links;
> +			const u8 *bssid = cr->links[link].bss ?
> +					  cr->links[link].bss->bssid :
> +					  cr->links[link].bssid;
> +
> +			nested_mlo_links = nla_nest_start(msg, i + 1);

why i+1?
if you don't want to use 0 for the first entry (why not?) then init i to 1

alternately since this is the only place i is used, use ++i or i++ as 
you see fit and remove the i++ later

ultimately we should only need to calculate i+1 once

these comments apply to nl80211_send_roamed() as well

(BTW I do see this pattern in some of the existing code, but I also see 
0 being used for the first record)
