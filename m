Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40C10C43441
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:34:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08D33216FD
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 05:34:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X3aZ99Tc";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="X3aZ99Tc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08D33216FD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731042AbeKLP0P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 10:26:15 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39374 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730979AbeKLP0P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 10:26:15 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5AEF160866; Mon, 12 Nov 2018 05:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542000878;
        bh=UgRZ8fjoKHC8r8V3mgFswN72B3wpSgLti2Q2WX3cRvo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X3aZ99Tc0/KqVygsWNS7h8B7V3i+eudY7gZDSDp4CDFi8SCG9JUIfGXqa0ZA99hTY
         HTIa3yz3SgtVWsUTBuGqjMbYfxEX6V9IJs320FUqQ6ELJUmkIAmySxGI5m/s354qjr
         jMibGUk9OnrXYM4XY5W1Vg0t0llVKN5lLZvQTMH8=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id EE8F760397;
        Mon, 12 Nov 2018 05:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542000878;
        bh=UgRZ8fjoKHC8r8V3mgFswN72B3wpSgLti2Q2WX3cRvo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X3aZ99Tc0/KqVygsWNS7h8B7V3i+eudY7gZDSDp4CDFi8SCG9JUIfGXqa0ZA99hTY
         HTIa3yz3SgtVWsUTBuGqjMbYfxEX6V9IJs320FUqQ6ELJUmkIAmySxGI5m/s354qjr
         jMibGUk9OnrXYM4XY5W1Vg0t0llVKN5lLZvQTMH8=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 12 Nov 2018 11:04:37 +0530
From:   Sathishkumar Muruganandam <murugana@codeaurora.org>
To:     Sebastian Gottschall <s.gottschall@newmedia-net.de>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [EXTERNAL] Re: [PATCH] ath10k: Disable 4addr source port learning
 in 10.4 FW by default
In-Reply-To: <cc8040a6-47f8-c8f0-0451-2e220d91d62c@newmedia-net.de>
References: <20181109061121.4184-1-murugana@codeaurora.org>
 <0d74b002-e36d-8169-34e8-59338eac6918@newmedia-net.de>
 <00fd01d4798e$1c0d2f10$54278d30$@codeaurora.org>
 <18df2020-f8c4-b9f7-cf9c-63802ea02429@newmedia-net.de>
 <cc8040a6-47f8-c8f0-0451-2e220d91d62c@newmedia-net.de>
Message-ID: <4ec664290c20a58f36f2183fc2fd0b4f@codeaurora.org>
X-Sender: murugana@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-12 09:40, Sebastian Gottschall wrote:
> i tested my proposal now and it fixes the issue. the submitted patch
> was simply broken at that small point
> 

You're right. Thanks for your finding !

Due to some reason, my patch formatting missed the vdev param
assignments to 10.4 and 10.2.4 (unsupported).

Sorry for the confusion, let me resend the patch.

-- 
Thanks,
Sathishkumar
