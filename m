Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1665C433FE
	for <linux-wireless@archiver.kernel.org>; Mon,  7 Feb 2022 07:23:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242072AbiBGHWu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 7 Feb 2022 02:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241973AbiBGHVk (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Feb 2022 02:21:40 -0500
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BC6BC043181
        for <linux-wireless@vger.kernel.org>; Sun,  6 Feb 2022 23:21:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1644218499; x=1675754499;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=VzregUCreP/1epb5V1Bu2KdrrOnksp9ZbPM5lEeEpTw=;
  b=FBSAo9y+crfZ1R1NmiY/Qm+Qpc+OkCvcVY7byL1edZEVYr9s2zGu4pU+
   buMsJhH0SRbgGVxyMLRfg1Cl6xa83SAthTzYiWvO8idpqdTOPxOjhuRfN
   k+gvfjQoLdiraa1ecMhYZqJpp6g/vHQ45G0bNtkJxTVjEwqcRhJA150jZ
   A=;
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 06 Feb 2022 23:21:39 -0800
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg01-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Feb 2022 23:21:39 -0800
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.922.19; Sun, 6 Feb 2022 23:21:38 -0800
Received: from [10.213.109.137] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.922.19; Sun, 6 Feb 2022
 23:21:36 -0800
Subject: Re: [PATCH 04/19] ieee80211: Add EHT (802.11be) definitions
To:     Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
CC:     Ilan Peer <ilan.peer@intel.com>, Jia Ding <quic_jiad@quicinc.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Sriram R <quic_srirrama@quicinc.com>
References: <20220204220255.448224-1-johannes@sipsolutions.net>
 <20220204230119.1ee92202ac30.Id30a3ef2844b296efbd5486fe1da9ca36a95c5cf@changeid>
From:   Veerendranath Jakkam <quic_vjakkam@quicinc.com>
Message-ID: <3b9b2c7c-11ef-b949-f030-1847243f3d9d@quicinc.com>
Date:   Mon, 7 Feb 2022 12:51:33 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20220204230119.1ee92202ac30.Id30a3ef2844b296efbd5486fe1da9ca36a95c5cf@changeid>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01a.na.qualcomm.com (10.52.223.231) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/5/22 3:32 AM, Johannes Berg wrote:
> +/**
> + * struct ieee80211_eht_cap_elem - EHT capabilities element
> + * @fixed: fixed parts, see &ieee80211_eht_cap_elem_fixed
> + * @optional: optional parts
> + */
> +struct ieee80211_eht_cap_elem {
> +	struct ieee80211_eht_cap_elem_fixed fixed;
> +
> +	/*
> +	 * Followed by:
> +	 * Supported EHT-MCS And NSS Set field: 0, 3, 6, 9, or 12 octets.


Also, possible EHT-MCS And NSS Set field lengths are 3, 4, 6 or 9 octets.

> +	 * EHT PPE Thresholds field: variable length.
> +	 */
> +	u8 optional[];
> +} __packed;
> +

