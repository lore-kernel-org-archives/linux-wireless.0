Return-Path: <SRS0=9n1M=OL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F654C04EB8
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 15:32:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32EB62081C
	for <linux-wireless@archiver.kernel.org>; Sun,  2 Dec 2018 15:32:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=wetzel-home.de header.i=@wetzel-home.de header.b="wndEwmGl"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 32EB62081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=wetzel-home.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbeLBPcN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 2 Dec 2018 10:32:13 -0500
Received: from 2.mo2.mail-out.ovh.net ([188.165.53.149]:33250 "EHLO
        2.mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725869AbeLBPcN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 2 Dec 2018 10:32:13 -0500
X-Greylist: delayed 4199 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Dec 2018 10:32:12 EST
Received: from player786.ha.ovh.net (unknown [10.109.143.249])
        by mo2.mail-out.ovh.net (Postfix) with ESMTP id 4C5C11735D1
        for <linux-wireless@vger.kernel.org>; Sun,  2 Dec 2018 14:02:45 +0100 (CET)
Received: from awhome.eu (p57B7EDEA.dip0.t-ipconnect.de [87.183.237.234])
        (Authenticated sender: postmaster@awhome.eu)
        by player786.ha.ovh.net (Postfix) with ESMTPSA id D9D7584482A;
        Sun,  2 Dec 2018 13:02:42 +0000 (UTC)
Subject: Re: [PATCH] mac80211: allow AP_VLAN operation on crypto controlled
 devices
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=wetzel-home.de;
        s=wetzel-home; t=1543755758;
        bh=BsQGA09liirXAQ6VffaEB9FFAQjuz7FGDiA6/FGATJE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=wndEwmGl8Q3LopThOHXEOIPgk/p31LFEsKLxgcB8PQhg5ffWUlIA54MnZUpwUwuFk
         CPvhC2+sFh0GvHZlhLl8zdHj5AL9woWCp23fjrHmZPArBIfpA7f/rrxlA08R9KM9Mg
         FNOQdA6fjoPaHil7H623SQ7ZsGjH4WS88+8x6zwc=
To:     mpubbise@codeaurora.org, johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org
References: <1522242259-16166-1-git-send-email-mpubbise@codeaurora.org>
From:   Alexander Wetzel <alexander@wetzel-home.de>
Message-ID: <029be0b3-6fb9-1b6a-b512-db620946e08b@wetzel-home.de>
Date:   Sun, 2 Dec 2018 14:02:38 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <1522242259-16166-1-git-send-email-mpubbise@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 15561344090713103474
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedruddvkedgudeffecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hello,

> From: Manikanta Pubbisetty <mpubbise@codeaurora.org>
> 
> In the current implementation, mac80211 advertises the support of
> AP_VLANs based on the driver's support for AP mode; it also
> blocks encrypted AP_VLAN operation on devices advertising
> SW_CRYPTO_CONTROL.
> 
> The implementation seems weird in it's current form and could be
> often confusing, this is because there can be drivers advertising
> both SW_CRYPTO_CONTROL and AP mode support (ex: ath10k) in which case
> AP_VLAN will still be supported but only in open BSS and not in
> secured BSS.
> 
> When SW_CRYPTO_CONTROL is enabled, it makes more sense if the decision
> to support AP_VLANs is left to the driver. Mac80211 can then allow
> AP_VLAN operations depending on the driver support.

This first part of the patch contradicts my current understanding of how 
Software crypto fallback can be triggered: We have a driver actively 
telling us to only fall back to sw crypto when it returns 1 on set_key, 
BUT we ignore that when the interface is set to @NL80211_IFTYPE_AP_VLAN 
and allow software encryption unconditionally?

Here the code:
         case WLAN_CIPHER_SUITE_GCMP:
         case WLAN_CIPHER_SUITE_GCMP_256:
                 /* all of these we can do in software - if driver can */
                 if (ret == 1)
                         return 0;
                 if (ieee80211_hw_check(&key->local->hw,
		                       SW_CRYPTO_CONTROL)) {
                         if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
                                 return 0;
                         return -EINVAL;
                 }
                 return 0;
         default:
                 return -EINVAL;
         }


Wouldn't it be preferable to just return "ret" or "-EINVAL" instead of 
"0" when the interface has @NL80211_IFTYPE_AP_VLAN set?
As it is this basically overrides SW_CRYPTO_CONTROL in AP Vlan mode!

For me it looks like the old behavior in this section was already fine 
and does not hurt the intention of this patch: A driver setting 
SW_CRYPTO_CONTROL won't get support for AP VLANs as long as the driver 
is not opting in to it.

Therefore I would like to undo this part of the patch again:

-		if (ieee80211_hw_check(&key->local->hw,
				       SW_CRYPTO_CONTROL))
+		if (ieee80211_hw_check(&key->local->hw,
				       SW_CRYPTO_CONTROL)) {
+			if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN)
+				return 0;
  			return -EINVAL;
+		}


Do I miss something here and would anyone have issues when I revert that 
in another patch?

Alexander
