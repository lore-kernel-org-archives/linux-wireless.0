Return-Path: <SRS0=bLdd=TA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB1BC43219
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Apr 2019 06:45:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CE9320652
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Apr 2019 06:45:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QCqpfJuw";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="QCqpfJuw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725996AbfD3GpS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Apr 2019 02:45:18 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:44932 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725769AbfD3GpS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Apr 2019 02:45:18 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C996560A00; Tue, 30 Apr 2019 06:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556606717;
        bh=sksE9dfho7zDcTCV+kZKLC+uKq2Kde3pbM1MpSi3ovI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QCqpfJuwb5LTujSfRTKRuRMVPiz83p9Ngo04miFopSywyx9LVSNXmAhpy/15d22Fm
         kCeFjyA8GQS14bY/YlDlK5PBAs7LQr/h6lvHI6L1qtjuzZdUhP5ZLtWhtV8S04FPog
         S2NgCxEJYasIiRVdhQvTb51DAUDQ589ExLIRvnIE=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 188596028C;
        Tue, 30 Apr 2019 06:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1556606717;
        bh=sksE9dfho7zDcTCV+kZKLC+uKq2Kde3pbM1MpSi3ovI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QCqpfJuwb5LTujSfRTKRuRMVPiz83p9Ngo04miFopSywyx9LVSNXmAhpy/15d22Fm
         kCeFjyA8GQS14bY/YlDlK5PBAs7LQr/h6lvHI6L1qtjuzZdUhP5ZLtWhtV8S04FPog
         S2NgCxEJYasIiRVdhQvTb51DAUDQ589ExLIRvnIE=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 29 Apr 2019 23:45:17 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     John Crispin <john@phrozen.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        Srini Kode <skode@qti.qualcomm.com>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>,
        linux-wireless@vger.kernel.org, ath11k@lists.infradead.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH V2 2/3] mac80211: dynamically turn TWT requester support
 on and off
In-Reply-To: <20190426094150.18078-3-john@phrozen.org>
References: <20190426094150.18078-1-john@phrozen.org>
 <20190426094150.18078-3-john@phrozen.org>
Message-ID: <a580242a242ec6126928bba5227f1e2d@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-04-26 02:41, John Crispin wrote:
> Turn TWT on/off for STA interfaces when they associate and/or receive a
> beacon where the twt_responder bit has changed.
> 

Does it mean that TWT responder can be turn on/off when AP is UP and 
running?
I thought any change in beacon needs AP restart. no?

-Rajkumar
