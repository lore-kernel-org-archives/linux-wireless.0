Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 934DCC432BE
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Jul 2021 09:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D0DD60E8E
	for <linux-wireless@archiver.kernel.org>; Fri, 23 Jul 2021 09:33:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbhGWIwg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 23 Jul 2021 04:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbhGWIwe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Jul 2021 04:52:34 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D410C061575
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jul 2021 02:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=k02mzyzwnJSXidYSsn7ZgHTab0GPbNCSJLd5UKesRMc=;
        t=1627032788; x=1628242388; b=Q0YnTdxjk58jE56PU+qxuoGcX+Gm9ecE6eGwsUyP7DuB1w/
        JzrFWA0zgT1pxwlEUOvMOqax526F5LFswgKIU9KcQIyxSDfANtgqX2OMPAhEZCryHLf1lJAIWI4OV
        +uJjjUDA0jNq8DRccKHD6I+12InqFnKKuEu/CF9573QJv5FxPJgyLpDaCHGzbORifpOLvRcA3BwkW
        3xFI8p43895L28CI+eY/rasnj5zAA7/c5IesUt4Jp1nn3molKvA2zVEL7zZVkIpwmVzwH3kMMxAoU
        VXAtCK087jkNuOuqR+X1F/vMkFiiV5kh6iPw60dGJqXLOvmGoVneRicc8DYQ3Nug==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1m6rVh-000UCP-Aw; Fri, 23 Jul 2021 11:33:04 +0200
Message-ID: <ed5566ab47d271b845635b5c731938f333ee96b6.camel@sipsolutions.net>
Subject: Re: [PATCH 7/9] mac80211: add parse transmit power envelope element
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Wen Gong <wgong@codeaurora.org>, ath11k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
Date:   Fri, 23 Jul 2021 11:33:03 +0200
In-Reply-To: <20210517201932.8860-8-wgong@codeaurora.org> (sfid-20210517_222024_817809_7D68677B)
References: <20210517201932.8860-1-wgong@codeaurora.org>
         <20210517201932.8860-8-wgong@codeaurora.org>
         (sfid-20210517_222024_817809_7D68677B)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2021-05-17 at 16:19 -0400, Wen Gong wrote:
> This patch is to add the transmit power envelope element parse in
> _ieee802_11_parse_elems_crc(), it maybe have more than one transmit
> power envelope element in a beacon.

This is really hard to read.

I'm sure you're aware of
https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#commit_messages

Also, FWIW, "This patch" language is pointless. We all know we're
talking about a patch. Or maybe even not, we may be reading the commit
later on.

> +		case WLAN_EID_TX_POWER_ENVELOPE:
> +			if (elems->tx_pwr_env_num >=
> ARRAY_SIZE(elems->tx_pwr_env))
> +				break;
> 

Seems to me this should do some validation on the actual element? It at
least has to have _one_ octet, afaict?

johannes

