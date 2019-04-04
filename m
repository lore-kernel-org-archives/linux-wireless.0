Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8297C4360F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 08:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 765BB206DD
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 08:36:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H4DNmnzm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfDDIge (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 04:36:34 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:42430 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfDDIge (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 04:36:34 -0400
Received: by mail-qk1-f193.google.com with SMTP id b74so1104427qkg.9;
        Thu, 04 Apr 2019 01:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dIjNk/GwLOcsCqSOxxWSwD+ty4vfcALTOoR+5C2pmf4=;
        b=H4DNmnzmhI1yrmMiSFdADE2sg1MUm8op+NNXqh/IfS67Lus+9FKS6DymmYkLAxTFrM
         d1b/ZbPX0urzNOi//lfcsXUfnoVa3lNdUf65tzeTfCxFTsKteIpfFCaIziAs7aH5ZelA
         yO7pBgIH/yRFJmy83sHFPMla0wu5tcK8hR/H3I5gAuvjeleL09L6iOSXuiYz86+U+SZB
         wFgzWUcc+SJBXvgdWhGPnBMDfvWgUO8dD0N4f5cQKfwlgAMDsVpalNBRk2gRoAvDtuMq
         geKmPvciAGg2UyvUKyAhERfHXmMzh8H4MBK60xQuVN6bSc8ToML7Au6qOMd2RTnpx35E
         MjMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dIjNk/GwLOcsCqSOxxWSwD+ty4vfcALTOoR+5C2pmf4=;
        b=MnqiJF1qnjnpzXgB0hUuKm7S8IOfVSiOsdRmAFx8EuDCgZs48tmmZUBPxdRvg6uRQO
         zTpuLenruaI1DBPTf8p+HPJBdMVqdn89evdQ3/ZjIttgfWJyg049WSU9lJOlEBcIlodS
         ihqC+MZluzxA/FPBZMdY4g8B9M8T/Zg+UT/Xy9OWY4Ei/sJ7D/0FQHa6tFryBUZ4J5fY
         5iYu5sUf3zYTOqVIyoFfOFxUNs3TGv1J3p5za1qIgyiC0V7+WitBzr2nRSMlmaIG9q5S
         lEfkiH4M0TCVrMrezyA+eCSaPzQfF7FvRG0A8/n1s8d1xGkQ5kbM++YKuVDT5ej/K/jF
         VvqQ==
X-Gm-Message-State: APjAAAV57B08wGRxKwCU4P/SfU4mWn/BwSpe+UewksxfknRAEC9CiO2u
        Fv8Fdikol+LKnCKeph22XHY5bAYIOQJyr5jTr5s=
X-Google-Smtp-Source: APXvYqypOfB2WexW4AZqSyjv0PGlQvj6OaKeZUWD+wNEeG0Ris9k1E1dBJx547dYlMeRTFm5WWq0hSn4/L8mkMb+mj8=
X-Received: by 2002:a37:47c9:: with SMTP id u192mr4144526qka.9.1554366992860;
 Thu, 04 Apr 2019 01:36:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190215170512.31512-1-toke@redhat.com> <753b328855b85f960ceaf974194a7506@codeaurora.org>
 <87ftqy41ea.fsf@toke.dk>
In-Reply-To: <87ftqy41ea.fsf@toke.dk>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 4 Apr 2019 10:36:20 +0200
Message-ID: <CAA93jw5WA8eOUvw9PGJE11Dq1-cYFcYHjWj+jb8bA=zosUgc3Q@mail.gmail.com>
Subject: Re: [Make-wifi-fast] [RFC/RFT] mac80211: Switch to a virtual
 time-based airtime scheduler
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Yibo Zhao <yiboz@codeaurora.org>, Kan Yan <kyan@google.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless-owner@vger.kernel.org,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, Apr 4, 2019 at 10:31 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Yibo Zhao <yiboz@codeaurora.org> writes:
>
> > On 2019-02-16 01:05, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> >> This switches the airtime scheduler in mac80211 to use a virtual
> >> time-based
> >> scheduler instead of the round-robin scheduler used before. This has a
> >> couple of advantages:
> >>
> >> - No need to sync up the round-robin scheduler in firmware/hardware
> >> with
> >>   the round-robin airtime scheduler.
> >>
> >> - If several stations are eligible for transmission we can schedule
> >> both of
> >>   them; no need to hard-block the scheduling rotation until the head o=
f
> >> the
> >>   queue has used up its quantum.
> >>
> >> - The check of whether a station is eligible for transmission becomes
> >>   simpler (in ieee80211_txq_may_transmit()).
> >>
> >> The drawback is that scheduling becomes slightly more expensive, as we
> >> need
> >> to maintain an rbtree of TXQs sorted by virtual time. This means that
> >> ieee80211_register_airtime() becomes O(logN) in the number of currentl=
y
> >> scheduled TXQs. However, hopefully this number rarely grows too big
> >> (it's
> >> only TXQs currently backlogged, not all associated stations), so it
> >> shouldn't be too big of an issue.
> >>
> >> @@ -1831,18 +1830,32 @@ void ieee80211_sta_register_airtime(struct
> >> ieee80211_sta *pubsta, u8 tid,
> >>  {
> >>      struct sta_info *sta =3D container_of(pubsta, struct sta_info, st=
a);
> >>      struct ieee80211_local *local =3D sta->sdata->local;
> >> +    struct ieee80211_txq *txq =3D sta->sta.txq[tid];
> >>      u8 ac =3D ieee80211_ac_from_tid(tid);
> >> -    u32 airtime =3D 0;
> >> +    u64 airtime =3D 0, weight_sum;
> >> +
> >> +    if (!txq)
> >> +            return;
> >>
> >>      if (sta->local->airtime_flags & AIRTIME_USE_TX)
> >>              airtime +=3D tx_airtime;
> >>      if (sta->local->airtime_flags & AIRTIME_USE_RX)
> >>              airtime +=3D rx_airtime;
> >>
> >> +    /* Weights scale so the unit weight is 256 */
> >> +    airtime <<=3D 8;
> >> +
> >>      spin_lock_bh(&local->active_txq_lock[ac]);
> >> +
> >>      sta->airtime[ac].tx_airtime +=3D tx_airtime;
> >>      sta->airtime[ac].rx_airtime +=3D rx_airtime;
> >> -    sta->airtime[ac].deficit -=3D airtime;
> >> +
> >> +    weight_sum =3D local->airtime_weight_sum[ac] ?: sta->airtime_weig=
ht;
> >> +
> >> +    local->airtime_v_t[ac] +=3D airtime / weight_sum;
> > Hi Toke,
> >
> > Please ignore the previous two broken emails regarding this new proposa=
l
> > from me.
> >
> > It looks like local->airtime_v_t acts like a Tx criteria. Only the
> > stations with less airtime than that are valid for Tx. That means there
> > are situations, like 50 clients, that some of the stations can be used
> > to Tx when putting next_txq in the loop. Am I right?
>
> I'm not sure what you mean here. Are you referring to the case where new
> stations appear with a very low (zero) airtime_v_t? That is handled when
> the station is enqueued.
>
> >> +    sta->airtime[ac].v_t +=3D airtime / sta->airtime_weight;
> > Another question. Any plan for taking v_t overflow situation into
> > consideration? u64 might be enough for low throughput products but not
> > sure for high end products. Something like below for reference:
>
> The unit for the variable is time, not bytes, so it is unaffected by
> throughput. 2**64 microseconds is 584554 *years* according to my
> 'units' binary, so don't think we have to worry too much about this
> overflowing ;)

I tend to think more in terms in ns than us. Is this metric in us currently=
?

I figure having stuff that at least works correctly within the solar
system is a good start, and getting coverage to 250 light years
is sufficiently forward looking: http://www.atlasoftheuniverse.com/250lys.h=
tml

>
> -Toke
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast



--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
