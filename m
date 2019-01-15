Return-Path: <SRS0=v11p=PX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 019ECC43387
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 11:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C35FA20657
	for <linux-wireless@archiver.kernel.org>; Tue, 15 Jan 2019 11:59:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YuLJxvYv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728336AbfAOL7V (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 15 Jan 2019 06:59:21 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36724 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727376AbfAOL7U (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 Jan 2019 06:59:20 -0500
Received: by mail-wm1-f67.google.com with SMTP id p6so2908975wmc.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2019 03:59:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2LMZCDg/9eSpywC1bM4zPFHHpJannXJ6cvYvD0zNEs4=;
        b=YuLJxvYvdgJEhwl4nsBXzpD08u7xHu4kNpefxT8rx2fkQ00ZCbeFBeJ+f468cREhB2
         QVWX6pOlkizl9VPkGPm3tyl28/ferb6hhCVBP8keq4vmtg5UWboIiZc37pycbakXXJRW
         Pynuu80/ksdQOHZ255Jg317yHi4XVNJbj0QLhcgXLy/MXr39aZJzT2qsxbWK7W3yjNau
         fB3REUbO+VCvsX7JVPF5lTl7kmiZrVpC3hKtniSto9plzdXoRhI/JKQTlRypOepzkPUX
         iVSpmtfQBTH6OnSMcw1lSS+0/MkNOhImguFLFko6xlmJehN/YraTp6Qo+0ywdHprZHbm
         /pIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2LMZCDg/9eSpywC1bM4zPFHHpJannXJ6cvYvD0zNEs4=;
        b=NOxMqPIXm+knbhUxAJ84/I5CP+dnA3pWOiKzNXqtjDbnDdYEWBFo6r8l2fWW6zk/lC
         pFZ0oeyZ13NY9P2neib4rY5vbsMiFKZcWwcO2bOc7Y7trAiZ/agVzDTDaZGK8oElVmr0
         GBa7gmBJA9yBV7inwajT8DWckw9buC4uCd/xCK6hA3Isd9A7SdCx2Ck+5cc8Pm9j9F+A
         B1JCxSVt5lfYlDNaUtT8PJ99nqyqE+TNnotDW0U29LYXbrlbF0r8T5nbSEuFV5dqs8zC
         zm16khZG4YL9OOjJE8X0gBvU3SRDdFw3+CKREfb5TFBIdTHIfAUhQmN/Gt0hPBqImvNH
         F9WQ==
X-Gm-Message-State: AJcUukcSMTFqfySBVHqKiyiSrWbjey205ZAX2lOS+QDFbMJ+JH4mZOC/
        vXKqTxGp9wPYWj5nRyPLC1K90Ft+RL3IMYNqNe4=
X-Google-Smtp-Source: ALg8bN7ivS4uF7ozP1o5I9/CXz5lEAGnyMlL3aOQiRcaJ1cbUHmAyknYTazLEkkZ0AhS3HAAXCOK8cshQINk20Fwu08=
X-Received: by 2002:a1c:63d5:: with SMTP id x204mr3020333wmb.137.1547553558785;
 Tue, 15 Jan 2019 03:59:18 -0800 (PST)
MIME-Version: 1.0
References: <20190115061949.27260-1-zajec5@gmail.com> <daa97557-03fb-c266-239e-f5f1723bcef7@broadcom.com>
In-Reply-To: <daa97557-03fb-c266-239e-f5f1723bcef7@broadcom.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date:   Tue, 15 Jan 2019 12:59:07 +0100
Message-ID: <CACna6ry67zmyZoz5+ftiMMaofF-Tjz=xa1SqXKR1i+b1QhXhzQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] brcmfmac: modify __brcmf_err() to take bus as a parameter
To:     Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER
        <brcm80211-dev-list.pdl@broadcom.com>," 
        <brcm80211-dev-list@cypress.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 15 Jan 2019 at 09:48, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 1/15/2019 7:19 AM, Rafa=C5=82 Mi=C5=82ecki wrote:
> > From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> >
> > So far __brcmf_err() was using pr_err() which didn't allow identifying
> > device that was affected by an error. It's crucial for systems with mor=
e
> > than 1 device supported by brcmfmac (a common case for home routers).
> >
> > This change allows passing struct brcmf_bus to the __brcmf_err(). That
> > struct has been agreed to be the most common one. It allows accessing
> > struct device easily & using dev_err() printing helper.
>
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> > Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> > ---
> > This is my another try on improving brcmf_err after the failure from 2
> > years ago:
> > [PATCH V3 4/9] brcmfmac: add struct brcmf_pub parameter to the __brcmf_=
err
> > https://patchwork.kernel.org/patch/9553255/
> >
> > Back then my change has been rejected due to miscommunication and late
> > realisation that struct brcmf_pub (a previous choice instead of struct
> > brcmf_bus) was a bad idea. Back then Arend wrote:
> >> So I would think using struct brcmf_bus in brcmf_err() would be best
> >> fit.
> >
> > So this patch follows that suggestion & updates __brcmf_err()
> > accordingly.
>
> Thanks, Rafa=C5=82
>
> Little less than two years ago I played with your idea and using GCC
> builtin __builtin_types_compatible_p(t1,t2). Anyway, it looks good. So
> you want to limit it to brcmf_err() or brcmf_dbg() as well?

I believe all messages printed by brcmfmac should specify a device.
brcmf_err, brcmf_info & brcmf_dbg.

I can work on brcmf_info & brcmf_dbg once I get done with brcmf_err :)

--=20
Rafa=C5=82
