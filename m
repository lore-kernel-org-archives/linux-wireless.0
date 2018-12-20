Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AB54C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 11:07:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D715D21741
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 11:07:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="gmj+wRtn";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Yui8uEAz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbeLTLHd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 06:07:33 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50698 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbeLTLHd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 06:07:33 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C305460878; Thu, 20 Dec 2018 11:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545304052;
        bh=JGoGndqTmjsCuNjHqdCHencqI9+xpTzdppcES3W7gmo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gmj+wRtn8TlJ/Mswh9Nw7+uS9B0RBcYbd7MghpaHHDsSPSvlKuvFQFPxaxgboc4Ne
         8QMsw8yojwdwrQwVspKMZgv+SvgR9AsIAZiLrNs/5jiDkpRA1UFUM6zx/mD+L6ET6Q
         opa8tpfvLhVR9RKNj7/VgoMiMOvrUEDOMGUX0Gho=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id BF61F607CA;
        Thu, 20 Dec 2018 11:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545304051;
        bh=JGoGndqTmjsCuNjHqdCHencqI9+xpTzdppcES3W7gmo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Yui8uEAzYVVeP2TnrxsWyiB1NCMLmWnoDaMNMFIEKFp92zQBqdRMKm7C4NbQGrSaE
         PD+s1DsLxWs0NTCUnerzksQ2XJfDxqymqPqX+614o7iq8r3Fq9jRqpZCrHj7ByXSi7
         0axp9n7STIqdeE5yP9c/SNGj4RzcKB9vgzBiyq7k=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 20 Dec 2018 16:37:31 +0530
From:   dasaris@codeaurora.org
To:     "Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] cfg80211: Authentication offload to user space in AP mode
In-Reply-To: <B2CD83211F5FDD478D7EFFF030D107EDCD031EAB@HASMSX111.ger.corp.intel.com>
References: <1544779909-27758-1-git-send-email-dasaris@codeaurora.org>
 (sfid-20181214_103219_686121_BC072990)
 <dd3263b2b3f0850a26b316f9e8cb0cba81dc97c7.camel@sipsolutions.net>
 <B2CD83211F5FDD478D7EFFF030D107EDCD031EAB@HASMSX111.ger.corp.intel.com>
Message-ID: <7bfaa41538350a2b385b14b00bb0444e@codeaurora.org>
X-Sender: dasaris@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-12-18 19:10, Otcheretianski, Andrei wrote:
>> So, interesting - Andrei also added the PMKID but also the PMK here, 
>> in a
>> separate patch:
>> https://patchwork.kernel.org/patch/10732093/
> 
> Yeah, PMK is needed for the devices that offload 4way handshake.
Thanks. Fine with us too. Will have an updated patchset with the pmkid 
part removed, as this is already added with the patch by Andrei.

>>> [...]
>> > -	if (!info->attrs[NL80211_ATTR_SSID])
>> > +	if (!info->attrs[NL80211_ATTR_SSID] &&
>> > +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
>> > +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
>> > +	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
>> >  		return -EINVAL;
>> 
>> Hm. do we really expect this on AP_VLAN?
> 
> Actually I'm not sure about GO neither. P2P doesn't use SAE etc..
> 
> Andrei
Since these vifs are similar to an AP, we have considered external 
authentication to be applicable for them as well. Please let me know if 
this is fine . I shall update the patch accordingly.

>> 
>> johannes

Thanks,
Srinivas
