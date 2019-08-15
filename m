Return-Path: <SRS0=Tazh=WL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D625BC3A589
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Aug 2019 20:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A27482171F
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Aug 2019 20:48:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="avIbPuul";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="avIbPuul"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732609AbfHOUss (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Aug 2019 16:48:48 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:37306 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728728AbfHOUss (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Aug 2019 16:48:48 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D3CDA601F6; Thu, 15 Aug 2019 20:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565902127;
        bh=iSOqHxzpkpMOGAEn+NEDsyChRjF6HJTBCmRyk9wfoH8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=avIbPuulc+Fm4fCJuxOwXK+ZxGJj32e1lf2Y8Cx7bitBYiKAgU+6D0jdZ/hBBWqz/
         PcrJUTyuDrApsDiJ4aLLmhoViogNzgEPRoYnXkVo52SQFSI2ZPg8IKXW1dAhw+FAre
         FPbV7gwvRaC2FDxaT8zO/0WRI58BwovTB/yveL1g=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 90177601F6;
        Thu, 15 Aug 2019 20:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1565902127;
        bh=iSOqHxzpkpMOGAEn+NEDsyChRjF6HJTBCmRyk9wfoH8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=avIbPuulc+Fm4fCJuxOwXK+ZxGJj32e1lf2Y8Cx7bitBYiKAgU+6D0jdZ/hBBWqz/
         PcrJUTyuDrApsDiJ4aLLmhoViogNzgEPRoYnXkVo52SQFSI2ZPg8IKXW1dAhw+FAre
         FPbV7gwvRaC2FDxaT8zO/0WRI58BwovTB/yveL1g=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 15 Aug 2019 13:48:47 -0700
From:   Jeff Johnson <jjohnson@codeaurora.org>
To:     James Prestwood <prestwoj@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [RFC 0/1] Allow MAC change on up interface
In-Reply-To: <20190815185702.30937-1-prestwoj@gmail.com>
References: <20190815185702.30937-1-prestwoj@gmail.com>
Message-ID: <46810d9dbb674fb8d8fb442f2418868a@codeaurora.org>
X-Sender: jjohnson@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-08-15 11:57, James Prestwood wrote:
>  - Adds a new NL80211_ATTR for including a "random mac" to
>    CMD_CONNECT. This MAC is passed down the stack and gets set to
>    the net_device's address.

My initial reaction is that I'd avoid using the term "random". For some
use cases the address may truly be random, but for other use cases it
may be derived, perhaps in an AP-specific manner. Other terms which may
be more appropriate are "spoofed mac", "administered mac", etc.

It is a shame that due to backward compatibility we can't use
NL80211_ATTR_MAC while shifting the current usage over to using
NL80211_ATTR_BSSID.
