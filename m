Return-Path: <SRS0=rB3s=VV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29B46C7618B
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 12:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F26AC21850
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Jul 2019 12:10:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="POA6WCML";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="POA6WCML"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727724AbfGXMKs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Jul 2019 08:10:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:33626 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfGXMKs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jul 2019 08:10:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id DA30260364; Wed, 24 Jul 2019 12:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563970246;
        bh=EfhXYznOo64ISctI1lmzX0uJT8//sSXNyzt1BeV0rg4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=POA6WCMLiz6iMUa1UlSBvYqsAgBP8MV6/T+ysAzSK0t/K8EAK2t8nntthFD1nyrwH
         o1ARNBfPhQecDWVNhL1XZOC4RdSIkrxDRAnM0QHbVUrzpGXs6v1l4hILNzSsjoumVf
         JaB3vUANqqyd6IH1YVsXTHRGW46l6nJjfB72psKM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B024560314;
        Wed, 24 Jul 2019 12:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563970246;
        bh=EfhXYznOo64ISctI1lmzX0uJT8//sSXNyzt1BeV0rg4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=POA6WCMLiz6iMUa1UlSBvYqsAgBP8MV6/T+ysAzSK0t/K8EAK2t8nntthFD1nyrwH
         o1ARNBfPhQecDWVNhL1XZOC4RdSIkrxDRAnM0QHbVUrzpGXs6v1l4hILNzSsjoumVf
         JaB3vUANqqyd6IH1YVsXTHRGW46l6nJjfB72psKM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B024560314
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Wen Gong <wgong@qti.qualcomm.com>
Cc:     Ben Greear <greearb@candelatech.com>,
        Wen Gong <wgong@codeaurora.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: add mic bytes for pmf management packet
References: <1560757079-19266-1-git-send-email-wgong@codeaurora.org>
        <136d04d4-671b-8dde-2abd-63070b07bd26@candelatech.com>
        <9403fef58374427fa76fb32ee64ee333@aptaiexm02f.ap.qualcomm.com>
Date:   Wed, 24 Jul 2019 15:10:42 +0300
In-Reply-To: <9403fef58374427fa76fb32ee64ee333@aptaiexm02f.ap.qualcomm.com>
        (Wen Gong's message of "Tue, 18 Jun 2019 07:21:30 +0000")
Message-ID: <87v9vrzl8d.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Wen Gong <wgong@qti.qualcomm.com> writes:

>> -----Original Message-----
>> From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Ben
>> Greear
>> Sent: Tuesday, June 18, 2019 12:04 AM
>> To: Wen Gong <wgong@codeaurora.org>; ath10k@lists.infradead.org
>> Cc: linux-wireless@vger.kernel.org
>> Subject: [EXT] Re: [PATCH] ath10k: add mic bytes for pmf management
>> packet
>> 
>> I was looking at mac80211 code recently, and it seems some action
>> frames are NOT supposed to be protected.  I added my own helper
>> method to my local ath10k.  Maybe you want to use this?
>> 
>> 
>> /* Copied from ieee80211_is_robust_mgmt_frame, but disable the check for
>> has_protected
>>   * since we do tx hw crypt, and it won't actually be encrypted even when this
>> flag is
>>   * set.
>>   */
>> bool ieee80211_is_robust_mgmt_frame_tx(struct ieee80211_hdr *hdr)
>> {
>>          if (ieee80211_is_disassoc(hdr->frame_control) ||
>>              ieee80211_is_deauth(hdr->frame_control))
>>                  return true;
>> 
>>          if (ieee80211_is_action(hdr->frame_control)) {
>>                  u8 *category;
>> 
>>                  /*
>>                   * Action frames, excluding Public Action frames, are Robust
>>                   * Management Frames. However, if we are looking at a Protected
>>                   * frame, skip the check since the data may be encrypted and
>>                   * the frame has already been found to be a Robust Management
>>                   * Frame (by the other end).
>>                   */
>> 		/*
>> 		if (ieee80211_has_protected(hdr->frame_control))
>>                          return true;
>> 		*/
>>                  category = ((u8 *) hdr) + 24;
>>                  return *category != WLAN_CATEGORY_PUBLIC &&
>>                          *category != WLAN_CATEGORY_HT &&
>>                          *category != WLAN_CATEGORY_WNM_UNPROTECTED &&
>>                          *category != WLAN_CATEGORY_SELF_PROTECTED &&
>>                          *category != WLAN_CATEGORY_UNPROT_DMG &&
>>                          *category != WLAN_CATEGORY_VHT &&
>>                          *category != WLAN_CATEGORY_VENDOR_SPECIFIC;
>>          }
>> 
>>          return false;
>> }
>> 
>> Thanks,
>> Ben
>> 
>> > +
>> >   	data_len = msdu->len;
>> >
>> >   	switch (txmode) {
>> >
>> 
>> 
> Thanks Ben,
>
> seems the ieee80211_is_robust_mgmt_frame_tx is not 
> match my change.

So what's the conclusion, can I take this patch?

-- 
Kalle Valo
