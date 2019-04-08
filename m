Return-Path: <SRS0=ZTn4=SK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5148C10F13
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 20:17:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 71AB021841
	for <linux-wireless@archiver.kernel.org>; Mon,  8 Apr 2019 20:17:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="CqQmQpp2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbfDHURB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 8 Apr 2019 16:17:01 -0400
Received: from 15.mo5.mail-out.ovh.net ([178.33.107.29]:46579 "EHLO
        15.mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbfDHURB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 8 Apr 2019 16:17:01 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Apr 2019 16:17:00 EDT
Received: from player755.ha.ovh.net (unknown [10.109.159.132])
        by mo5.mail-out.ovh.net (Postfix) with ESMTP id ADA152292A4
        for <linux-wireless@vger.kernel.org>; Mon,  8 Apr 2019 21:58:24 +0200 (CEST)
Received: from awhome.eu (p57B7E5B2.dip0.t-ipconnect.de [87.183.229.178])
        (Authenticated sender: postmaster@awhome.eu)
        by player755.ha.ovh.net (Postfix) with ESMTPSA id 2228C4A49A42;
        Mon,  8 Apr 2019 19:58:21 +0000 (UTC)
From:   Alexander Wetzel <alexander@wetzel-home.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1554753500;
        bh=0mrWvwN1gXCeZQqL5uKaozK4iK4Ebk4CD2vyb3gcKNY=;
        h=From:Subject:To:Cc:References:Date:In-Reply-To;
        b=CqQmQpp2i2r5BzV2YSGDyIqLJ4bW71hpjjAYU/+q9gxYokY0+Pze/wUH/eiRnRMYB
         ueiYIIVvICHVtrysNAjhpX8/Q9QtfJSahngXGosnjjgiaZH8BDDOhHj4qGzWyQ0p9W
         8A8h6+no1ExWtNY6gfG4GG/dciWpd1cPAK9agZ98=
Subject: Re: [PATCH] mac80211: Honor SW_CRYPTO_CONTROL in AP VLAN mode
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, mpubbise@codeaurora.org,
        Christian.Limpach@gmail.com
References: <20190209140138.16692-1-alexander@wetzel-home.de>
 <ad27a4098892dbd2ebd1954ba6f34ae0fea4600c.camel@sipsolutions.net>
Message-ID: <d7f567e6-3467-451a-8bd3-7819688e779f@wetzel-home.de>
Date:   Mon, 8 Apr 2019 21:58:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ad27a4098892dbd2ebd1954ba6f34ae0fea4600c.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12096668603026054258
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddrudefgddugeeiucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>> Restore @SW_CRYPTO_CONTROL when interface is in AP Vlan mode and don't
>> override driver decision for unicast keys.
>>
>> Fixes commit db3bdcb9c3ff ("mac80211: allow AP_VLAN operation on crypto
>> controlled devices"), which should only have allow SW crypto fallback for
>> group keys.
> 
> This confuses me.
> 
> The driver doesn't really know about AP_VLAN, so the original commit
> intentionally did this, I think?
> 
> There was some kind of other fix related to this though?
Here how I understand the situation:

The intent of db3bdcb9c3ff ("mac80211: allow AP_VLAN operation on crypto 
controlled devices") was, to allow devices setting SW_CRYPTO_CONTROL to 
still support AP_VLAN group keys. It unintentionally allowed more than 
it should for that...

Prior to the commit db3bdcb9c3ff installing a group key when in AP_VLAN 
mode could not work. Mac80211 was initializing ret to -EOPNOTSUPP and 
then jumped to "out_unsupported" when the interface was in AP_VLAN mode 
without trying to install the key and giving the driver a chance to 
allow SW crypto. Software fallback was then blocked by ret != 1 with 
SW_CRYPTO_CONTROL set by the driver.

But any driver setting NL80211_IFTYPE_AP_VLAN already has confirmed to 
be fine with SW crypto for group keys, since these CAN only be handled 
with SW crypto currently. The net effect was that ath10k - the only 
driver in tree setting SW_CRYPTO_CONTROL and also NL80211_IFTYPE_AP - 
was not able to send out frames encrypted with the group key at all.

Now the fix for that was commit db3bdcb9c3ff. Unfortunately this went 
too far:
We now not only allows fallback to SW crypto for group keys (which the 
driver allowed by setting NL80211_IFTYPE_AP_VLAN) but for ANY keys as 
long as the interface is in AP_VLAN mode.
So if for some reasons ath10k is not able to install a pairwise key 
mac80211 now incorrectly allows the fallback to SW crypto...

This patch here tries to fix that and excludes pairwise keys from the 
special AP_VLAN handling again (but keeps it for group keys).

This understanding is based on the result of a inquiry to linux-wireless 
(see https://patchwork.kernel.org/patch/10313127/) and a short 
out-of-list discussion with Christian Limpach who pointed me to 
http://lists.infradead.org/pipermail/ath10k/2018-November/012542.html
as the reason for the original fix in db3bdcb9c3ff.

Alexander

