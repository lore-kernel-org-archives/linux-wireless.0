Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A5D5C433B4
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Apr 2021 13:25:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DDE4610E6
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Apr 2021 13:25:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbhDHNZg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Apr 2021 09:25:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231158AbhDHNZf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Apr 2021 09:25:35 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28075C061760
        for <linux-wireless@vger.kernel.org>; Thu,  8 Apr 2021 06:25:23 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lUUeu-0090xF-Be; Thu, 08 Apr 2021 15:25:20 +0200
Message-ID: <0b89f56b37073b633b343a71a098247a53ec89f9.camel@sipsolutions.net>
Subject: Re: [PATCH] wireless:  Allow disabling TWT
From:   Johannes Berg <johannes@sipsolutions.net>
To:     greearb@candelatech.com, linux-wireless@vger.kernel.org
Date:   Thu, 08 Apr 2021 15:25:19 +0200
In-Reply-To: <20210306162010.16706-1-greearb@candelatech.com> (sfid-20210306_172115_779009_173A00D2)
References: <20210306162010.16706-1-greearb@candelatech.com>
         (sfid-20210306_172115_779009_173A00D2)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 (3.38.4-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2021-03-06 at 08:20 -0800, greearb@candelatech.com wrote:
> 
> +	/* Apply overrides as needed. */
> +	if (ifmgd->flags & IEEE80211_STA_DISABLE_TWT) {
> +		if (ext_capa) {
> +			if (ext_capa && ext_capa->datalen > 10) {
> +				ext_capa->data[9] &= ~(WLAN_EXT_CAPA10_TWT_RESPONDER_SUPPORT);

So apart from the useless code (checking "ext_capa" twice, unnecessary
nested ifs, unnecessary parentheses), this can already be done entirely
by userspace, since it controls the ext capa we send.

> 
> -static bool ieee80211_twt_req_supported(const struct sta_info *sta,
> +static bool ieee80211_twt_req_supported(struct ieee80211_sub_if_data *sdata,
> +					const struct sta_info *sta,
>  					const struct ieee802_11_elems *elems)
> 

This code here seems possibly wrong anyway since it doesn't take local
capabilities into account, maybe it should, and then these changes
wouldn't be necessary?

> +	/* Apply overrides as needed. */
> +	if (ifmgd->flags & IEEE80211_STA_DISABLE_TWT) {
> +		struct ieee80211_he_cap_elem *hec;
> +		hec = (struct ieee80211_he_cap_elem *)(pos);
> +		hec->mac_cap_info[0] &= ~(IEEE80211_HE_MAC_CAP0_TWT_REQ);
> +		hec->mac_cap_info[0] &= ~(IEEE80211_HE_MAC_CAP0_TWT_RES);
> +	}

Wait, we actually have TWT capability *twice*, once in HE and once in
extended capabilities?! Fun.

But for this shouldn't we have the more general "HE capability override"
stuff that we have also for HT and VHT?


