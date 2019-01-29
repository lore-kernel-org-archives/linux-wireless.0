Return-Path: <SRS0=Fojl=QF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E34C169C4
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:25:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 984F120870
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Jan 2019 12:25:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UXSIWe42";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="UXSIWe42"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728989AbfA2MZS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Jan 2019 07:25:18 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:34240 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727589AbfA2MZS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Jan 2019 07:25:18 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id B1634602CB; Tue, 29 Jan 2019 12:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548764717;
        bh=EbPk+CLiXvfgTgtldMqfZ7DdcbR2HtvVsNox1OCjwII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UXSIWe42JUW+6GTsYtcHiWf+stNmyEMyWpmgZtoiSARftElecZQCH9HUGYzDKykUs
         fmsB6YI3OV+gzTCb0vvjVvghJ8OBJYX6ybP3PAXcd0iWaKl0r6B1NS0+D3vkANwN7p
         o2vTij3xAbl0bsxIfxmhOCbkq9iaUBnFoRw0Lj50=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 480C26030D;
        Tue, 29 Jan 2019 12:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548764717;
        bh=EbPk+CLiXvfgTgtldMqfZ7DdcbR2HtvVsNox1OCjwII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UXSIWe42JUW+6GTsYtcHiWf+stNmyEMyWpmgZtoiSARftElecZQCH9HUGYzDKykUs
         fmsB6YI3OV+gzTCb0vvjVvghJ8OBJYX6ybP3PAXcd0iWaKl0r6B1NS0+D3vkANwN7p
         o2vTij3xAbl0bsxIfxmhOCbkq9iaUBnFoRw0Lj50=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 29 Jan 2019 17:55:17 +0530
From:   Balaji Pothunoori <bpothuno@codeaurora.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Ashok Raj Nagarajan <arnagara@codeaurora.org>
Subject: Re: [PATCH] iw: Add support for controlling tx power for per station
In-Reply-To: <28fbd021a9ffd4065ae76fa26872f3041aa87262.camel@sipsolutions.net>
References: <1547731764-14037-1-git-send-email-bpothuno@codeaurora.org>
 <28fbd021a9ffd4065ae76fa26872f3041aa87262.camel@sipsolutions.net>
Message-ID: <6ef960abdd335dbfceeae8965c09c850@codeaurora.org>
X-Sender: bpothuno@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-01-25 18:05, Johannes Berg wrote:
> On Thu, 2019-01-17 at 18:59 +0530, Balaji Pothunoori wrote:
>> From: Ashok Raj Nagarajan <arnagara@codeaurora.org>
>> 
>> This patch allows userspace to set transmit power,
>> in mBm units, to a station associated to the AP.
>> 
>> To set a limit tx power of 2000 mBm:
>> iw wlan0 station set <mac-addr> txpwr limit 2000
> 
> I would prefer if this was *dBm*, rather than mBm, and be allowed to
> take float values, i.e. this would become "limit 20".
> 
> johannes

Johannes,

Curiously asking, existing txpower set for vap/phy interface will in mBm 
from user space.
why would you suggesting dBm for per peer txpower set?

Existing designs :
root@OpenWrt:~# iw | grep power
         dev <devname> set txpower <auto|fixed|limit> [<tx power in mBm>]
         phy <phyname> set txpower <auto|fixed|limit> [<tx power in mBm>]

Regards,
Balaji.
