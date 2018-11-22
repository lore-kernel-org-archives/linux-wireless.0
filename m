Return-Path: <SRS0=ZZIE=OB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A3B6C43441
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Nov 2018 12:19:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0983B205C9
	for <linux-wireless@archiver.kernel.org>; Thu, 22 Nov 2018 12:19:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mXNMRB/u"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0983B205C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388599AbeKVW6M (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 22 Nov 2018 17:58:12 -0500
Received: from mail-lj1-f169.google.com ([209.85.208.169]:35395 "EHLO
        mail-lj1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729105AbeKVW6M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Nov 2018 17:58:12 -0500
Received: by mail-lj1-f169.google.com with SMTP id x85-v6so7821821ljb.2
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2018 04:19:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hI1OPf/IZitAPry7ufJLSWT9NvYs1PwA3W7qDkGGlDA=;
        b=mXNMRB/uJPsxA/NzAIGvo1RKlne4BkJpCVFtR9l4cbnL8p2RFME+Ud58JFOd60aQyv
         cXezYrIgzOVNArS0Nsx72e9cOZJ4jD1UzPaagqPy2fmdFwLoreD90tQO37nm/2m9kfkL
         eS+c+86zK2fr4JXI9QSHIUbGnwA7pJELQbJy0/Uq7R3v8IIBojTfuWLZ8d8WJaENTESO
         v4mlQjY87Zm5b/tBFtMJLrNNb0oHbExMhgFtPbMmZ9SSwxwA6YR7UQWDF3EnPbDTc1XL
         cYYeC5zomCWOJnseWQVsHnu3TGZpc74+Zo9YuG2fI6+XXZnLPKYlff6zi/KMszjP/d9W
         M/Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hI1OPf/IZitAPry7ufJLSWT9NvYs1PwA3W7qDkGGlDA=;
        b=g1EEePd0OF+x8OSsYK7Dn2DicyDHvFZkYHUC7KQpnHdxNBy58p+6PLtg5Wx2Wjb6cw
         KcxVUwdSLVDbqtwyGSPetICJcRhJO1v4JouGfh3Q318j6IaRDJov5NUj0r7EAHHNr8Ch
         vOG01zXtjkDcLCCIiHKe60JH0K31Wy5wsVlBJiOERE5JxhPtx8W2SnZjipqYlIWPpZc+
         kUbRJtXQzouox5dHBLpr5MIUv9rjvpJl+5LyBDR5wkgurux/Gl1wpDjXXneMmCTj83zS
         cJV7NcL0BN0nODzpYyFr9OcB7XKqRPKEsVCzeFiklM8ol1YqjFocfQiIX41psV1sWZAH
         b1TA==
X-Gm-Message-State: AGRZ1gKl7jU8KIGfAZsmYxYP3poj085vLAit5PHCDlw/VNOaxlE/0Y8g
        bSdmWAF7y9YxG5kWgXRjGdGOpi70XomXbUVMjAG+XW68
X-Google-Smtp-Source: AJdET5eYZCnJ0s4RCU1SKphuBZFADv8ahlaEcy2tuM5XPFF6RfsESGwd2o7ksvcYrFoLbk7bVAABl+DrniOvJmMbdF4=
X-Received: by 2002:a2e:9181:: with SMTP id f1-v6mr6664877ljg.64.1542889141374;
 Thu, 22 Nov 2018 04:19:01 -0800 (PST)
MIME-Version: 1.0
References: <CAK8U23bW5ov=FfD0xBnio7FwS9NTjoyewfHWZhHAmZNPsA16Jw@mail.gmail.com>
 <a88ba8b1e23b5e461f492f050cfd67c0222cf662.camel@sipsolutions.net>
 <CAK8U23Yi-wa0yT_K2eazTBEsVH3kmYHpZEeMmoDEAdyamdSTqA@mail.gmail.com>
 <7adcf11c634f31032eaac3c15f8d92b366f14477.camel@sipsolutions.net>
 <CAK8U23a8CMgNboStufh7kVpKSE9URkniWkpeNXi2hr1D3GunZQ@mail.gmail.com>
 <4fa8dc82a0c64bc5521fd0aacaa9bf951984d81e.camel@sipsolutions.net> <CAK8U23Y_xFK7ajBbTJ0kWKZnhdEkmRgd=9kmfcB1sztNyHxHEQ@mail.gmail.com>
In-Reply-To: <CAK8U23Y_xFK7ajBbTJ0kWKZnhdEkmRgd=9kmfcB1sztNyHxHEQ@mail.gmail.com>
From:   Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Thu, 22 Nov 2018 09:18:49 -0300
Message-ID: <CAK8U23Z5yQLwxjkoa516fW532Z7pO0vkRv=M9iqp4CcPDkUuYw@mail.gmail.com>
Subject: Re: mac80211_hwsim: multiple antennas
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

I've tested the same setup with adhoc and the throughput seems to be
higher as expected. Thus, the problem comes up when I use hostapd.

I noticed that the maximum supported rate by hostapd (legacy) is 54Mbps.
Extended supported rates: 24.0 36.0 48.0 54.0

Then I tried to modify mac80211_hwsim in order to provide more rates
and it didn't work:
Extended supported rates: 24.0 36.0 48.0 54.0 54.0 54.0 54.0

The maximum supported rate is always 54Mbps.

Then I found the Beacon frame TX rate configuration from hostapd.conf.
After trying to enable the beacon rate (e.g. beacon_rate=3Dht:1) I got
the following msg:
ap1-wlan1: interface state UNINITIALIZED->HT_SCAN
Using interface ap1-wlan1 with hwaddr 02:00:00:00:02:00 and ssid "ssid-ap1"
nl80211: Driver does not support setting Beacon frame rate (HT)

and hostapd doesn't work.

Could this problem be related to mac80211_hwsim?

Em qua, 21 de nov de 2018 =C3=A0s 10:09, Ramon Fontes
<ramonreisfontes@gmail.com> escreveu:
>
> Yes. I thought that it could be related to the number of antennas (or
> something else) after seeing this result
> (https://bobcopeland.com/blog/2014/09/wmediumd-speed-test/) provided
> by wmediumd.
> Em qua, 21 de nov de 2018 =C3=A0s 09:48, Johannes Berg
> <johannes@sipsolutions.net> escreveu:
> >
> > On Wed, 2018-11-21 at 09:47 -0300, Ramon Fontes wrote:
> > > Okay! Thanks a lot.
> > >
> > > Indeed, the maximum throughput when using only hwsim is in the order =
of Gbp/s.
> >
> > So I guess the question is where it's going wrong - is it the wmediumd
> > overhead (netlink), some air simulation in wmediumd, etc.
> >
> > johannes
> >
