Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43B5BC49361
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jun 2021 17:59:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2CDFD613D5
	for <linux-wireless@archiver.kernel.org>; Thu, 17 Jun 2021 17:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbhFQSBz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 17 Jun 2021 14:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233262AbhFQSBm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 17 Jun 2021 14:01:42 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B359C0613A2
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2021 10:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:From:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=v40nMHwOtRaKTUDeGhfNF5508cHey0NmopoGXvvxr+M=; b=JKxqz9SXxD33n/K1sgphRSadPB
        fE858ogNbnGN0OVdQW496blpRWNjehYrVn3ZlOspz6yzDdXBLTUUG4CYijZyJQCSdxdBvXqscPSC0
        shF61mpsnBmNabjZyjM69ZNPozPMWN0YAUL4C2vX74JL8SGxp1Co1ppfawLzJmUKLPxM=;
Received: from p54ae9ff2.dip0.t-ipconnect.de ([84.174.159.242] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ltwIZ-0007zT-1t; Thu, 17 Jun 2021 19:59:27 +0200
Subject: Re: [PATCH v2 1/4] mac80211: call ieee80211_tx_h_rate_ctrl() when
 dequeue
From:   Felix Fietkau <nbd@nbd.name>
To:     Ryder Lee <ryder.lee@mediatek.com>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        Bo Jiao <bo.jiao@mediatek.com>,
        Sujuan Chen <sujuan.chen@mediatek.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
References: <2176023d8f13d82d093452e1c105609396c30622.1622164961.git.ryder.lee@mediatek.com>
 <a89137bf-401b-c9d0-8848-d79ea9e2a9c3@nbd.name>
Message-ID: <4d652f4a-c258-f248-911f-28238531ae4d@nbd.name>
Date:   Thu, 17 Jun 2021 19:59:26 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <a89137bf-401b-c9d0-8848-d79ea9e2a9c3@nbd.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2021-06-17 12:50, Felix Fietkau wrote:
> 
> On 2021-05-28 08:05, Ryder Lee wrote:
>> Make ieee80211_tx_h_rate_ctrl() get called on dequeue to improve
>> performance since it reduces the turnaround time for rate control.
>> 
>> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
>> ---
>> change since v2 - roll ieee80211_tx_h_rate_ctrl checks into one condition
> There were some OpenWrt crash reported which appear to be related to
> this patch. I was able to reproduce a deadlock with ath9k, and I'm
> currently looking into it.
Some more information about the crash:
- ath9k calls ieee80211_tx_dequeue with the tx queue lock held
- ieee80211_tx_dequeue calls minstrel get_rate
- get_rate calls minstrel_aggr_check
- minstrel_aggr check calls ieee80211_start_tx_ba_session
- ieee80211_start_tx_ba_session tries to send a frame
- ath9k tries to acquire the tx lock it already holds

I've fixed this in v3 by moving the logic of minstrel_aggr_check into
mac80211

- Felix
