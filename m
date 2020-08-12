Return-Path: <SRS0=580q=BW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1168C433E0
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Aug 2020 09:31:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BB9620885
	for <linux-wireless@archiver.kernel.org>; Wed, 12 Aug 2020 09:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597224673;
	bh=W70Yqhwaxhy7Pi6U0i+5jD2GHrYkZ2YQe85jUt5Pa6A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wGQU6dog91ZNMEgOXO9LB4JlSk3zwLsuwXekGLGe3PjbyuXFOaH8gySt/bd/rjupf
	 sOMxqUYlBcYS7i1M9FYXXf3HZOsIH1rIbqGc4ZHT9cbCRTw0Q/B7OQ8mMVLcUIhH+a
	 /atlLd2H+GL5vKrx/ySFo5p/Xl+sGbuA9/L7sISo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbgHLJbM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 12 Aug 2020 05:31:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42118 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726595AbgHLJbM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Aug 2020 05:31:12 -0400
Received: from pali.im (pali.im [31.31.79.79])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86C902076B;
        Wed, 12 Aug 2020 09:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597224671;
        bh=W70Yqhwaxhy7Pi6U0i+5jD2GHrYkZ2YQe85jUt5Pa6A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xpjom1OZMaBTteRJcNwhNLWQHWIayy9LBkutrV3oXgfbVaHHYU9lCQc92bpS3SqYU
         O+KAH5ZbneDlaKjBSe+A68r+4XT1WpEYIwPBG18GHI2S3z76NKGYZcUqsnlAkJmSmA
         WjjFYpwkbuhxXz9suNKnZNiArLcX6p/2Y4doN22U=
Received: by pali.im (Postfix)
        id 8DDAC9E2; Wed, 12 Aug 2020 11:31:09 +0200 (CEST)
Date:   Wed, 12 Aug 2020 11:31:09 +0200
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali@kernel.org>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     ath10k@lists.infradead.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>
Subject: Re: CVE-2020-3702: Firmware updates for ath9k and ath10k chips
Message-ID: <20200812093109.og7rkefrwxdyogvg@pali>
References: <20200810090126.mtu3uocpcjg5se5e@pali>
 <20200812083600.6zxdf5pfktdzggd6@pali>
 <87lfik1av8.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lfik1av8.fsf@toke.dk>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wednesday 12 August 2020 11:17:47 Toke Høiland-Jørgensen wrote:
> Pali Rohár <pali@kernel.org> writes:
> 
> > On Monday 10 August 2020 11:01:26 Pali Rohár wrote:
> >> Hello!
> >> 
> >> ESET engineers on their blog published some information about new
> >> security vulnerability CVE-2020-3702 in ath9k wifi cards:
> >> https://www.welivesecurity.com/2020/08/06/beyond-kr00k-even-more-wifi-chips-vulnerable-eavesdropping/
> >> 
> >> According to Qualcomm security bulletin this CVE-2020-3702 affects also
> >> some Qualcomm IPQ chips which are handled by ath10k driver:
> >> https://www.qualcomm.com/company/product-security/bulletins/august-2020-security-bulletin#_cve-2020-3702
> >> 
> >> Kalle, could you or other people from Qualcomm provide updated and fixed
> >> version of ath9k and ath10k firmwares in linux-firmware git repository?
> >> 
> >> According to Qualcomm security bulletin this issue has Critical security
> >> rating, so I think fixed firmware files should be updated also in stable
> >> releases of linux distributions.
> >
> > Hello!
> >
> > Qualcomm has already sent following statement to media:
> >
> >     Qualcomm has already made mitigations available to OEMs in May 2020,
> >     and we encourage end users to update their devices as patches have
> >     become available from OEMs.
> >
> > And based on information from ESET blog post, Qualcomm's proprietary
> > driver for these wifi cards is fixed since Qualcomm July release.
> >
> > Could somebody react and provide some details when fixes would be
> > available for ath9k and ath10k Linux drivers? And what is current state
> > of this issue for Linux?
> >
> > I'm looking at ath9k and ath10k git trees [1] [2] [3] and I do not see
> > there any change which could be related to CVE-2020-3702.
> 
> How about these, from March:
> 
> a0761a301746 ("mac80211: drop data frames without key on encrypted links")
> ce2e1ca70307 ("mac80211: Check port authorization in the ieee80211_tx_dequeue() case")
> b16798f5b907 ("mac80211: mark station unauthorized before key removal")

Thank you for update! I will look at these commits if they are relevant.
Because ESET wrote that problem is in ath9k driver I have not looked at
mac80211 layer code.

> -Toke
> 
