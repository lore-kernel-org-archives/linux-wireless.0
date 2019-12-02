Return-Path: <SRS0=eHb9=ZY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DC8C43215
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Dec 2019 10:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CF01217D9
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Dec 2019 10:14:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="I+VtD9c8";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="gfo1tzhC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfLBKOz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 2 Dec 2019 05:14:55 -0500
Received: from a27-10.smtp-out.us-west-2.amazonses.com ([54.240.27.10]:36270
        "EHLO a27-10.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727574AbfLBKOy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 2 Dec 2019 05:14:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575281693;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=7jfhDHYrFmOsa+E/bKLTMYNOGK/iizPKQh4d9/trfkw=;
        b=I+VtD9c8/yhepRWKpJGbfldALQGUzaPOJt1d84nQ3vl8MDD+hFpOkOpQ+VS0Y7jD
        BvKoqMt8PGjuV9iYlGTdBIXcUCBKzVv7vd5/y1uO9v+5L6gFnTU0f6rJZZeQJFB0p/F
        TVMiSBuT22Loer2Uae44hk8VL9xHa3V6djAORx+U=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575281693;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=7jfhDHYrFmOsa+E/bKLTMYNOGK/iizPKQh4d9/trfkw=;
        b=gfo1tzhCNS3ennAL7euFkBVZBXWb62z9wmDCOPwNwj8YMgWF9O8pvA90NScLiQdL
        PNsyQWGr5adU6r8+cVc3VxndlPWbeqxpHKn5RIG+XSd8Tlo326OqerKm/vNgof29yId
        DuOsBNkkR7tRlASq7XqXxpBaq8+EqCyd344wI8+I=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 2 Dec 2019 10:14:53 +0000
From:   wgong@codeaurora.org
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] ath: add support for special 0x0 regulatory domain
In-Reply-To: <20191202100833.0C1B9C433CB@smtp.codeaurora.org>
References: <0101016eb614d832-1f2459b1-1555-4ce7-8f90-5704d201bc10-000000@us-west-2.amazonses.com>
 <20191202100833.0C1B9C433CB@smtp.codeaurora.org>
Message-ID: <0101016ec61b1404-3332a101-8b2a-4d7f-a0fe-ed043075ee81-000000@us-west-2.amazonses.com>
X-Sender: wgong@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.12.02-54.240.27.10
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-12-02 18:08, Kalle Valo wrote:
> Wen Gong <wgong@codeaurora.org> wrote:
> 
>> Some sdio chips of rome QCA6174's regulatory domain code of EEPROM is
>> empty, then ath_is_world_regd will return false for this case, and
>> it will lead function __ath_reg_dyn_country not work, thus the 
>> regdomain
>> will not update for NL80211_REGDOM_SET_BY_COUNTRY_IE type, it result
>> ath10k set the same regdomain/reg_5ghz_ctl/reg_2ghz_ctl to firmware,
>> then the tx power will not changed with different regdomain's AP. The
>> regulatory domain code of EEPROM of some QCA6174 PCIE chip is 0x6c, it
>> means world wide regdomain, for this chip, it does not have the issue.
>> 
>> For empty reulatory domain code chip, set it to world regulatory 
>> domain
>> in functio ath_regd_sanitize, then it will fix the issue.
>> 
>> Tested with QCA6174 SDIO with firmware
>> WLAN.RMH.4.4.1-00029.
>> 
>> Signed-off-by: Wen Gong <wgong@codeaurora.org>
>> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> 
> Patch applied to ath-next branch of ath.git, thanks.
> 
> 2dc016599cfa ath: add support for special 0x0 regulatory domain
But I did not see it in ath-next now.
https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/log/drivers/net/wireless/ath?h=ath-next
is it has some delay?
