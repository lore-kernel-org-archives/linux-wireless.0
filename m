Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E76AFC67871
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 18:23:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 88751208E7
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 18:23:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A1y0Lnez"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 88751208E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727788AbeJGB2G (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 21:28:06 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]:38727 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726364AbeJGB2G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 21:28:06 -0400
Received: by mail-qk1-f169.google.com with SMTP id 204-v6so9892154qkd.5
        for <linux-wireless@vger.kernel.org>; Sat, 06 Oct 2018 11:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=3J0q8P5XgmaMzLJuAyX5vZtB49+6y5mP3aM2PdyAcj0=;
        b=A1y0LnezskBGJ6/2muVVsDR6ACxjpWgATKsswnOY9dYEGL8Q6pUstdeMT3Z8+nVYq3
         umaUwhkq3uh0M2k61BHCJSw7Gyg58oCcQGKGhBSbKXMoJU2yGLJN0dqySkGXPXen9pk+
         WShLSZ9dxvYUNp9FzycoQurdwhm+RknrW/6Jxi9YZK+S3PF4m4S3/qzYHutvbPIjomog
         td8E1LixlkpkCrm7QhlZJr+6J+7cYAwyhhzDtyYSwgD1oysAfn7LpnHQQLAT6b0QJ7EV
         hFZS0JJWSTGAxLHAJucEdqIPMjG60JjileP5ADAa1Z4WMZuntlQCWcSjI5GakoCfQqrL
         IfCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=3J0q8P5XgmaMzLJuAyX5vZtB49+6y5mP3aM2PdyAcj0=;
        b=KF0XRx5/7MPYZrVBgNSMcUrFrPJqgeYVbNrIr/Ns1lfZkxbAjRpDfA0cdIrPZJGSU6
         FJ0GqZMSo9RLZ/3gxLGiN/ukdz1LkSILJAr6K/i4kn+btwsyK9mTl4CpDymJlG6NpyMd
         8jbWThsqUHSH4zXJUJLCpy88kzj1afabADMI42R5jkfYCbIs53DTl2nZupjihjCV321U
         oYP+Wl/mOrBy8E/ImFUux0uedc9YnzlmpXSWBg72LYNlFW6HAbVllpsPYGg2UEpcySvA
         G0/M65ka1NzG9kcy18tSYvgY+DITV0SAt1nRJAkBouqk1ZJqdW7s17cKIuMxb4DSVVsr
         SGzg==
X-Gm-Message-State: ABuFfoi+3kNeLi4P2sPy+eDHjk6mHmy0myp9VvVdD75KiTczd2JyPoKe
        XdBm6l7U8j/Y0AKQ3WmUqFTLz8/z1uPAxN986wk=
X-Google-Smtp-Source: ACcGV60K8/VLl5FfQZoO4yPviakcuJzhhjV9ArNxKehMCAnCKfn7ACcUqyGzlkyuEs2GBEmAMKXHYwbMKIDZBX2ZeZs=
X-Received: by 2002:a37:b683:: with SMTP id g125-v6mr9095158qkf.179.1538850226962;
 Sat, 06 Oct 2018 11:23:46 -0700 (PDT)
MIME-Version: 1.0
References: <20181006173507.7316-1-nbd@nbd.name> <20181006173507.7316-9-nbd@nbd.name>
 <CAA93jw48KRNTcGy_RecY8u-1wqL9uWzeP4JK4-pgf9LV9ihzDQ@mail.gmail.com> <43da677d-60b8-b940-4d89-d27578f9c20b@nbd.name>
In-Reply-To: <43da677d-60b8-b940-4d89-d27578f9c20b@nbd.name>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sat, 6 Oct 2018 11:23:34 -0700
Message-ID: <CAA93jw5T40FP0O8dHbS5r2QLpYVDbF9B6NHrc48jceBubENC6w@mail.gmail.com>
Subject: Re: [PATCH 9/9] mac80211: rc80211_minstrel: remove variance / stddev calculation
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Andrew McGregor <andrewmcgr@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Oct 6, 2018 at 11:18 AM Felix Fietkau <nbd@nbd.name> wrote:
>
> On 2018-10-06 19:59, Dave Taht wrote:
> > On Sat, Oct 6, 2018 at 10:37 AM Felix Fietkau <nbd@nbd.name> wrote:
> >>
> >> When there are few packets (e.g. for sampling attempts), the exponenti=
ally
> >> weighted variance is usually vastly overestimated, making the resultin=
g data
> >> essentially useless. As far as I know, there has not been any practica=
l use
> >> for this, so let's not waste any cycles on it.
> >>
> >> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> >> ---
> >>  net/mac80211/rc80211_minstrel.c            |  6 -----
> >>  net/mac80211/rc80211_minstrel.h            | 26 +--------------------=
-
> >>  net/mac80211/rc80211_minstrel_debugfs.c    | 14 ++++--------
> >>  net/mac80211/rc80211_minstrel_ht_debugfs.c | 14 ++++--------
> >>  4 files changed, 9 insertions(+), 51 deletions(-)
> >>
> >> diff --git a/net/mac80211/rc80211_minstrel.c b/net/mac80211/rc80211_mi=
nstrel.c
> >> index dead57ba9eac..a34e9c2ca626 100644
> >> --- a/net/mac80211/rc80211_minstrel.c
> >> +++ b/net/mac80211/rc80211_minstrel.c
> >> @@ -167,12 +167,6 @@ minstrel_calc_rate_stats(struct minstrel_rate_sta=
ts *mrs)
> >>                 if (unlikely(!mrs->att_hist)) {
> >>                         mrs->prob_ewma =3D cur_prob;
> >>                 } else {
> >> -                       /* update exponential weighted moving variance=
 */
> >> -                       mrs->prob_ewmv =3D minstrel_ewmv(mrs->prob_ewm=
v,
> >> -                                                       cur_prob,
> >> -                                                       mrs->prob_ewma=
,
> >> -                                                       EWMA_LEVEL);
> >> -
> >>                         /*update exponential weighted moving avarage *=
/
> >>                         mrs->prob_ewma =3D minstrel_ewma(mrs->prob_ewm=
a,
> >>                                                        cur_prob,
> >> diff --git a/net/mac80211/rc80211_minstrel.h b/net/mac80211/rc80211_mi=
nstrel.h
> >> index 54b2b2c3e10a..23ec953e3a24 100644
> >> --- a/net/mac80211/rc80211_minstrel.h
> >> +++ b/net/mac80211/rc80211_minstrel.h
> >> @@ -35,19 +35,6 @@ minstrel_ewma(int old, int new, int weight)
> >>         return old + incr;
> >>  }
> >>
> >> -/*
> >> - * Perform EWMV (Exponentially Weighted Moving Variance) calculation
> >> - */
> >
> > I worry about this one. where are you getting your proof from?
> I've done quite a few measurements myself to see if this can be usable
> for further rate control improvements or for the upcoming TPC work.
> The data this generates simply fluctuates wildly and incoherently based
> on the sampling behavior, making it completely useless.
> Together with Thomas (who introduced this code), I tried a few times to
> fix this, but couldn't find any way to make it coherent and usable.
>
> Thomas and I both agreed that it's better to just remove it until
> somebody has a better idea what to do.
>
> Also, this was only used for debugfs statistics, not for any actual rate
> control behavior.

OK, thanks. I'm totally delighted to see this patchset otherwise.

> - Felix



--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
