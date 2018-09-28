Return-Path: <SRS0=in5x=MK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CCC7C43143
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 19:47:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28714206B7
	for <linux-wireless@archiver.kernel.org>; Fri, 28 Sep 2018 19:47:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LSd+ArEl";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UMsOD6G3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28714206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbeI2CM0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 28 Sep 2018 22:12:26 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52802 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbeI2CM0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Sep 2018 22:12:26 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 3EA3F60B72; Fri, 28 Sep 2018 19:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538164029;
        bh=rpjQ0hXBg9XjBcvGW8CbloXYw4jezs5nQovnpREc/Qs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LSd+ArEl63Ys6Vzfb1qHoPo/NjBfLnDQU8uxDMyyFy4egNHglqRGdKwJhi3wykOCn
         j6Uk3LMA8YLCmiCquHNnvaZfk+hXwLNfNdJ4dv6tW0LLopJRSs6lgn/V9RR9OHT7DN
         ffttbo+r3oisI8+oSsItjMB3+h8tGvI1xAMcfbFQ=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id C2679607F4;
        Fri, 28 Sep 2018 19:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538164028;
        bh=rpjQ0hXBg9XjBcvGW8CbloXYw4jezs5nQovnpREc/Qs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UMsOD6G3zEy/HjZxJeFKRFWjLeM9SpjWC915jQ6oixQ730UvPKIQEnGkaNJ7OBq8z
         kN35Rhgo4jvrAI33sOeWsMGtI3QYw/CpYUR042xfmrGDAIIVHlxWkAk6MGzf2L4Kx/
         iH9jmT6ND312c4YpptVt5KTpJ59VvEZJkU8zR2Mc=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 28 Sep 2018 12:47:08 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC 2/2] ath10k: reporting estimated tx airtime for fairness
In-Reply-To: <87lg7lfxtw.fsf@toke.dk>
References: <1538008874-11692-1-git-send-email-rmanohar@codeaurora.org>
 <1538008874-11692-2-git-send-email-rmanohar@codeaurora.org>
 <87lg7lfxtw.fsf@toke.dk>
Message-ID: <34bac7851e6c9d3194cef87bd952c388@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-09-28 08:25, Toke Høiland-Jørgensen wrote:

> So this just uses the calculated airtime based on rate and size? Wasn't
> there supposed to be an airtime usage value reported by the firmware? 
> :)
> 
Firmware interface changes are in progress. Airtime for sta/tid will be 
reported via
htt tx-compl and rx ind messages. Meantime I thought it would be useful 
to use Kan's changes
for ATF validation in ath10k using existing firmware. :)

-Rajkumar
