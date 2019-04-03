Return-Path: <SRS0=OUAD=SF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 248BFC4360F
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 12:28:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3D10206DD
	for <linux-wireless@archiver.kernel.org>; Wed,  3 Apr 2019 12:28:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W9kLlAcJ";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RmcE9Oai"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbfDCM2Y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 3 Apr 2019 08:28:24 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:56662 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbfDCM2X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 3 Apr 2019 08:28:23 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 17D3961112; Wed,  3 Apr 2019 12:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554294502;
        bh=aaloaPgqj72tHOTSTYZ/ICiodxWYqH9Eqg4DfBDPmkw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=W9kLlAcJPOws69OQXdFKXnXuyXftKLxfM/O+Rtr3WFkVdZJgDKwfoQZUP2RVP8V34
         HvMWqsiSCSDly4mcg5sXSBD5CYOr5ePbd8z2AT776z2eIBHlQmLJBe6SqAw96Z/rp+
         EnX/mgDiC74c7x7AkO1Hg+sig4HtUbLCvNHxe64U=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BC51560F3C;
        Wed,  3 Apr 2019 12:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1554294501;
        bh=aaloaPgqj72tHOTSTYZ/ICiodxWYqH9Eqg4DfBDPmkw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RmcE9OaiHbzCGYGX7mZ5qcBtIgoDNQni9gCMEIXPkeKwK3fVKP+j7VeziD24cRbIS
         SclDy8ur4/dAsrFfSJ0cqk1zf9tc+4svQjbaRkY2am++DGCmqvKp6A7286szLJenxM
         ewwzxqQPnC6CHghmop7R+J/P604rNEOJoWuRoI1w=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BC51560F3C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Steve deRosier <derosier@cal-sierra.com>,
        Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        Zhi Chen <zhichen@codeaurora.org>,
        John Crispin <john@phrozen.org>,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
Subject: Re: [PATCH] ath10k: fix incorrect multicast/broadcast rate setting
References: <1544504171-19810-1-git-send-email-pradeepc@codeaurora.org>
        <2172036.sbaLp6LFFn@bentobox> <3062143.B1lnfLpWcE@bentobox>
Date:   Wed, 03 Apr 2019 15:28:16 +0300
In-Reply-To: <3062143.B1lnfLpWcE@bentobox> (Sven Eckelmann's message of "Tue,
        26 Feb 2019 10:23:30 +0100")
Message-ID: <8736mzuvbz.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sven Eckelmann <sven@narfation.org> writes:

> On Monday, 25 February 2019 21:00:38 CET Sven Eckelmann wrote:
> [...]
>> Tested-by: Sven Eckelmann <sven@narfation.org>
>> 
>> Was tested on QCA988X with 10.2.4-1.0-00041
>
> I just wanted to test it with 802.11s setup on IPQ4019 with 10.4-3.5.3-00057 
> and QCA9888 with 10.4-3.5.3-00053 (ath10k-firmware) and 10.4-3.6-00140
> (linux-firmware 2018-12-16-211de167) for both. But it looks like the firmware 
> always crashes with and without this patch and 11s.
>
>     [  221.620803] ath10k_pci 0000:01:00.0: wmi command 36967 timeout, restarting hardware
>     [  221.744056] ieee80211 phy0: Hardware restart was requested
>     [  225.130829] ath10k_pci 0000:01:00.0: failed to receive control response completion, polling..
>     [  226.170824] ath10k_pci 0000:01:00.0: Service connect timeout
>     [  226.170871] ath10k_pci 0000:01:00.0: failed to connect htt (-110)
>     [  226.252248] ath10k_pci 0000:01:00.0: Could not init core: -110
>
> If i count correctly, this is WMI_10_4_GPIO_CONFIG_CMDID. Not really supported 
> by upstream but it looks like there is an Openwrt private patch (not yet
> accepted upstream [1])
>
>   package/kernel/mac80211/patches/ath/974-ath10k_add-LED-and-GPIO-controlling-support-for-various-chipsets.patch 
>
> which I have now removed to fix this problem for me.
>
> The tests with 10.4-3.6-00140 and 10.4-3.5.3-* worked fine without this patch.
>
> @Kalle are you expecting that he resents the patch again or can you just 
> append this information to the commit message? At least it looks at the moment 
> like there will be no new patch in the near future. But the 
> commit cd93b83ad92 ("ath10k: support for multicast rate control") is breaking 
> real world setups.

I'm planning to apply this. I was not sure what you wanted to add to the
commit log but I changed to now what's below. Please let me know if you
want to change it.

    ath10k: fix incorrect multicast/broadcast rate setting
    
    Invalid rate code is sent to firmware when multicast rate value of 0 is
    sent to driver indicating disabled case, causing broken mesh path.
    so fix that.
    
    Tested on QCA9984 with firmware 10.4-3.6.1-00827
    
    Sven tested on IPQ4019 with 10.4-3.5.3-00057 and QCA9888 with 10.4-3.5.3-00053
    (ath10k-firmware) and 10.4-3.6-00140 (linux-firmware 2018-12-16-211de167).
    
    Fixes: cd93b83ad92 ("ath10k: support for multicast rate control")
    Co-developed-by: Zhi Chen <zhichen@codeaurora.org>
    Signed-off-by: Zhi Chen <zhichen@codeaurora.org>
    Signed-off-by: Pradeep Kumar Chitrapu <pradeepc@codeaurora.org>
    Tested-by: Sven Eckelmann <sven@narfation.org>
    Patchwork-Id: 10723033
    Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
