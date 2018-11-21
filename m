Return-Path: <SRS0=oODW=OA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9B2AC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 12:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AFC62147D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Nov 2018 12:26:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="coH6oWFp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9AFC62147D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730126AbeKUXBF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Nov 2018 18:01:05 -0500
Received: from mail-lj1-f182.google.com ([209.85.208.182]:40786 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728428AbeKUXBF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Nov 2018 18:01:05 -0500
Received: by mail-lj1-f182.google.com with SMTP id n18-v6so4655707lji.7
        for <linux-wireless@vger.kernel.org>; Wed, 21 Nov 2018 04:26:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=J8ldfzN5bm7IHoLcNzpcTsZZGgf993g5SgrbW+tt6gg=;
        b=coH6oWFp531oMg+Z1GdZFf0inlmPVaxcyY3kzmdRyDmgY8x5Y9qL5oEzQWJ7YHt2sN
         tSFONYrFgVFHHKMU4PfYccsezr2oNSSrl9k/jx1Ia7BlCTxopNjfDqEuJ95cSkXirRC3
         h8Z4+resEuzv8WMO0n2Y3EMXgFVRdPfAd8apWghq5s5qgN0CGlj1H7PbEBR/yaBHcoDh
         SVMBVUvcG52cl8TeTWQguZ1zFjCAzH85bxWU4T9nPE6wvsGx6Tkw2EGHrtAlyMf88iJa
         Nj2/sfAp9Jeyo+7fkWP5SMMNVwhZkMFi5CUrSL1LMsZ726220ohunAfEGFf610hJmQAe
         plaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=J8ldfzN5bm7IHoLcNzpcTsZZGgf993g5SgrbW+tt6gg=;
        b=tRhtopqL6nRAPjFnoD53tRhFzIWdO0bQ7NrU/XOcPj1t6qbdOpWKQK1RlcWJUDzLnp
         2Bf0EGxi8SHxiPrBhTbnNmJc8quF0BrrtxomuHkDwQsWD3Wh3a7fwK/lqfEn+66936KJ
         6nSMFwPlTg9ywUmg0W9ApK6URr03EH3Q/A7as3c5YWj99tFOLn3FQlHIMZnWQbtJDg/f
         NafoTFoLfgZmsQI5mI8bm9SFoQS0uwMdVoYoxLBSb984nTx6YQqLx3xE16T7MJzO8ffw
         0kiqFzw92TayFbSaoDPJknElugtDVPWS0CXUfMJvBDxtttT7dIIT4Zrg2NwjhuYZnogh
         FyTg==
X-Gm-Message-State: AA+aEWalxBHbkeCQUETNrL2Wjt70pc1YL3s4EBsXT19SZzV6mquj4UGm
        G65UldroP5i+gSxdq+zUe/AeXx7cNxqAh5kJPCa9Q0fI
X-Google-Smtp-Source: AFSGD/XiN66y4OuxcCitbUeUral50qSQzfi8KNkPnMiwFArq91Hi3NxTrWlLcu5eOY5/b+ZvUe0YIMIoIwcR8Ft2fcI=
X-Received: by 2002:a2e:9a84:: with SMTP id p4-v6mr3830664lji.73.1542803212801;
 Wed, 21 Nov 2018 04:26:52 -0800 (PST)
MIME-Version: 1.0
References: <CAK8U23bW5ov=FfD0xBnio7FwS9NTjoyewfHWZhHAmZNPsA16Jw@mail.gmail.com>
 <a88ba8b1e23b5e461f492f050cfd67c0222cf662.camel@sipsolutions.net>
In-Reply-To: <a88ba8b1e23b5e461f492f050cfd67c0222cf662.camel@sipsolutions.net>
From:   Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Wed, 21 Nov 2018 09:26:41 -0300
Message-ID: <CAK8U23Yi-wa0yT_K2eazTBEsVH3kmYHpZEeMmoDEAdyamdSTqA@mail.gmail.com>
Subject: Re: mac80211_hwsim: multiple antennas
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Sorry. I meant throughput.

Let's considering GI=3D800ns - 20MHz:

Without setting the MCS value the throughput is around 18Mbps.
tx bitrate 58.5 MBit/s MCS 6
rx bitrate 48.0 MBit/s

Then I set the bitrate to ht-mcs-2.4 13, 14 and finally 15. Although
the tx bitrate increases as expected the maximum throughput is around
33Mbps
tx bitrate: 117.0 MBit/s MCS 14
rx bitrate: 54.0 MBit/s

I also tried the same with 40Mhz and the throughput doesn't change.
The maximum throughput is always ~33Mbps. Even when the tx bitrate is
300Mbps the maximum throughput is still ~33Mbps.

I noticed that the rx birate is related to the hwsim_rates from
mac80211_hwsim, however, increasing the value provided by hwsim_rates
doesn't change the throughput.

My topology consists of three nodes. 2 clients and one AP working with
hostapd. The hostapd config file includes ieee80211n=3D1 and
ht_capab=3D'[HT40+]'. Sometimes I can see that tx bitrate is working at
40Mhz. However, it doesn't work at 40Mhz when there are data traffic.
The RSSI of both clients is -60dBm, but I also tried with -50dBm and
-40dBm. Tested with both 2.4 and 5Ghz.

This is my per.c file
(https://github.com/ramonfontes/wmediumd/blob/ieee80211n/wmediumd/per.c).
I only check if the rate-flags =3D=3D IEEE80211_TX_RC_MCS and I force some
of the rateset added in my per.c.

Given this brief explanation I was wondering if it could be related to
the number of antennas.

Thank you in advance.
Ramon

Em qua, 21 de nov de 2018 =C3=A0s 06:11, Johannes Berg
<johannes@sipsolutions.net> escreveu:
>
> On Tue, 2018-11-20 at 16:33 -0300, Ramon Fontes wrote:
> > Would be possible to simulate (or even add support to) multiple
> > antennas? I was trying to extend wmediumd to 802.11n according the
> > rates provided by http://mcsindex.com/, but the maximum rate I get is
> > ~33Mbps, even if I set the MCS index to 15. Given the result, I
> > thought that it could be related to the number of antennas. Is my
> > assumption correct?
>
> I'm not sure what you mean by "the maximum rate I get is ~33Mbps".
>
> Are you trying to actually _measure_ it? Then, on a decent platform, you
> should probably get many *gigabits*.
>
> Or are you trying to look at the rate in "iw station dump" or in
> radiotap? Then you should see higher rates since hwsim is configured to
> pretend to have 4 spatial streams (IIRC)
>
> johannes
>
