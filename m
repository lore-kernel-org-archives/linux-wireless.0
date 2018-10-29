Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C828FC2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 14:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FF5A20657
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 14:56:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OuQJUmjo";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="lVCmSBu8"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8FF5A20657
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbeJ2Xph (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 19:45:37 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:49392 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbeJ2Xph (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 19:45:37 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 07969602BC; Mon, 29 Oct 2018 14:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540824998;
        bh=PS9h2dV8tyUf8O8S3TzDz8h4g8fBnNKE0wejxYGUn9c=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=OuQJUmjoEyDVS/Kijb1gPNOiuZzEKdBPSteS9XEW43g5Ihe625cQjavtjz55fmoLk
         Wd2aMtueuYm7F6sdeWvmwT8cxgcLsGu1R7jrb+zm3H7zQ7MMhx3q0OLQetwrC9YR32
         v0ezHwcblN7jSX+D9KIHaDjxA5NqkoI64AzRjBrg=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 7364860159;
        Mon, 29 Oct 2018 14:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540824997;
        bh=PS9h2dV8tyUf8O8S3TzDz8h4g8fBnNKE0wejxYGUn9c=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=lVCmSBu89I1wNEuTl0yZLEnVr/MyimkrsaEf7phpUKaKtq4O0YbP6cYEKl193F+eF
         MgOB/OZ9NixOrJX74CdK7jlVwPo14JAwirqqB2ynICzw6Ajtd01vxcCrPolYBgE81u
         vCDHT1zoLA3POEwEg6Ehd6iPMzk8fklL1mpk1Slc=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 7364860159
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        Lior David <liord@codeaurora.org>, luca@coelho.fi,
        Etan Cohen <etancohen@google.com>,
        Roy Want <roywant@google.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>
Subject: Re: [RFC v3] cfg80211: add peer measurement with FTM API
In-Reply-To: <b0a738370519c5de534769ed93152575b756083e.camel@sipsolutions.net>
        (Johannes Berg's message of "Mon, 15 Oct 2018 09:29:59 +0200")
References: <20181012100827.24195-1-johannes@sipsolutions.net>
        <87tvlqp3wr.fsf@purkki.adurom.net>
        <b0a738370519c5de534769ed93152575b756083e.camel@sipsolutions.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
Date:   Mon, 29 Oct 2018 16:56:33 +0200
Message-ID: <87d0rser8e.fsf@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2018-10-13 at 12:55 +0300, Kalle Valo wrote:
>> 
>> >  struct cfg80211_ops {
>> >  	int	(*suspend)(struct wiphy *wiphy, struct cfg80211_wowlan *wow);
>> 
>> It would be nice to document if these ops can sleep or not.
>
> I don't think we've documented that *anywhere* in cfg80211, but
> everything can sleep there ...
>
> At the mac80211 level things are different, so there we do document a
> case-by-case basis.

Makes sense, sorry for the noise.

-- 
Kalle Valo
