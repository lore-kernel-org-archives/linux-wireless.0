Return-Path: <SRS0=ivqe=NJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B699C2BC61
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 18:59:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C840E2082D
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Oct 2018 18:59:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FF0jAxD2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FF0jAxD2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C840E2082D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729441AbeJ3DtI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 23:49:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38626 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729182AbeJ3DtI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 23:49:08 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C2EC36076A; Mon, 29 Oct 2018 18:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540839550;
        bh=UOFY/OKOQp5Ojxtp86d50WyYh9mugGbbbHfKgFNvEQU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FF0jAxD29xWVlo3EDrfQ/aN6DG7vnk4KmUMaaOQv+0XAUFnNstjgvr5gEkgLKoXKS
         odtXHCaiRLJmA71HBUZZd1N6DVBTciYFgW4sQWndXrVSLzDToGfe37ES0JELWyozws
         cc6P/+VvNrI1aHhufMNnkvJWS1d3fAAebxr2H3rI=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 126AA6021A;
        Mon, 29 Oct 2018 18:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540839550;
        bh=UOFY/OKOQp5Ojxtp86d50WyYh9mugGbbbHfKgFNvEQU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FF0jAxD29xWVlo3EDrfQ/aN6DG7vnk4KmUMaaOQv+0XAUFnNstjgvr5gEkgLKoXKS
         odtXHCaiRLJmA71HBUZZd1N6DVBTciYFgW4sQWndXrVSLzDToGfe37ES0JELWyozws
         cc6P/+VvNrI1aHhufMNnkvJWS1d3fAAebxr2H3rI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 29 Oct 2018 11:59:10 -0700
From:   Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        David Spinadel <david.spinadel@intel.com>
Subject: Re: [PATCH] mac80211: support FTM responder configuration/statistics
In-Reply-To: <389c2e4819c83330a3b652f2a45ff024ec94cd2c.camel@sipsolutions.net>
References: <1538623160-25886-1-git-send-email-pradeepc@codeaurora.org>
 (sfid-20181004_051935_494006_E9A4C858)
 <c832f9007e0a844d3335a0cd9996818f49df2311.camel@sipsolutions.net>
 <765cbdd596e96b7cf73239a4e04b06a7@codeaurora.org>
 <389c2e4819c83330a3b652f2a45ff024ec94cd2c.camel@sipsolutions.net>
Message-ID: <03f51a115f6d71923c3212af25c470d3@codeaurora.org>
X-Sender: pradeepc@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>  	memset(&params, 0, sizeof(params));
> +	params.beacon_csa.ftm_responder = -1;
Hi Johannes,

Agree with the rest, however, I think this may not be needed because 
ftm_responder is already being set to -1,
if NL80211_ATTR_FTM_RESPONDER attribute is not included, in 
nl80211_parse_beacon, which will be called from
nl80211_channel_switch. Please let me know if I may have missed 
something..

         if (attrs[NL80211_ATTR_FTM_RESPONDER]) {

         } else {
                 bcn->ftm_responder = -1;
         }

> 
>  	if (!info->attrs[NL80211_ATTR_WIPHY_FREQ] ||
>  	    !info->attrs[NL80211_ATTR_CH_SWITCH_COUNT])
> 
> 
> If that seems good to you I'll submit the patch.
Sure..Thanks.
> 
> johannes
