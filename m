Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA43EC4161D
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 14:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A17D820841
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 14:14:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="H/q7UeFh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="O4qK8mkk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A17D820841
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=kroah.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbeJKVlr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 17:41:47 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50307 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726537AbeJKVlr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 17:41:47 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D39FF21FFC;
        Thu, 11 Oct 2018 10:14:24 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 11 Oct 2018 10:14:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=ikiaQ1h3K0K7hHI2Hw9ZJNJV6LY
        PQEAyAz5+b3Hw7wE=; b=H/q7UeFhzlQO90UZFCEmZxES8Z8I27warWyYaN47cIX
        S/dNjrhK0bDSL+SS9n8yrmdOBa4onM14RJDXb7QnRHLs8JmFW8GufZTxsj7NjNmv
        VioQwi9jLjQ2ZzpgClMd1fWVRpPSLvoYW9dVhHJgJxt1HIsMPBHVWyvRkIKo0L+M
        4L9coyYGTnuM6uP/qhpKPa4nN1reWJ/5Sf9lYpjz+aFfO+rktVTh32kucycg9xOd
        YZ2a3JU45Io5oHzO94X4w/gcV5i0KwJZb4jnOq8V28UOlwxDB0LU5ByJAWZioOQE
        PGY0EadZQrP10gxHWXrjOYFiPTmNnwH40nGBrYL3fgw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=ikiaQ1
        h3K0K7hHI2Hw9ZJNJV6LYPQEAyAz5+b3Hw7wE=; b=O4qK8mkkDOf2lINk+qIifn
        aDoBLQiSP8LhgGYU3o1BSU256x8TONM//7iUzgBYvImtjl4yWFPCH1L/zNvI6GLo
        dkYhUpkXPXDfgmi4OXI1IE+TpGfgwzLlndtTxavtlxN68J50dKNt4lY56ZMmEC9o
        dXnxXrhkrz1mlb6NGUx8gdgby43bWZnEu58+U99sk5xUdvnwG01gMYL8OcTVE4zf
        7txG3+wC3+mruq29a60PD51X6ZO9AwvkB7snH+rqneLC3PVAxWRx23PBDidDNTpd
        LaCY1OI8nEpcugTN3iCQOPcG+5fQtGyBsBZpU8SWyUdvpz8Ty+VqiYH5UzlLhD7Q
        ==
X-ME-Sender: <xms:wFq_W-aMMVNW1e9G7Eub36NVpKBWkI4ZQNUWuah4uVKOMDX6r1F6aw>
X-ME-Proxy: <xmx:wFq_W1lgBdLOJZIhez6ClKONrhbuebB4aKfuUyub6T7wXAh2j5S0DA>
    <xmx:wFq_W3nL7fCsyDW7sK_ymhO5snQj7x7FjnKMRF43XLV4BPOWrve-rQ>
    <xmx:wFq_WzKya45aS-E6o46Pk2UxF0wOZkiux8fe0AqCvf7XfwgAhXp8Kw>
    <xmx:wFq_Wzxv7nLdytFp-zymuhH3KfLG8kJf5Fdto8z63cU6ctVJArxStQ>
    <xmx:wFq_W8tuFZygiAaE7CdAEsoxRbjtlftcoZyoHEMOjA0-m-yuM6PulA>
    <xmx:wFq_W7LSlod5WFBW4JTTpfNGk15fVa_dCtiNzSxKPaw2newf78B-CQ>
Received: from localhost (ip-213-127-77-176.ip.prioritytelecom.net [213.127.77.176])
        by mail.messagingengine.com (Postfix) with ESMTPA id ADB73102EB;
        Thu, 11 Oct 2018 10:14:23 -0400 (EDT)
Date:   Thu, 11 Oct 2018 16:14:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Brian Norris <briannorris@chromium.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Zhi Chen <zhichen@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>, ath10k@lists.infradead.org
Subject: Re: [for -stable] commit "c82919888064 ath10k: fix scan crash due to
 incorrect length calculation"
Message-ID: <20181011141422.GD9507@kroah.com>
References: <20180906213620.GA72542@ban.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180906213620.GA72542@ban.mtv.corp.google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Sep 06, 2018 at 02:36:22PM -0700, Brian Norris wrote:
> Hi Greg / stable maintainer(s),
> 
> IIUC, this commit is a good candidate for -stable. I just hit the bug on
> 4.14, because of new vendor firmware that noticed the mismatched length
> (an internal "assert"), but it seems like this is equally problematic
> from the kernel side for as long as this code existed [1]:
> 
> commit c8291988806407e02a01b4b15b4504eafbcc04e0
> Author: Zhi Chen <zhichen@codeaurora.org>
> Date:   Mon Jun 18 17:00:39 2018 +0300
> 
>     ath10k: fix scan crash due to incorrect length calculation
> 
> Thanks,
> Brian
> 
> [1] I guess that would be:
> 
> Fixes: ca996ec56608 ("ath10k: implement wmi-tlv backend")
> 
> which was in v4.0.

Thanks, now queued up.

greg k-h
