Return-Path: <SRS0=FFSH=OD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5B59C43441
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 21:32:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 47BFF20868
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 21:32:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47BFF20868
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=milecki.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbeKYIWH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 25 Nov 2018 03:22:07 -0500
Received: from 14.mo3.mail-out.ovh.net ([188.165.43.98]:40240 "EHLO
        14.mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbeKYIWG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Nov 2018 03:22:06 -0500
X-Greylist: delayed 522 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Nov 2018 03:22:05 EST
Received: from player730.ha.ovh.net (unknown [10.109.160.76])
        by mo3.mail-out.ovh.net (Postfix) with ESMTP id AAA5B1E882F
        for <linux-wireless@vger.kernel.org>; Sat, 24 Nov 2018 22:24:02 +0100 (CET)
Received: from RCM-web2.webmail.mail.ovh.net (ip-194-187-74-233.konfederacka.maverick.com.pl [194.187.74.233])
        (Authenticated sender: rafal@milecki.pl)
        by player730.ha.ovh.net (Postfix) with ESMTPSA id 3C9AB117507;
        Sat, 24 Nov 2018 21:23:56 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sat, 24 Nov 2018 22:23:55 +0100
From:   =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>
To:     Stefan Wahren <stefan.wahren@i2se.com>
Cc:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>
Subject: Re: brcmfmac: regression using AP mode
In-Reply-To: <142675996.139583.1543082320719@email.ionos.de>
References: <142675996.139583.1543082320719@email.ionos.de>
Message-ID: <ab765dfac2c4a19d820677c5c05a5566@milecki.pl>
X-Sender: rafal@milecki.pl
User-Agent: Roundcube Webmail/1.3.8
X-Originating-IP: 194.187.74.233
X-Webmail-UserID: rafal@milecki.pl
X-Ovh-Tracer-Id: 13939203800388832820
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgedtkedruddufedgudeglecutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-24 18:58, Stefan Wahren wrote:
> today i wanted to setup an access point on my Raspberry Pi 3 A+
> (BCM43455). Unfortunately the hostapd 2.4 shipped with Raspbian failed
> with recent Linux kernel:
> 
> (...)
> 
> I was able to bisect this issue down to this commit:
> 
> 1204aa17f3b4 ("brcmfmac: set WIPHY_FLAG_HAVE_AP_SME flag")
> 
> After reverting this commit hostapd works as expected.

It ringed a bell, I did a quick research and found it. It's because of
that ancient hostapd you're using. 2,5 years ago hostapd received a fix
for its discovery of driver capabilities:

commit f4830bed661f4adff51f50a0d37c64ceb748e780
Author: Rafał Miłecki <zajec5@gmail.com>
Date:   Mon Apr 25 17:10:47 2016 +0200

     nl80211: Try running without mgmt frame subscription (driver AP SME)

So your problem is the ancient hostapd that can't run with drivers that:
1) Report NL80211_ATTR_DEVICE_AP_SME
2) Don't support subscribing for PROBE_REQ and/or ACTION frames

Technically there is nothing wrong with such drivers and it's just a
hostapd bug (that's why it was fixed long time ago).

Now, you could try *not* reporting NL80211_ATTR_DEVICE_AP_SME but then
hostapd for drivers that:
1) Support monitor mode
2) Don't support subscribing for PROBE_REQ and/or ACTION frames
will hit yet another mode discovery path in and break as well.

That said there is no perfect solution.

brcmfmac *should* set WIPHY_FLAG_HAVE_AP_SME. It's required for a sane
capabilities discovery in hostapd. It's required to make sure other
supplicants can work with brcmfmac as well.

Possibly you can just update hostapd to anything more recent? I'm afraid
the version you're using may suffer from a lot of security issues anyway
