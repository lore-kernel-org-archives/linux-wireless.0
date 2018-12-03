Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602C9C04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 16:37:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 206BE20672
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 16:37:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 206BE20672
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbeLCQhH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 11:37:07 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:39364 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726699AbeLCQhG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 11:37:06 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gTrDR-0003nU-Ol; Mon, 03 Dec 2018 17:37:01 +0100
Message-ID: <d8b6f02510ccd4ac68dc6bb2be75603d6bd1006b.camel@sipsolutions.net>
Subject: Re: mac80211_hwsim : unsigned int for signal in netlink info frames
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Date:   Mon, 03 Dec 2018 17:37:00 +0100
In-Reply-To: <ba3e97cd-db7c-58dc-8e55-5528a0411338@uni-rostock.de>
References: <ba3e97cd-db7c-58dc-8e55-5528a0411338@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2018-11-26 at 17:07 +0100, Benjamin Beichler wrote:
> I'm working on my code base and I was surprised by the fact, that the
> type of the received signal strength for frames received via Netlink is
> u32, but the actual struct ieee80211_rx_status.signal uses an s8 for signal.
> 
> I actually refer to this line:
> https://elixir.bootlin.com/linux/v4.20-rc4/source/drivers/net/wireless/mac80211_hwsim.c#L3250

I guess this should use nla_get_s32 now, but I think that didn't exist
before and it also doesn't really matter since if you have a negative
value in a u32 it still works just fine as long as userspace and
kernelspace agree on the 2's complement representation :-)

> As we use the signal measurement in dBm (see
> https://elixir.bootlin.com/linux/v4.20-rc4/source/drivers/net/wireless/mac80211_hwsim.c#L2764),
> negative dBm values are totally reasonable as received signal strength.
> Moreover, I don't really know, whether mac80211 or respectively minstrel
> can do reasonable work with positive values.

Indeed. Make it negative.

> On the other hand this line
> https://elixir.bootlin.com/linux/v4.20-rc4/source/drivers/net/wireless/mac80211_hwsim.c#L1276
> inconsistently uses a negative value in the case of not using
> netlink/wmediumd, which is a decent value.

Sure, it should be negative.

> I think it is not possible to easily switch to another type (e.g. s32 or
> even s8) for the netlink attribute without breaking things, but somebody
> might correct me.

Well, u32 and s32 are really identical in netlink anyway, they're just 4
bytes long integers. So there's no "switching" if we now write
"nla_get_s32" in the code.

What we might want to do is use a policy now that says it must be a
sensible value like -200 to -10 or something, but it doesn't really
matter.

> Any suggestions?

Just put a negative integer there in your userspace.

(u32)-50 == 0xffffffce

signal = nla_get_u32(...) = 0xffffffce
-> signal will end up with -50

Nothing to see here, move along ;-)

johannes

