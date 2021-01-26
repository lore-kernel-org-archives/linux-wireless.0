Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826A2C433E9
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Jan 2021 13:10:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 259D8207B3
	for <linux-wireless@archiver.kernel.org>; Wed, 27 Jan 2021 13:10:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S313744AbhAZWow (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Jan 2021 17:44:52 -0500
Received: from smtprelay0161.hostedemail.com ([216.40.44.161]:46970 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727782AbhAZREe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jan 2021 12:04:34 -0500
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave01.hostedemail.com (Postfix) with ESMTP id A67621803DDAB;
        Tue, 26 Jan 2021 16:46:57 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id E64DE180A90FF;
        Tue, 26 Jan 2021 16:46:55 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: burn65_26005d02758f
X-Filterd-Recvd-Size: 2031
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf05.hostedemail.com (Postfix) with ESMTPA;
        Tue, 26 Jan 2021 16:46:54 +0000 (UTC)
Message-ID: <7d113851044ad16fa7f4c4e5c32af723e2f3c359.camel@perches.com>
Subject: Re: [PATCH v3] rtlwifi: Simplify bool comparison
From:   Joe Perches <joe@perches.com>
To:     Jiapeng Zhong <abaci-bugfix@linux.alibaba.com>,
        kvalo@codeaurora.org
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 26 Jan 2021 08:46:53 -0800
In-Reply-To: <1611649916-21936-1-git-send-email-abaci-bugfix@linux.alibaba.com>
References: <1611649916-21936-1-git-send-email-abaci-bugfix@linux.alibaba.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2021-01-26 at 16:31 +0800, Jiapeng Zhong wrote:
> Fix the following coccicheck warning:
> ./drivers/net/wireless/realtek/rtlwifi/ps.c:798:7-21: WARNING:
> Comparison to bool
> ./drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c:3848:7-17:
> WARNING: Comparison of 0/1 to bool variable
[]
> diff --git a/drivers/net/wireless/realtek/rtlwifi/ps.c b/drivers/net/wireless/realtek/rtlwifi/ps.c
[]
> @@ -798,9 +798,9 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, void *data,
>  		ie += 3 + noa_len;
>  	}
>  
> 
> -	if (find_p2p_ie == true) {
> +	if (find_p2p_ie) {
>  		if ((p2pinfo->p2p_ps_mode > P2P_PS_NONE) &&
> -		    (find_p2p_ps_ie == false))
> +		    (!find_p2p_ps_ie))
>  			rtl_p2p_ps_cmd(hw, P2P_PS_DISABLE);
>  	}

Always review suggested coccinelle patches before submission and
see if there are ways to improve the code beyond what the spatch
tool suggests.

Perhaps integrate these tests and removed an indent level too:

	if (find_p2p_ie && !find_p2p_ps_ie &&
	    p2pinfo->p2p_ps_mode > P2P_PS_NONE)
		rtl_p2p_ps_cmd(hw, P2P_PS_DISABLE);


