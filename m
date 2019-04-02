Return-Path: <SRS0=bKPU=SE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1BF3C43381
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 06:30:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7FD2B20857
	for <linux-wireless@archiver.kernel.org>; Tue,  2 Apr 2019 06:30:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cS2SOpIx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BlQh6MG7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfDBGae (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 2 Apr 2019 02:30:34 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:58302 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728971AbfDBGad (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 2 Apr 2019 02:30:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D31C56115A; Tue,  2 Apr 2019 06:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554186632;
        bh=i7T6qFBbWT/c1OvuMtvAQcE+JScXpfRsxHZm/RuK9O8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cS2SOpIxLZK9/sQeclv1blKHpXLeXfYtg0NzAR3II+oMAPqTMKcoK3I+ZJC5sFYR1
         7emMYX+PnK8pBm3h0nUt3zoVpVpbzK1+JmGaUdRX3KpXm8L+1JJmNyERqjHrw935tz
         yZVroLx2ev3MUVvWg9cGIlbZilytm/MBIshFI9ZI=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 5CEFB6119E;
        Tue,  2 Apr 2019 06:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554186629;
        bh=i7T6qFBbWT/c1OvuMtvAQcE+JScXpfRsxHZm/RuK9O8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BlQh6MG7ucdTALr2AKo9NRYEh4Di+Ha98cFIA93AcYfaap2wAwd+D0jXuB/POTeWt
         KW61MXmb/ZCRo2NYT1Oh92L2YR0HsLDl9q/SxpPAKTna7mWOd+2wAUsmIX30jGyss0
         W5OLdMTJ6FcgAQrwNMuwfNduwDDOY+tW5MVUuJI4=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 02 Apr 2019 12:00:29 +0530
From:   Balaji Pothunoori <bpothuno@codeaurora.org>
To:     Bob Copeland <me@bobcopeland.com>
Cc:     johannes@sipsolutions.net, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>
Subject: Re: [PATCH v4 1/3] cfg80211: Add support to set tx power for a
 station associated
In-Reply-To: <20190401204611.GA8910@localhost>
References: <1553856501-21492-1-git-send-email-bpothuno@codeaurora.org>
 <20190401204611.GA8910@localhost>
Message-ID: <cd497042d164c322bc06c4cfbf26435a@codeaurora.org>
X-Sender: bpothuno@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-04-02 02:16, Bob Copeland wrote:
> Hi Balaji,
> 
> I started playing with these patches a bit -- they could be useful for
> my use case, but I had a question:
> 
>> + * @power: tx power (in dBm) to be used for sending data traffic. If 
>> tx power
>> + *	is not provided, the default per-interface tx power setting will 
>> be
>> + *	overriding. Driver should be picking up the lowest tx power, 
>> either tx
>> + *	power per-interface or per-station.
> 
> Should this really dBm?  It's a bit asymmetric for WIPHY_TX_POWER_LEVEL 
> to
> use mBm and this to use dBm, and I might want to adjust in half-dB 
> steps if
> supported by hardware.  Also allocating an s16 is a bit much for dBm.

if user will send mBm value then driver has to convert to dBm because 
firmware will expect the value in dBm.
Please refer johannes comments on following patch " [EXT] Re: [PATCH] 
iw: Add support for controlling tx power for per station"
for the reason why we opted dBm.

Yeah, s16 is required if units in mBm. i will modify to s8 in next 
version patch.

Regards,
Balaji.
