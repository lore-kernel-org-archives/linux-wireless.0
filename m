Return-Path: <SRS0=dsQx=NY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DAC5C43441
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 06:46:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CA30223D0
	for <linux-wireless@archiver.kernel.org>; Tue, 13 Nov 2018 06:46:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eMCREgYB";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="eMCREgYB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CA30223D0
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730665AbeKMQnE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 13 Nov 2018 11:43:04 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51416 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbeKMQnD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Nov 2018 11:43:03 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D3A9660242; Tue, 13 Nov 2018 06:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542091582;
        bh=IKiE0jmTt4O9i7uuodJmfnlwoQEkVkl/x7Nw8EVGJNw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eMCREgYB2TnqP7kn/tmby+60oejNECUPMWU5j6fiourRgA0JDEHPxhnufHakUqHXw
         Cc1yPkiWnown2GUvhaE/iAY9ZBfVdkeqn9iWzYayu8wC1xO145rdXXDth5a1K3dAKD
         9uwSYpOAtU2vXtmD451cGkNxGSxAhIDyGr6nHoAM=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 574BE606DD;
        Tue, 13 Nov 2018 06:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1542091582;
        bh=IKiE0jmTt4O9i7uuodJmfnlwoQEkVkl/x7Nw8EVGJNw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=eMCREgYB2TnqP7kn/tmby+60oejNECUPMWU5j6fiourRgA0JDEHPxhnufHakUqHXw
         Cc1yPkiWnown2GUvhaE/iAY9ZBfVdkeqn9iWzYayu8wC1xO145rdXXDth5a1K3dAKD
         9uwSYpOAtU2vXtmD451cGkNxGSxAhIDyGr6nHoAM=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 13 Nov 2018 12:16:22 +0530
From:   Tamizh chelvam <tamizhr@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Vasanthakumar Thiagarajan <vthiagar@codeaurora.org>
Subject: Re: [PATCH 1/4] New netlink command for TID specific configuration
In-Reply-To: <dda0f03868f631ba9f76170e19dd28099a0e0add.camel@sipsolutions.net>
References: <1540230918-27712-1-git-send-email-tamizhr@codeaurora.org>
 <1540230918-27712-2-git-send-email-tamizhr@codeaurora.org>
 <20181107140552.zfuusbapgqjumoln@bars>
 <0b75171a7777bd25e203240a3a119cb5@codeaurora.org>
 <20181109094017.j4vkhaprz4zmszch@bars>
 <dda0f03868f631ba9f76170e19dd28099a0e0add.camel@sipsolutions.net>
Message-ID: <f024b86729f2361aeb0e8939db8d3a04@codeaurora.org>
X-Sender: tamizhr@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-09 17:54, Johannes Berg wrote:
> On Fri, 2018-11-09 at 09:40 +0000, Sergey Matyukevich wrote:
>> 
>> Ok. So if driver receives retry value (-1), it should reset to some
>> default value known to driver or firmware. IMHO it worth making it
>> more explicit: in its current form this convention will not be obvious
>> for driver authors. Though I don't have a good idea how to do it.
>> Maybe merge both aggregation and retry cfg80211 callbacks into one
>> and use structure for params and bitmask for operations...
> 
> I think we want that anyway, I just suggested to also add the "noack" 
> to
> the same API, and indeed it's pointless to set retries and noack.
> 
Sure, I'll change it to a single api for all the tid_config operations.
