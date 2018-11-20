Return-Path: <SRS0=1os+=N7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18E6C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 02:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 975BC2080C
	for <linux-wireless@archiver.kernel.org>; Tue, 20 Nov 2018 02:40:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IMdZR+18";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DW6JRPv3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 975BC2080C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730457AbeKTNGs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 20 Nov 2018 08:06:48 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:43934 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730361AbeKTNGs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Nov 2018 08:06:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 01E0160B11; Tue, 20 Nov 2018 02:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542681601;
        bh=n5XLz/bjhPrltqtFiwyuAXTudGdXYGFrQcu4bU7E460=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IMdZR+18lTrdi0+didHhl1H3DtgXQcxv8ng3Aw0XNWmMH+Wl2nqzpJPxEJ8RhhXXP
         T/ylxgC8YXcQGTlvzomqmHluV2UuHFcniFGXGnRk0aggap1eJFnUresY8LOK/qJ7Rr
         o30uonzapaZi1R6co/lxsfmI9729dgPETGN4pMt8=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 3C67B601D1;
        Tue, 20 Nov 2018 02:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542681600;
        bh=n5XLz/bjhPrltqtFiwyuAXTudGdXYGFrQcu4bU7E460=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DW6JRPv3tm0V+1wPNWt1L8zX/7LmrVzAUBcpK84z9iDU2o4jdAtlwe5JWMjcIAfS7
         kDa6rxcR4gg09dapwweZZYRVql2rhZfdRG2Gz8ABRBlKZr3xNHqmSPJ3yDXp21pqPl
         pJ+TR3aP5+xiPP2qJcO0b4iqwvYa/Mjvn6o8Fbow=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 20 Nov 2018 08:10:00 +0530
From:   Karthikeyan Periyasamy <periyasa@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] ath10k: Add QCA vendor command/attr support to
 filterneighbor BSS frames
In-Reply-To: <a28348956ba3fbfded80bc78ba1c0335df7edb75.camel@sipsolutions.net>
References: <1530791512-6915-3-git-send-email-periyasa@codeaurora.org>
 <20181005060031.BA1EB60BF4@smtp.codeaurora.org>
 <a28348956ba3fbfded80bc78ba1c0335df7edb75.camel@sipsolutions.net>
Message-ID: <c9b16303e344b2dcd4d52cf9c0830846@codeaurora.org>
X-Sender: periyasa@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-18 13:59, Johannes Berg wrote:

>> So I'm not sure what to do with this. A bpf type of filtering system 
>> in
>> mac80211 would be nice
> 
> Yes, I think we really need to start implementing that sooner rather
> than later. I had something, must see if I can find time for it.
> 
>> but then again we cannot benefit from HW offloading.
> 
> Yes, that's a concern. But how big of a concern is it really?
> 
> This patch only talks about "allow an AP" etc. and so while important,
> power isn't the _utmost_ concern like on mobile. Given an efficient
> filtering solution in software, would that be sufficient?

Assume in a scenario where there are multiple APs (One Center AP and 
Multiple repeater AP) in same operating channel.
Clients present in Neighbor APs causing higher traffic.

when we try to filter desire client packets,
In HW offload case, all Neighbor BSS packets are filtered by HW. so 
there is no impact in CPU load. AP performance not get impacted.
In bpf (enabling monitor mode) case, all Neighbor BSS packets get 
filtered by software. It will consume CPU load which will impact AP 
performance.

Irrespective of how many neighbor APs present in the topology, HW 
offload take care of neighbor BSS filtering. Hence no impact in CPU 
load.
so we decided to use HW offload. To use our HW offload feature, we ended 
up in vendor command approach.

Karthikeyan
