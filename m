Return-Path: <SRS0=EMXR=RQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27B30C43381
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 13:48:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E30E42087C
	for <linux-wireless@archiver.kernel.org>; Wed, 13 Mar 2019 13:48:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KML2Qon8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbfCMNsC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Mar 2019 09:48:02 -0400
Received: from mail-oi1-f193.google.com ([209.85.167.193]:42824 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbfCMNsC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Mar 2019 09:48:02 -0400
Received: by mail-oi1-f193.google.com with SMTP id m4so1438873oim.9
        for <linux-wireless@vger.kernel.org>; Wed, 13 Mar 2019 06:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xqVwTyoATsrE3IBLh2pa5URtp/9IDvoR0LSrU99Vk98=;
        b=KML2Qon8rarW0JlUfZCkeGCeK08v09e+GJHp/jHDN1WGEG6IIKA0FXZruw5F68utz+
         zgmpc5j5VmqImbdisMCVBrtz3GHSZBiXu0S0mo+doSmYhX+/1jyzWeLkR0vayOkB4hjm
         7SUMUgJ9pUQ6PDn119ji2E5FEfQDynk6HkkI5OcyLgu30iZxxxZXubZ3cfRyUvJuaiT0
         QbnfVTnYnHtDNufvvTL9J9Dx63R/9kp+lbbN/E6gP2bIBQpMVIePsumXLMOSdueGjGeB
         BA6u28dAbYSbYSLobzNqJzI/2lNA9mrO9dC4zL2Nek7nfk5l21ykwLi8x+Ngi1sp8UzD
         vfIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xqVwTyoATsrE3IBLh2pa5URtp/9IDvoR0LSrU99Vk98=;
        b=q6d8urGYx1LeW/DPYritDTRF3IcYv8itDB6+rMPRgT3U+r3hq5sKuw2m1FMsN1jZXN
         V3U7Y2OnUvP8S+tkW3vWPAHYaINm0NIUfwmp93voskADe1ItVOAMiUSW0Y0/ot1Pp01d
         eQyUQEz4IICQQBmNoPw/0iHOf805JxRYta0Orpoo3lxL8aqiFdLXLS9jdCsBCwHpgnYP
         bWwWd2pKvevA2QcfW25AbmZPtolgvu85rMT+WpnOifYZW6p31yQMBeKm7GeeApsm6MHK
         2g7T0+eJxm4M9zcXLbFqaqNIoyEzIsaXCrY0V+oFpqr8BPt0MfsgtzNLd4TPzEZKycgf
         8uVQ==
X-Gm-Message-State: APjAAAUrum+gLgxluNwRFakDoX4igDM/QhryWfK7tCNBsextPC8IOyQm
        IO3yox3YZlkUVhapJcjLDeVlghU1yjQQWBnQn1vwzQ==
X-Google-Smtp-Source: APXvYqzixi2CvXHlLGHuVcXOdL2JAdvpvOoQXQBCpS4Qm+M4H4ojEpBhw7LmxMZhaz/rgCTDONkD4fFZyIMite4JSbU=
X-Received: by 2002:aca:5c89:: with SMTP id q131mr1656209oib.50.1552484881584;
 Wed, 13 Mar 2019 06:48:01 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:6a97:0:0:0:0:0 with HTTP; Wed, 13 Mar 2019 06:48:01
 -0700 (PDT)
In-Reply-To: <20190313130910.GD2003@redhat.com>
References: <1552417902-11040-1-git-send-email-pozega.tomislav@gmail.com>
 <1552417902-11040-2-git-send-email-pozega.tomislav@gmail.com>
 <20190313091252.GB2663@redhat.com> <CAKR_QV+sFc6J97f5dtW9OtxGoEj5udB=fY5qAb3_QgF4jfqEVA@mail.gmail.com>
 <20190313130910.GD2003@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Wed, 13 Mar 2019 14:48:01 +0100
Message-ID: <CAKR_QVLB9k0bGiRW9ON3PeQR1ZoMfWbrXg3W+Bg4N4G+9pAsZg@mail.gmail.com>
Subject: Re: [PATCH 2/2] rt2x00: enable experimental MFP with HW crypt
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        daniel@makrotopia.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Wed, Mar 13, 2019 at 02:02:32PM +0100, Tom Psyborg wrote:
>> On 13/03/2019, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> > On Tue, Mar 12, 2019 at 08:11:42PM +0100, Tomislav Po=C5=BEega wrote:
>> >> MFP can work with enabled HW crypt engine, but in this case
>> >> available bandwidth is reduced at least when connecting to
>> >> Archer C7 (QCA9558). Enable the feature for known to work chipsets-
>> >> MT7620, RT3070 and RT5390. Userspace setting for ieee80211w should
>> >> default to 0 in order to prevent unintentional bandwidth drop.
>> >>
>> >> Signed-off-by: Tomislav Po?ega <pozega.tomislav@gmail.com>
>> >> ---
>> >>  drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   11 +++++++----
>> >>  1 files changed, 7 insertions(+), 4 deletions(-)
>> >>
>> >> diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>> >> b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>> >> index a03b528..bb8204d 100644
>> >> --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>> >> +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
>> >> @@ -9326,6 +9326,13 @@ static int rt2800_probe_hw_mode(struct
>> >> rt2x00_dev
>> >> *rt2x00dev)
>> >>  	ieee80211_hw_set(rt2x00dev->hw, SIGNAL_DBM);
>> >>  	ieee80211_hw_set(rt2x00dev->hw, SUPPORTS_PS);
>> >>
>> >> +	/* Experimental: Set MFP with HW crypto enabled. */
>> >> +	if (rt2x00_rt(rt2x00dev, RT3070) || rt2x00_rt(rt2x00dev, RT5390) ||
>> >> +	    rt2x00_rt(rt2x00dev, RT6352))
>> >> +		ieee80211_hw_set(rt2x00dev->hw, MFP_CAPABLE);
>> >
>> > Is not that we support MFP in hardware. We just return -EOPNOTSUPP
>> > in rt2x00mac_set_key() when mac80211 will try to set MFP ciphers
>> > (since rt2x00crypto_key_to_cipher() will return CIPHER_NONE) and
>> > we fallback to software encryption.
>> >
>> > Please repost patch that enable MFP unconditionally with
>> > 'Cc: stable@vger.kernel.org' tag.
>> >
>> > Stanislaw
>> >
>>
>> No, I have not test any other chipsets besides the ones I enabled it
>> for. It is possible this would cause problems on other devices, so
>> just enable it for the known to work ones.
>
> It's just matter of sending already encrypted frames. All chipsets
> handle that.
>
> Stanislaw
>

The question is how well all chipsets handle that. I've seen some lags
too with MFP enabled connection. While being about 40-50% lower,
throughput would still occasionally drop to very low values, like
800Kbps.
