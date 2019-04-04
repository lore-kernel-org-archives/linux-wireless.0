Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B283FC10F0D
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 08:50:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81F012147C
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 08:50:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729074AbfDDIuW convert rfc822-to-8bit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 04:50:22 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36810 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729056AbfDDIuV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 04:50:21 -0400
Received: by mail-ed1-f67.google.com with SMTP id s16so1450723edr.3
        for <linux-wireless@vger.kernel.org>; Thu, 04 Apr 2019 01:50:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=B55VQCA4to53n+4iHqquiLi1lhb4fW5gtQM9dNM2UB0=;
        b=CDXmHcP4hA6ts8Y9e89ctOiKuFiaeBiOH7hcQKaAXRLMeNcBjE/BJ4cL+lP9dJNjjN
         0B/rsSmhtDhR1sSsMmzpK7QuNyXGwkW3hMYZmEMclCjLvCie4liBzV7IYIxRhVndOtig
         FSBgxr10yBvAI/8PcsWozyPdhxiOMNAs7h/Rt6jreqY6354tNmmOERFU8cSvDWfnBqQQ
         yCgCqmLUco0FkH25dV925HzFee9SvLi756KGUAtZsPC0pxGL9xJ/6UkctJ/ePsW3nUE3
         ZHYCuoyvBkDvcuktAN6imda3W9e5f9LEUPCN6deMXoIcixEsJSboO1GwHI/xHJNs3m6L
         8z8Q==
X-Gm-Message-State: APjAAAVE5zauYImVMorUhGuSq7ahTcX68XTxrlhUoyy9YBBPJRGRhLRH
        Ok2Cfje0qofgQblZn7IgLmiDEqJlfzg67w==
X-Google-Smtp-Source: APXvYqyAS1BerVW5gnF3DUCAW5TrA0CwuLmtZvs87tSEOKpK1YP4xYKZygIPH4NZZlerHIuHD4yluw==
X-Received: by 2002:aa7:d784:: with SMTP id s4mr2984648edq.177.1554367819046;
        Thu, 04 Apr 2019 01:50:19 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (alrua-x1.vpn.toke.dk. [2a00:7660:6da:10::2])
        by smtp.gmail.com with ESMTPSA id b26sm3463814ejv.21.2019.04.04.01.50.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 04 Apr 2019 01:50:18 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EDEB21804A5; Thu,  4 Apr 2019 10:50:17 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Dave Taht <dave.taht@gmail.com>
Cc:     Yibo Zhao <yiboz@codeaurora.org>, Kan Yan <kyan@google.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless-owner@vger.kernel.org,
        Make-Wifi-fast <make-wifi-fast@lists.bufferbloat.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>
Subject: Re: [Make-wifi-fast] [RFC/RFT] mac80211: Switch to a virtual time-based airtime scheduler
In-Reply-To: <CAA93jw5WA8eOUvw9PGJE11Dq1-cYFcYHjWj+jb8bA=zosUgc3Q@mail.gmail.com>
References: <20190215170512.31512-1-toke@redhat.com> <753b328855b85f960ceaf974194a7506@codeaurora.org> <87ftqy41ea.fsf@toke.dk> <CAA93jw5WA8eOUvw9PGJE11Dq1-cYFcYHjWj+jb8bA=zosUgc3Q@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 04 Apr 2019 10:50:17 +0200
Message-ID: <87a7h640ja.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dave Taht <dave.taht@gmail.com> writes:

