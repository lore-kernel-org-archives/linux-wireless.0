Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22DECC4321E
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Dec 2022 16:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233255AbiLBQor (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Dec 2022 11:44:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232315AbiLBQoq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Dec 2022 11:44:46 -0500
Received: from mail.w1.fi (mail.w1.fi [212.71.239.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBF7AC7267
        for <linux-wireless@vger.kernel.org>; Fri,  2 Dec 2022 08:44:44 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mail.w1.fi (Postfix) with ESMTP id D7D86110C5;
        Fri,  2 Dec 2022 16:44:42 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at w1.fi
Received: from mail.w1.fi ([127.0.0.1])
        by localhost (mail.w1.fi [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id tNY8Uyut8I8P; Fri,  2 Dec 2022 16:44:41 +0000 (UTC)
Received: by jm (sSMTP sendmail emulation); Fri, 02 Dec 2022 18:44:39 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=w1.fi; s=default;
        t=1669999481; bh=r8HZ2bS5cqJ1/VBGbj5m3zZI2CByFc+wP085tk0/fJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PWEacge6g37eRxsJxSN0S2InxkIiqKeLybSsB6LDmDL4RLvwipy/I/0mvoxf3BoiN
         vn+NUtyYpZgxDx6K08wiSD9MfFmXnDyclXcDjSnsS/rJ00gObLHcHyPNkLU021T3Oq
         lSRGtYT9XF2kowpMLAnr/0/tkPmNM3OznUQWRkIoIYvmfawn6nuP/wJlCTrHHYvQ3W
         CB34HM3x76j/e3sWgwUU4ip5A0hsdXcbCpBEI5zq+hJDIzRCatS1UE2jXJM9u/VUDu
         iu61kyz/QDTYJPW/hd/1Xj0RTbmfvD9jjyR+EHa8OAcz3vgjl380kjbd3f4WHRwyO4
         VWXM9jEq/e/gg==
Date:   Fri, 2 Dec 2022 18:44:39 +0200
From:   Jouni Malinen <j@w1.fi>
To:     Aloka Dixit <quic_alokad@quicinc.com>
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 01/10] mac80211: generate EMA beacons in AP mode
Message-ID: <20221202164439.GA700414@w1.fi>
References: <20221114201912.22893-1-quic_alokad@quicinc.com>
 <20221114201912.22893-2-quic_alokad@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221114201912.22893-2-quic_alokad@quicinc.com>
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Nov 14, 2022 at 12:19:03PM -0800, Aloka Dixit wrote:
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> @@ -3338,7 +3338,8 @@ cfg80211_beacon_dup(struct cfg80211_beacon_data *beacon)
>  	len = beacon->head_len + beacon->tail_len + beacon->beacon_ies_len +
>  	      beacon->proberesp_ies_len + beacon->assocresp_ies_len +
>  	      beacon->probe_resp_len + beacon->lci_len + beacon->civicloc_len +
> -	      ieee80211_get_mbssid_beacon_len(beacon->mbssid_ies);
> +	      ieee80211_get_mbssid_beacon_len(beacon->mbssid_ies,
> +					      beacon->mbssid_ies->cnt);

beacon->mbssid_ies can be NULL here and that is going to result in a
kernel panic. For example, check with hostap.git test case
ap_ht_20_to_40_csa.

-- 
Jouni Malinen                                            PGP id EFC895FA
