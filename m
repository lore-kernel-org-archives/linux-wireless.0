Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A075C433F5
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Apr 2022 09:12:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231749AbiDKJOR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Apr 2022 05:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234039AbiDKJOQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Apr 2022 05:14:16 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95CB3F8A6
        for <linux-wireless@vger.kernel.org>; Mon, 11 Apr 2022 02:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=yvjEssaxG0DzsEx++uGP41B2lWMe4ARhd49k70G78FE=;
        t=1649668323; x=1650877923; b=vpX2ILbjhb6EJBnfFOBOOG6bfj4UMdOJ/oWJg99ffFvzz+R
        K6xufheGPcHzEfwzxTNk0xsTFKJVqR6iSKQPhShJkQ241VmHZZDRj61UpbK23wtHBAinsmiNUern+
        2/2GLw4ad3vsVZIFKDFF6YTFSvYh4u9+EQjSr73IfZDa9wKYwepUcw/cV1P4/IqxG/VSbcde9iu1Z
        pQ3GFjqouFwM0gkITgD2DIjXelZCWFjr+nFWN6qKkK0xEN1iVehimNGLo9i5pbhJaArHjIYwIFZRR
        M57mC1Y6+pIc7WeaZ9sWxD766alGfQ1xcDotlLOQuUkvcPK8gUGmBf/zE6gcS4qQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ndq5X-008DZN-S1;
        Mon, 11 Apr 2022 11:11:59 +0200
Message-ID: <e90e6249a7330cd60434d184d358694785e465e7.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: consider Order bit to fill CCMP AAD
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Mon, 11 Apr 2022 11:11:59 +0200
In-Reply-To: <20220324004816.6202-1-pkshih@realtek.com>
References: <20220324004816.6202-1-pkshih@realtek.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2022-03-24 at 08:48 +0800, Ping-Ke Shih wrote:
> Follow IEEE 802.11-21 that HTC subfield masked to 0 for all data frames
> containing a QoS Control field.
> 

That seems fine, though not sure it's actually _relevant_ - how would we
possibly generate such frames in mac80211?

> It also defines the AAD length depends on
> QC and A4 fields, so change logic to determine length accordingly.

This I don't understand.

The code


> -	hdrlen = ieee80211_hdrlen(hdr->frame_control);
> -	len_a = hdrlen - 2;

sets it to the same thing, no?

Oh, I see - again you're worried about IEEE80211_HT_CTL_LEN I guess?

Maybe just subtract that again?

But either way, I'm not sure how we'd generate these in the first place.

johannes