> On Thu, Apr 4, 2019 at 10:31 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
>>
>> Yibo Zhao <yiboz@codeaurora.org> writes:
>>
>> > On 2019-02-16 01:05, Toke Høiland-Jørgensen wrote:
>> >> This switches the airtime scheduler in mac80211 to use a virtual
>> >> time-based
>> >> scheduler instead of the round-robin scheduler used before. This has a
>> >> couple of advantages:
>> >>
>> >> - No need to sync up the round-robin scheduler in firmware/hardware
>> >> with
>> >>   the round-robin airtime scheduler.
>> >>
>> >> - If several stations are eligible for transmission we can schedule
>> >> both of
>> >>   them; no need to hard-block the scheduling rotation until the head of
>> >> the
>> >>   queue has used up its quantum.
>> >>
>> >> - The check of whether a station is eligible for transmission becomes
>> >>   simpler (in ieee80211_txq_may_transmit()).
>> >>
>> >> The drawback is that scheduling becomes slightly more expensive, as we
>> >> need
>> >> to maintain an rbtree of TXQs sorted by virtual time. This means that
>> >> ieee80211_register_airtime() becomes O(logN) in the number of currently
>> >> scheduled TXQs. However, hopefully this number rarely grows too big
>> >> (it's
>> >> only TXQs currently backlogged, not all associated stations), so it
>> >> shouldn't be too big of an issue.
>> >>
>> >> @@ -1831,18 +1830,32 @@ void ieee80211_sta_register_airtime(struct
>> >> ieee80211_sta *pubsta, u8 tid,
>> >>  {
>> >>      struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
>> >>      struct ieee80211_local *local = sta->sdata->local;
>> >> +    struct ieee80211_txq *txq = sta->sta.txq[tid];
>> >>      u8 ac = ieee80211_ac_from_tid(tid);
>> >> -    u32 airtime = 0;
>> >> +    u64 airtime = 0, weight_sum;
>> >> +
>> >> +    if (!txq)
>> >> +            return;
>> >>
>> >>      if (sta->local->airtime_flags & AIRTIME_USE_TX)
>> >>              airtime += tx_airtime;
>> >>      if (sta->local->airtime_flags & AIRTIME_USE_RX)
>> >>              airtime += rx_airtime;
>> >>
>> >> +    /* Weights scale so the unit weight is 256 */
>> >> +    airtime <<= 8;
>> >> +
>> >>      spin_lock_bh(&local->active_txq_lock[ac]);
>> >> +
>> >>      sta->airtime[ac].tx_airtime += tx_airtime;
>> >>      sta->airtime[ac].rx_airtime += rx_airtime;
>> >> -    sta->airtime[ac].deficit -= airtime;
>> >> +
>> >> +    weight_sum = local->airtime_weight_sum[ac] ?: sta->airtime_weight;
>> >> +
>> >> +    local->airtime_v_t[ac] += airtime / weight_sum;
>> > Hi Toke,
>> >
>> > Please ignore the previous two broken emails regarding this new proposal
>> > from me.
>> >
>> > It looks like local->airtime_v_t acts like a Tx criteria. Only the
>> > stations with less airtime than that are valid for Tx. That means there
>> > are situations, like 50 clients, that some of the stations can be used
>> > to Tx when putting next_txq in the loop. Am I right?
>>
>> I'm not sure what you mean here. Are you referring to the case where new
>> stations appear with a very low (zero) airtime_v_t? That is handled when
>> the station is enqueued.
>>
>> >> +    sta->airtime[ac].v_t += airtime / sta->airtime_weight;
>> > Another question. Any plan for taking v_t overflow situation into
>> > consideration? u64 might be enough for low throughput products but not
>> > sure for high end products. Something like below for reference:
>>
>> The unit for the variable is time, not bytes, so it is unaffected by
>> throughput. 2**64 microseconds is 584554 *years* according to my
>> 'units' binary, so don't think we have to worry too much about this
>> overflowing ;)
>
> I tend to think more in terms in ns than us. Is this metric in us
> currently?

Yeah, WiFi stuff generally thinks in coarser time scales than you, then;
everything tends to be microseconds here (the actual time unit in the
standard is 1.024 us IIRC).

> I figure having stuff that at least works correctly within the solar
> system is a good start, and getting coverage to 250 light years
> is sufficiently forward looking: http://www.atlasoftheuniverse.com/250lys.html

Heh, yeah, not sure the WiFi MAC is appropriate for those distances ;)

-Toke
