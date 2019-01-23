Return-Path: <SRS0=ZHYo=P7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21DFEC282C2
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 12:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD9DF21019
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 12:28:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hMuDlhcr";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="hMuDlhcr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727565AbfAWM25 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Jan 2019 07:28:57 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:51248 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbfAWM24 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Jan 2019 07:28:56 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CDF3F6049C; Wed, 23 Jan 2019 12:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548246535;
        bh=FInSC2mnzDxtIGFkDnoIOhfOFOVf1ppy1PP6s5btC1E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hMuDlhcrp6TmS+Y1sUz4nf3ETE01hytfFMPLw6NUTXYxhETNygItXHdb9zVGssP3z
         5dVa75d0dDG3OTYx04+t/NNue9b86uGi9jWYcV0Rh9LklykFPy4UouKCCZq/35sUtD
         0u+wryXWhH8DFWKRyw7tg2Ub9Doh/hG0aAcyIqyg=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 5D99E6044E;
        Wed, 23 Jan 2019 12:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548246535;
        bh=FInSC2mnzDxtIGFkDnoIOhfOFOVf1ppy1PP6s5btC1E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hMuDlhcrp6TmS+Y1sUz4nf3ETE01hytfFMPLw6NUTXYxhETNygItXHdb9zVGssP3z
         5dVa75d0dDG3OTYx04+t/NNue9b86uGi9jWYcV0Rh9LklykFPy4UouKCCZq/35sUtD
         0u+wryXWhH8DFWKRyw7tg2Ub9Doh/hG0aAcyIqyg=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 23 Jan 2019 17:58:55 +0530
From:   dasaris@codeaurora.org
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: Authentication offload to user space in AP mode
In-Reply-To: <42e2c59c035142597f00038b8a67f13a9fb40292.camel@sipsolutions.net>
References: <1544779909-27758-1-git-send-email-dasaris@codeaurora.org>
 (sfid-20181214_103219_686121_BC072990)
 <dd3263b2b3f0850a26b316f9e8cb0cba81dc97c7.camel@sipsolutions.net>
 <B2CD83211F5FDD478D7EFFF030D107EDCD031EAB@HASMSX111.ger.corp.intel.com>
 <7bfaa41538350a2b385b14b00bb0444e@codeaurora.org>
 <42e2c59c035142597f00038b8a67f13a9fb40292.camel@sipsolutions.net>
Message-ID: <a2902e5e69e63bada3909ddc7eee4277@codeaurora.org>
X-Sender: dasaris@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-01-15 18:56, Johannes Berg wrote:
> On Thu, 2018-12-20 at 16:37 +0530, dasaris@codeaurora.org wrote:
>> On 2018-12-18 19:10, Otcheretianski, Andrei wrote:
>> > > So, interesting - Andrei also added the PMKID but also the PMK here,
>> > > in a
>> > > separate patch:
>> > > https://patchwork.kernel.org/patch/10732093/
>> >
>> > Yeah, PMK is needed for the devices that offload 4way handshake.
>> 
>> Thanks. Fine with us too. Will have an updated patchset with the pmkid
>> part removed, as this is already added with the patch by Andrei.
> 
> Well, we're still discussing the whole thing :)
> 
> You can add the PMKID here as well, and then Andrei just has to rebase
> accordingly?

Sure, thanks. Will add this in v3. v2 was sent prior to this comment by 
you.
Please ignore v2.

> 
>> > > > [...]
>> > > > -	if (!info->attrs[NL80211_ATTR_SSID])
>> > > > +	if (!info->attrs[NL80211_ATTR_SSID] &&
>> > > > +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
>> > > > +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
>> > > > +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
>> > > >  		return -EINVAL;
>> > >
>> > > Hm. do we really expect this on AP_VLAN?
>> >
>> > Actually I'm not sure about GO neither. P2P doesn't use SAE etc..
>> >
>> > Andrei
>> 
>> Since these vifs are similar to an AP, we have considered external
>> authentication to be applicable for them as well. Please let me know 
>> if
>> this is fine . I shall update the patch accordingly.
> 
> Sure, I think it's fine. Even if P2P right now doesn't actually
> specify/use WPA3/SAE we can still support it, right?
> 
> My question was really more about AP_VLAN, because I was expecting the
> handshake to still happen on the AP interface, not on the AP_VLAN?
> 
> johannes

Thanks for this input. We have considered P2P_GO in v3.

