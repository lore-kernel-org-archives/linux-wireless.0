Return-Path: <SRS0=580q=BW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF5C7C433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Aug 2020 08:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A36C42083B
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Aug 2020 08:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597221364;
	bh=Q30l/tPzP2HbQb6g7zZ5/SgpfH+1JnoI4GEXu34i5zw=;
	h=Date:From:To:Subject:References:In-Reply-To:List-ID:From;
	b=TShkloj+F7rJvTB+1PAHinncZx8P/Emm6UcT9GQM/nTuiupcoVJf+nJw36gdj9sIp
	 NsNYEcCbaoHrM9el4AotixMssMX/0ukKBrcWDB/PvCYcIIr+nm6jiwoZQ7uRmGyqdG
	 cWS4IhmuEiyuujuRBhIrGb5ChcX9/6oVCVYF1ZAE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgHLIgD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Aug 2020 04:36:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726507AbgHLIgD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Aug 2020 04:36:03 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C060A20781;
        Wed, 12 Aug 2020 08:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597221362;
        bh=Q30l/tPzP2HbQb6g7zZ5/SgpfH+1JnoI4GEXu34i5zw=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=Sj/lK4kw4pbR5dZ4ocFIp/zyk7xhlcWQXTzuWAPcb5naPiSRl5nE89IwELWYtBlmD
         3ZPeikRhX6jPKRUVkyGICW0HhELiPBf5i+qPI8WzhbU5sq21M6kS15YB+W8pqJboy4
         68e3zU5UpMpy0k6anHM+CbpqADjAh1wwZqxpQemQ=
Received: by pali.im (Postfix)
        id CBC9E9E2; Wed, 12 Aug 2020 10:36:00 +0200 (CEST)
Date:   Wed, 12 Aug 2020 10:36:00 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     ath10k@lists.infradead.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: CVE-2020-3702: Firmware updates for ath9k and ath10k chips
Message-ID: <20200812083600.6zxdf5pfktdzggd6@pali>
References: <20200810090126.mtu3uocpcjg5se5e@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200810090126.mtu3uocpcjg5se5e@pali>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Monday 10 August 2020 11:01:26 Pali Rohár wrote:
> Hello!
> 
> ESET engineers on their blog published some information about new
> security vulnerability CVE-2020-3702 in ath9k wifi cards:
> https://www.welivesecurity.com/2020/08/06/beyond-kr00k-even-more-wifi-chips-vulnerable-eavesdropping/
> 
> According to Qualcomm security bulletin this CVE-2020-3702 affects also
> some Qualcomm IPQ chips which are handled by ath10k driver:
> https://www.qualcomm.com/company/product-security/bulletins/august-2020-security-bulletin#_cve-2020-3702
> 
> Kalle, could you or other people from Qualcomm provide updated and fixed
> version of ath9k and ath10k firmwares in linux-firmware git repository?
> 
> According to Qualcomm security bulletin this issue has Critical security
> rating, so I think fixed firmware files should be updated also in stable
> releases of linux distributions.

Hello!

Qualcomm has already sent following statement to media:

    Qualcomm has already made mitigations available to OEMs in May 2020,
    and we encourage end users to update their devices as patches have
    become available from OEMs.

And based on information from ESET blog post, Qualcomm's proprietary
driver for these wifi cards is fixed since Qualcomm July release.

Could somebody react and provide some details when fixes would be
available for ath9k and ath10k Linux drivers? And what is current state
of this issue for Linux?

I'm looking at ath9k and ath10k git trees [1] [2] [3] and I do not see
there any change which could be related to CVE-2020-3702.

Based on ESET tests, wifi cards which use ath9k driver (opensource, not
that Qualcomm proprietary) are still vulnerable.


[1] - https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/log/ath10k
[2] - https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/log/drivers/net/wireless/ath/ath10k?h=master-pending
[3] - https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/log/drivers/net/wireless/ath/ath9k?h=master-pending
