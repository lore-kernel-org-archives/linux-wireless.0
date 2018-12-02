Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81445C04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 17:37:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 006C32081C
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 17:36:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=newmedia-net.de header.i=@newmedia-net.de header.b="NNOlzTIQ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 006C32081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=newmedia-net.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbeLBRhC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 12:37:02 -0500
Received: from webmail.newmedia-net.de ([185.84.6.166]:54960 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbeLBRhC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 12:37:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=VMgP9+89ihCssnL94svrskmU77FpYR56ykdZL4TKwU0=;
        b=NNOlzTIQLNh3pmzJ+5hCBMFbSvwJgRi18egub40hi+zwCvroVz+Qp7ZnYRE2PtcXbJJSiLe48gEVy3Q1zXrdPELE3Wgxt7zlfnS+pY06NfmEnwWdAAPE9JUpZrT+joeCxKnBADEPfT9p3SB61ieLdACLdlrQGROb7GeEdDNgoxo=;
Subject: Re: [PATCH] mac80211: allow AP_VLAN operation on crypto controlled
 devices
To:     Alexander Wetzel <alexander@wetzel-home.de>,
        mpubbise@codeaurora.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
References: <1522242259-16166-1-git-send-email-mpubbise@codeaurora.org>
 <029be0b3-6fb9-1b6a-b512-db620946e08b@wetzel-home.de>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <3e11d342-ba2d-fc0d-300b-9b2817d07fe4@newmedia-net.de>
Date:   Sun, 2 Dec 2018 18:36:18 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <029be0b3-6fb9-1b6a-b512-db620946e08b@wetzel-home.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Received:  from [79.249.183.225] (helo=[10.88.193.107])
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1gTVfs-0004SN-Jw; Sun, 02 Dec 2018 18:36:56 +0100
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

yes you just missed that ap_vlan is used for 4addr ap's / wds too so 
that might be related to the weired handling

Sebastian

Am 02.12.2018 um 14:02 schrieb Alexander Wetzel:
> Hello,
>
>> From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
>>
>> In the current implementation, mac80211 advertises the support of
>> AP_VLANs based on the driver's support for AP mode; it also
>> blocks encrypted AP_VLAN operation on devices advertising
>> SW_CRYPTO_CONTROL.
>>
>> The implementation seems weird in it's current form and could be
>> often confusing, this is because there can be drivers advertising
>> both SW_CRYPTO_CONTROL and AP mode support (ex: ath10k) in which case
>> AP_VLAN will still be supported but only in open BSS and not in
>> secured BSS.
>>
>> When SW_CRYPTO_CONTROL is enabled, it makes more sense if the decision
>> to support AP_VLANs is left to the driver. Mac80211 can then allow
>> AP_VLAN operations depending on the driver support.
>
> This first part of the patch contradicts my current understanding of 
> how Software crypto fallback can be triggered: We have a driver 
> actively telling us to only fall back to sw crypto when it returns 1 
> on set_key, BUT we ignore that when the interface is set to 
> @NL80211_IFTYPE_AP_VLAN and allow software encryption unconditionally?
>
> Here the code:
>         case WLAN_CIPHER_SUITE_GCMP:
>         case WLAN_CIPHER_SUITE_GCMP_256:
>                 /* all of these we can do in software - if driver can */
>                 if (ret == 1)
>                         return 0;
>                 if (ieee80211_hw_check(&key->local->hw,
>                                SW_CRYPTO_CONTROL)) {
>                         if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
>                                 return 0;
>                         return -EINVAL;
>                 }
>                 return 0;
>         default:
>                 return -EINVAL;
>         }
>
>
> Wouldn't it be preferable to just return "ret" or "-EINVAL" instead of 
> "0" when the interface has @NL80211_IFTYPE_AP_VLAN set?
> As it is this basically overrides SW_CRYPTO_CONTROL in AP Vlan mode!
>
> For me it looks like the old behavior in this section was already fine 
> and does not hurt the intention of this patch: A driver setting 
> SW_CRYPTO_CONTROL won't get support for AP VLANs as long as the driver 
> is not opting in to it.
>
> Therefore I would like to undo this part of the patch again:
>
> -        if (ieee80211_hw_check(&key->local->hw,
>                        SW_CRYPTO_CONTROL))
> +        if (ieee80211_hw_check(&key->local->hw,
>                        SW_CRYPTO_CONTROL)) {
> +            if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
> +                return 0;
>              return -EINVAL;
> +        }
>
>
> Do I miss something here and would anyone have issues when I revert 
> that in another patch?
>
> Alexander
>
