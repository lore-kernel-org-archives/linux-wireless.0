Return-Path: <SRS0=ru0V=B3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90AECC433E1
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Aug 2020 10:36:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 70AFB20786
	for <linux-wireless@archiver.kernel.org>; Mon, 17 Aug 2020 10:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597660578;
	bh=ifjO2f2SSHjGOYyCqga//H1fdXEHCGT7yqXkguLiOoM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=dKLuQ86DPktDSSItzFvKmtMYS9HwiDtA9modH5IEmZGgUMPzz6oHr3+naqdAuCThN
	 k7GP1IQ4vXTk5gH0qOq5IIWm48uoGlY4i0Yg/AaH6Pn0FHXDMpEfHxsXgLREsFkoWX
	 EeDbIPE2L6L5iRVOGgW9q/Rx14/fe2r9Xm0VlBXQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726769AbgHQKgM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 17 Aug 2020 06:36:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:60282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726620AbgHQKgI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Aug 2020 06:36:08 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1CB7207DF;
        Mon, 17 Aug 2020 10:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597660568;
        bh=ifjO2f2SSHjGOYyCqga//H1fdXEHCGT7yqXkguLiOoM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UshTG6KzjiiqUxhwl60SYOmDkz3yTHeNMV654lBbQsU23F1o5UuFCLqKOwiW+7Gmb
         X+a4cHg9CjIyY/iFMs71VZs1rYb0D7Bm4wwyaqW3CaVTqccC866qlEAvT9naFQH+Xi
         7BWCLelkNGiT1tI3g2kOmvDVOdig4osAnHnFB77A=
Received: by pali.im (Postfix)
        id C3B799CF; Mon, 17 Aug 2020 12:36:05 +0200 (CEST)
Date:   Mon, 17 Aug 2020 12:36:05 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org
Subject: Re: CVE-2020-3702: Firmware updates for ath9k and ath10k chips
Message-ID: <20200817103605.qgwfbpz75ssuem7c@pali>
References: <20200810090126.mtu3uocpcjg5se5e@pali>
 <87a6ytlhk3.fsf@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87a6ytlhk3.fsf@codeaurora.org>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Monday 17 August 2020 12:58:52 Kalle Valo wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > ESET engineers on their blog published some information about new
> > security vulnerability CVE-2020-3702 in ath9k wifi cards:
> > https://www.welivesecurity.com/2020/08/06/beyond-kr00k-even-more-wifi-chips-vulnerable-eavesdropping/
> >
> > According to Qualcomm security bulletin this CVE-2020-3702 affects also
> > some Qualcomm IPQ chips which are handled by ath10k driver:
> > https://www.qualcomm.com/company/product-security/bulletins/august-2020-security-bulletin#_cve-2020-3702
> 
> I can't find any refererences to ath10k, or hardware with ath10k
> chipsets, in the links above. Where did you see it?

Now I'm looking at that security bulletin for CVE-2020-3702 and it
contains different list of affected chipset as at time when I wrote
previous email. Previously there were IPQ ath10k chipsets and no AR
chipsets. Now there are lot of ath9k AR9xxx and none of IPQ.

So meanwhile Qualcomm changed vulnerability list.
