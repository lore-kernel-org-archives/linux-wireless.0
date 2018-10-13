Return-Path: <SRS0=P1q9=MZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C140C28CF8
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 07:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FE0520859
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Oct 2018 07:10:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nS2Rfviq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4FE0520859
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726033AbeJMOqM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Oct 2018 10:46:12 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39235 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbeJMOqM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Oct 2018 10:46:12 -0400
Received: by mail-qk1-f195.google.com with SMTP id q5-v6so9029535qki.6;
        Sat, 13 Oct 2018 00:10:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8qnPKtoA3FlSwPLJt2ZYXuU85kMb5y0pX6eXGX6bcJo=;
        b=nS2RfviqR/95ABb8etoJkhYl847ysN7AE71KFiE6W/Iu7OvOW3+7iAyGbJYz+Qtp7y
         CrcEOsLgnAAadp2BsZ2bmP7OIS0pzCFpb3u5wZFYFaCxbcYpyAubo9kga6nZVezWemTJ
         sAiO5pZiXk9oYDsy0+Aky2uL+eUqeBQvrIxBi+2soCfltJIhxymUpmnUu13Qlfe2j4ed
         dWAyS4uPPrRpKkK/cvAPYfulPHjZHEXcc/6t7RqNEY8Wmsjc4WYJIOhaQsEOkU9IWnbl
         h2Po1Vr71Tbv4dujeKPX5yeaEXBI6UH0I0SZPWd39x9+xitx6CNfu1er5F6c+cSDqNpx
         39nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8qnPKtoA3FlSwPLJt2ZYXuU85kMb5y0pX6eXGX6bcJo=;
        b=OSH6lUlFEKKLTGXjmHiQlCv2/rhUvckByq0Ws3u6tUd2xHYngPQPjFJSOrj0KyZT3Q
         k0Aizis4wgPCqNNTo53kinKqCyxmmKeuJFcWI8Y4Dh0Z6PsQXDnw1tEemwGn4Y+BL4jc
         U9DmKUcQOthlNp9yEIuQTM3rWuTxsYxdIDvz8GWTGdjtCdt5R5j/MADBw9AoT+DmCJ5A
         t9+jCv5K3vBBbbraIqwZgzfUeiFQd+IPBPEzv8eBsuUimYfaxatiEKN6JvZZjYk1Iwca
         CW7in0QsnXyyr/f2Hrlx8JxPtagH32yKfUybE3rg1F4PaEBwNua1YaoiRLQPeLn/a51Y
         OS5w==
X-Gm-Message-State: ABuFfojaduOE18RRPjx4VPMxf1VL4H81wKhwi5GZdmTVmMMw++maJUGH
        J5qyebIDBgqXmt478UuaCUH1Lgz0vXoZdgOlfh0=
X-Google-Smtp-Source: ACcGV62G8le3rkQMIeHzUAw4qKMS4nYKOCDpWD7ypCKBWcIZZOd0sGGMgFlqvu3zjdJraa/P1WxsLcjp04x14vMZr60=
X-Received: by 2002:a37:185f:: with SMTP id j92-v6mr8321556qkh.65.1539414610668;
 Sat, 13 Oct 2018 00:10:10 -0700 (PDT)
MIME-Version: 1.0
References: <153908805217.9471.9290979918041653328.stgit@alrua-kau>
 <153908837900.9471.5394468800857658136.stgit@alrua-kau> <a65909ee425585a49d9e17f6504cf0ba@codeaurora.org>
 <87zhvm832s.fsf@toke.dk> <187bade306627912c70d800819ef0b87@codeaurora.org>
 <87pnwg93at.fsf@toke.dk> <7dfcb7a13a3f75f01f7b88163f2c33d6@codeaurora.org>
In-Reply-To: <7dfcb7a13a3f75f01f7b88163f2c33d6@codeaurora.org>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Sat, 13 Oct 2018 00:09:58 -0700
Message-ID: <CAA93jw4ufN0i+-RpsLqHyfOjWyf3KuqY-yt8oi-OM5AT8fXF4Q@mail.gmail.com>
Subject: Re: [Make-wifi-fast] [PATCH RFC v5 3/4] mac80211: Add airtime
 accounting and scheduling to TXQs
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        Kan Yan <kyan@google.com>,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        linux-wireless-owner@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Oct 12, 2018 at 12:38 AM Rajkumar Manoharan
<rmanohar@codeaurora.org> wrote:
>
> On 2018-10-11 03:38, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> > Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> >
> >> Hmm... mine is bit different. txqs are refilled only once for all
> >> txqs.
> >> It will give more opportunity for non-served txqs. drv_wake_tx_queue
> >> won't be
> >> called from may_tx as the driver anyway will not push packets in
> >> pull-mode.
> >
> > So, as far as I can tell, this requires the hardware to "keep trying"?
> > I.e., if it just stops scheduling a TXQ after may_transmit() returns
> > false, there is no guarantee that that TXQ will ever get re-awoken
> > unless a new packet arrives for it?
> >
> That is true and even now ath10k operates the same way in pull mode. Not
> just packet arrival, even napi poll routine tries to pushes the packets.
> One more thing, fetch indication may pull ~4ms/8ms of packets from each
> tid.
> This makes deficit too low and so refilling txqs by just airtime_weight
> becomes
> cumbersome. In may_transmit, the deficit are incremented by 20 *
> airtime_weight.
> In future this will be also replaced by station specific quantum. we can
> revisit
> this once BQL in place. Performance issue is resolved by this approach.
> Do you foresee any issues?

I'll have some time in the coming weeks to be able to test this stuff.
I'm mostly interested
in algorithmic correctness more than the API changes...

Is there a version of these patches that is stable enough on ath9 or ath10k=
?

Do I foresee any issues? Jeeze, no, we *never* have any issues with wifi.

"fetch indication may pull ~4ms/8ms of packets from each tid"

made me really twitchy.
>
> #define IEEE80211_TXQ_MAY_TX_QUANTUM  20
> bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
>                                  struct ieee80211_txq *txq)
> {
>          struct ieee80211_local *local =3D hw_to_local(hw);
>          struct txq_info *txqi =3D to_txq_info(txq);
>          struct sta_info *sta;
>          u8 ac =3D txq->ac;
>
>          lockdep_assert_held(&local->active_txq_lock[ac]);
>
>          if (!txqi->txq.sta)
>                  goto out;
>
>          sta =3D container_of(txqi->txq.sta, struct sta_info, sta);
>          if (sta->airtime[ac].deficit >=3D 0)
>                  goto out;
>
>          list_for_each_entry(txqi, &local->active_txqs[ac],
> schedule_order) {
>                  if (!txqi->txq.sta)
>                          continue;
>                  sta =3D container_of(txqi->txq.sta, struct sta_info, sta=
);
>                  sta->airtime[ac].deficit +=3D
>                          (IEEE80211_TXQ_MAY_TX_QUANTUM *
> sta->airtime_weight);
>          }
>
>          return false;
>
>   out:
>          list_del_init(&txqi->schedule_order);
>          return true;
> }
>
> -Rajkumar
> _______________________________________________
> Make-wifi-fast mailing list
> Make-wifi-fast@lists.bufferbloat.net
> https://lists.bufferbloat.net/listinfo/make-wifi-fast



--=20

Dave T=C3=A4ht
CTO, TekLibre, LLC
http://www.teklibre.com
Tel: 1-831-205-9740
