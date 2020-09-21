Return-Path: <SRS0=BG2g=C6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C13EAC43464
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Sep 2020 05:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82B95207DE
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Sep 2020 05:56:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726242AbgIUF4h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Sep 2020 01:56:37 -0400
Received: from mail.adapt-ip.com ([173.164.178.19]:46332 "EHLO
        web.adapt-ip.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726011AbgIUF4h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Sep 2020 01:56:37 -0400
Received: from localhost (localhost [127.0.0.1])
        by web.adapt-ip.com (Postfix) with ESMTP id 248DE4F9B64;
        Mon, 21 Sep 2020 05:56:37 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at web.adapt-ip.com
Received: from web.adapt-ip.com ([127.0.0.1])
        by localhost (web.adapt-ip.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id E0IkvSdofM_h; Mon, 21 Sep 2020 05:56:34 +0000 (UTC)
Received: from mail.ibsgaard.io (c-73-223-60-234.hsd1.ca.comcast.net [73.223.60.234])
        (Authenticated sender: thomas@adapt-ip.com)
        by web.adapt-ip.com (Postfix) with ESMTPSA id 814454F9809;
        Mon, 21 Sep 2020 05:56:34 +0000 (UTC)
MIME-Version: 1.0
Date:   Sun, 20 Sep 2020 22:56:33 -0700
From:   Thomas Pedersen <thomas@adapt-ip.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 14/22] mac80211: encode listen interval for S1G
In-Reply-To: <05ad5f4f7623e6e072eebf7b87320fa7385fac35.camel@sipsolutions.net>
References: <20200831205600.21058-1-thomas@adapt-ip.com>
 <20200831205600.21058-15-thomas@adapt-ip.com>
 <05ad5f4f7623e6e072eebf7b87320fa7385fac35.camel@sipsolutions.net>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <22637776046b8defc4cf98f4b507f769@adapt-ip.com>
X-Sender: thomas@adapt-ip.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-09-18 03:51, Johannes Berg wrote:
> On Mon, 2020-08-31 at 13:55 -0700, Thomas Pedersen wrote:
> 
>> +static const int listen_int_usf[] = { 1, 10, 1000, 10000 };
> 
> That should probably be in some C file?
> 
> OTOH ... maybe it's small enough to duplicate everywhere? could make it
> u16 at least :)
> 
>> +__le16 ieee80211_encode_usf(int listen_interval)
>> +{
>> +	u16 ui, usf = 0;
>> +
>> +	/* find greatest USF */
>> +	while (usf < IEEE80211_MAX_USF) {
>> +		if (listen_interval % listen_int_usf[usf + 1])
>> +			break;
>> +		usf += 1;
>> +	}
>> +	ui = listen_interval / listen_int_usf[usf];
> 
> But you really only need it here in one place anyway.

OK better to keep it private to that file then.

-- 
thomas
