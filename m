Return-Path: <SRS0=rthY=NG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 442EBC6786E
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:58:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE8FC20824
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Oct 2018 12:58:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HQezOqgX";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="ez+kw7lO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EE8FC20824
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726128AbeJZVfL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Oct 2018 17:35:11 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:51252 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726006AbeJZVfL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Oct 2018 17:35:11 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C5944612F2; Fri, 26 Oct 2018 12:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540558690;
        bh=qb7lBPqvyvPG9Wqw+QgZux9DRR8uE4c6nHDb0L0O7Uc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HQezOqgXdgO1GkBdvZIihnoNxTlk7DF77lQPmAPfXbdNkHRA9oQwQSaSK3MTgldsw
         YXs17aa9Cio9WIiQ537ZcJ3gRVmg3SXOFWVs5Gjf5QpdfZnu9UEG4D892YqDhtkZlF
         I0CwBGy3PtxzBrxCxQhqKRFqdyTuRdEC12ZVq7do=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 49FCA60CEC;
        Fri, 26 Oct 2018 12:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540558684;
        bh=qb7lBPqvyvPG9Wqw+QgZux9DRR8uE4c6nHDb0L0O7Uc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ez+kw7lOCrggnBzbU3nUV3HdxCyANFPvG3MLd1DvTyC/yXhZ4voBC3imzzTCmqzqU
         4Vex1py0FXeuzJLdXynXrondptBGtZcUv1lE2I1Tg9eEedr9ItNN+lReTmDhTG7jMF
         R9D9/FXGYTZ406B0EBnbA5F6ITd8z7hVMc1b5BIs=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 26 Oct 2018 18:28:04 +0530
From:   Anilkumar Kolli <akolli@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath10k: report tx rate using
 ieee80211_tx_rate_update()
In-Reply-To: <20181012113515.202BD6063F@smtp.codeaurora.org>
References: <1539261904-9016-3-git-send-email-akolli@codeaurora.org>
 <20181012113515.202BD6063F@smtp.codeaurora.org>
Message-ID: <186319d123468bce8673c1462507d346@codeaurora.org>
X-Sender: akolli@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-12 17:05, Kalle Valo wrote:
> Anilkumar Kolli <akolli@codeaurora.org> wrote:
> 
>> Mesh path metric needs tx rate information from ieee80211_tx_status()
>> call but in ath10k there is no mechanism to report tx rate information
>> via ieee80211_tx_status(), the tx rate is only accessible via
>> sta_statiscs() op.
>> 
>> Per peer tx stats has tx rate info available, Tx rate is available
>> to ath10k driver after every 4 PPDU sent in the air. For each PPDU,
>> ath10k driver updates rate informattion to mac80211 using
>> ieee80211_tx_rate_update().
>> 
>> Per peer txrate information is updated through per peer statistics
>> and is available for QCA9888/QCA9984/QCA4019/QCA998X only
>> 
>> Tested on QCA9984 with firmware-5.bin_10.4-3.5.3-00053
>> Tested on QCA998X with firmware-5.bin_10.2.4-1.0-00036
>> 
>> Signed-off-by: Anilkumar Kolli <akolli@codeaurora.org>
> 
> Depends on:
> 
> f8252e7b5a83 mac80211: implement ieee80211_tx_rate_update to update 
> rate
> 
> Currently in mac80211-next.

mac80211 dependent patch is merged.

Please drop this patch, I have rebased this patch on latest ath.git,
and posted v2 https://patchwork.kernel.org/patch/10656927/

-- 
Thanks
Anil.
