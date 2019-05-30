Return-Path: <SRS0=3DzK=T6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04217C28CC0
	for <linux-wireless@archiver.kernel.org>; Thu, 30 May 2019 14:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB82825BB8
	for <linux-wireless@archiver.kernel.org>; Thu, 30 May 2019 14:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NAZouPqW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SW6WkMXw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfE3OxN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 30 May 2019 10:53:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60570 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfE3OxN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 30 May 2019 10:53:13 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 239AB60252; Thu, 30 May 2019 14:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559227993;
        bh=qOOoiCFWMZlsdRFhPnCxTNGKF2WJRw82w7WvYl9gLCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NAZouPqW62cfNDMNNhHslEsZRucUYWlUaKIyv1cxwNZA6ptomX5TRyF9cYjPOXZXD
         Nw4BBe6ZMpG0uQH1krGs++L821I+zYZ9Az5gBLfJY82hRaXZznkBTm0F5Oj8E0fJEa
         zOALiDebl0dUySOJ0G0UVnT1vZcsj9kdsj5HRAVo=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id CFF0660252;
        Thu, 30 May 2019 14:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559227992;
        bh=qOOoiCFWMZlsdRFhPnCxTNGKF2WJRw82w7WvYl9gLCQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SW6WkMXwH/O/vw8gbEWZXp1XrmFtAFzQhMezGKU0PLE9HO/fAvUhX5r0NYH2JvUhj
         vFTnYmxWYnerxDcjFL5sHJZ1CvUKmTWg11UCs2LszogQLNDurF1pKkYEc9vANSiJgQ
         Cx6t0Fogp+4tyRmLe9yveAtoA4yqKMECVIzOi4Ew=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 30 May 2019 07:53:12 -0700
From:   Jeff Johnson <jjohnson@codeaurora.org>
To:     Arend van Spriel <arend.vanspriel@broadcom.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [RFC 1/8] nl80211: add 6GHz band definition to enum nl80211_band
In-Reply-To: <1558353645-18119-2-git-send-email-arend.vanspriel@broadcom.com>
References: <1558353645-18119-1-git-send-email-arend.vanspriel@broadcom.com>
 <1558353645-18119-2-git-send-email-arend.vanspriel@broadcom.com>
Message-ID: <d27aac46e682d6cb93ac97df0073818c@codeaurora.org>
X-Sender: jjohnson@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-05-20 05:00, Arend van Spriel wrote:
> [...snip...]
>  enum nl80211_band {
>  	NL80211_BAND_2GHZ,
>  	NL80211_BAND_5GHZ,
> +	NL80211_BAND_6GHZ,
>  	NL80211_BAND_60GHZ,
> 
>  	NUM_NL80211_BANDS,

Is it not a concern that this changes the value of NL80211_BAND_60GHZ 
and hence will break any ABI which expects the current value?
