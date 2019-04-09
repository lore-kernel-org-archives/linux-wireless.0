Return-Path: <SRS0=TYOj=SL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A45EC282DA
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FD3620883
	for <linux-wireless@archiver.kernel.org>; Tue,  9 Apr 2019 11:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbfDILhV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 9 Apr 2019 07:37:21 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47692 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfDILhU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 Apr 2019 07:37:20 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hDp41-0002S3-TU; Tue, 09 Apr 2019 13:37:18 +0200
Message-ID: <cd0a48a590ee46c5f7d3c94faaf2f568b0569150.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Honor SW_CRYPTO_CONTROL in AP VLAN mode
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org, mpubbise@codeaurora.org,
        Christian.Limpach@gmail.com
Date:   Tue, 09 Apr 2019 13:37:16 +0200
In-Reply-To: <d7f567e6-3467-451a-8bd3-7819688e779f@wetzel-home.de>
References: <20190209140138.16692-1-alexander@wetzel-home.de>
         <ad27a4098892dbd2ebd1954ba6f34ae0fea4600c.camel@sipsolutions.net>
         <d7f567e6-3467-451a-8bd3-7819688e779f@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-04-08 at 21:58 +0200, Alexander Wetzel wrote:

> Here how I understand the situation:
> 
> The intent of db3bdcb9c3ff ("mac80211: allow AP_VLAN operation on crypto 
> controlled devices") was, to allow devices setting SW_CRYPTO_CONTROL to 
> still support AP_VLAN group keys.

Yes, I think so.

> It unintentionally allowed more than it should for that...

I guess you're going to explain that in the text below :-)

> Prior to the commit db3bdcb9c3ff installing a group key when in AP_VLAN 
> mode could not work. Mac80211 was initializing ret to -EOPNOTSUPP and 
> then jumped to "out_unsupported" when the interface was in AP_VLAN mode 
> without trying to install the key and giving the driver a chance to 
> allow SW crypto. Software fallback was then blocked by ret != 1 with 
> SW_CRYPTO_CONTROL set by the driver.

Right.

> But any driver setting NL80211_IFTYPE_AP_VLAN already has confirmed to 
> be fine with SW crypto for group keys, since these CAN only be handled 
> with SW crypto currently. 

Well, NL80211_IFTYPE_AP_VLAN was set by mac80211 at the time still. Said
commit also changed that to only set it if SW_CRYPTO_CONTROL isn't set.

But yes, with the commit I agree - the driver is now setting
NL80211_IFTYPE_AP_VLAN so it's its own problem if something's wrong.

> The net effect was that ath10k - the only 
> driver in tree setting SW_CRYPTO_CONTROL and also NL80211_IFTYPE_AP - 
> was not able to send out frames encrypted with the group key at all.

I don't think I follow here. Before the commit in question, ath10k
would've rejected the key and not been able to. After the commit, and of
course also after 4920ce3bf7e0d ("ath10k: add dynamic vlan support")
(which you linked to below) ath10k again sets the NL80211_IFTYPE_AP_VLAN
bit under certain conditions, and thus *can* do software-crypto of such
frames.

> Now the fix for that was commit db3bdcb9c3ff. Unfortunately this went 
> too far:
> We now not only allows fallback to SW crypto for group keys (which the 
> driver allowed by setting NL80211_IFTYPE_AP_VLAN) but for ANY keys as 
> long as the interface is in AP_VLAN mode.

Aha, now I follow.

> So if for some reasons ath10k is not able to install a pairwise key 
> mac80211 now incorrectly allows the fallback to SW crypto...

Indeed, I agree.

> This patch here tries to fix that and excludes pairwise keys from the 
> special AP_VLAN handling again (but keeps it for group keys).

Right, ok, makes sense now. I'll probably edit the commit message, but
yeah, I can follow your patch now.

Thanks,
johannes

