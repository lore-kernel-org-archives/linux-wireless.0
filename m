Return-Path: <SRS0=d2Dv=MX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CEE2C32788
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 10:38:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F068A20841
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Oct 2018 10:38:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="BO+v891+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F068A20841
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728091AbeJKSEp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Oct 2018 14:04:45 -0400
Received: from mail.toke.dk ([52.28.52.200]:33383 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727851AbeJKSEo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Oct 2018 14:04:44 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1539254283; bh=t/WD+Zr41cnarX5QQFhoQFX6LzR8Hmgkr7Po5Ctgcr4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=BO+v891+TIHEQUkGRalsOdYHmSTgQr3kNGNA0WooSSVZ/D4K6810Nmkhm1V/4VLpA
         1qq4ZnI5djuy7DIgDSlUigo4/rhMV5yFQH+/ykdz6Dc4U1WzTjVV/4mPV2n+b6pciN
         vuiDl1eo3xuPEDQYyxrbUyeykq5usbBAYRDvzuNUgps/ZRvKhtqzbYzHLrg2qlb2S9
         t1TQUrdyEUS3skiP2q2IXloZZRa6ALXlvW2A+Po00xS5vFFVmG6bVoJ341NYfedrX8
         DOZ/DWBqs7cf36GITRCbsktZDDenEFrS7R0z71JYYzhqwv1xhdq9F0nPCVQYNtrMOE
         sRtCDWuoMOiPA==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v5 3/4] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <187bade306627912c70d800819ef0b87@codeaurora.org>
References: <153908805217.9471.9290979918041653328.stgit@alrua-kau> <153908837900.9471.5394468800857658136.stgit@alrua-kau> <a65909ee425585a49d9e17f6504cf0ba@codeaurora.org> <87zhvm832s.fsf@toke.dk> <187bade306627912c70d800819ef0b87@codeaurora.org>
Date:   Thu, 11 Oct 2018 12:38:02 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87pnwg93at.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-10-10 04:15, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>=20
>>> On 2018-10-09 05:32, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> This adds airtime accounting and scheduling to the mac80211 TXQ
>>>> scheduler. A new callback, ieee80211_sta_register_airtime(), is added
>>>> that drivers can call to report airtime usage for stations.
>>>>=20
>>>> When airtime information is present, mac80211 will schedule TXQs
>>>> (through ieee80211_next_txq()) in a way that enforces airtime=20
>>>> fairness
>>>> between active stations. This scheduling works the same way as the
>>>> ath9k
>>>> in-driver airtime fairness scheduling. If no airtime usage is=20
>>>> reported
>>>> by the driver, the scheduler will default to round-robin scheduling.
>>>>=20
>>>> For drivers that don't control TXQ scheduling in software, a new API
>>>> function, ieee80211_txq_may_transmit(), is added which the driver can
>>>> use
>>>> to check if the TXQ is eligible for transmission, or should be
>>>> throttled to
>>>> enforce fairness. Calls to this function must also be enclosed in
>>>> ieee80211_txq_schedule_{start,end}() calls to ensure proper locking.
>>>> TXQs
>>>> that are throttled by ieee802111_txq_may_transmit() will be woken up
>>>> again
>>>> by a check added to the ieee80211_wake_txqs() tasklet.
>>>>=20
>>>=20
>>> Toke,
>>>=20
>>> I am observing soft lockup issues again with this new series while
>>> running traffic with 50 clients. I am continuing testing with earlier
>>> series along with snippet I shared.
>>=20
>> Are these new lockups (that was not in your patched previous version),
>> or did I just not get all your lock-related fixes incorporated?
>>=20
>>> When driver operates in pull-mode, throttled txqs are marked and
>>> refilled in airtime_tasklet. This is causing major throughput drops
>>> and packet loss and I am suspecting the latency in replenishing
>>> deficit. Whereas in push-mode or in ath9k model, refill happens
>>> quicker at every packet indication as well as tx completion.
>>=20
>> Yeah, the tasklet shouldn't be the main source of deficit replenishing.
>> Can see why that would give bad performance :)
>>=20
>>> I am planning to get rid of tasklet completely as it is only meant for
>>> pull-mode. It would be better to refill in may_transmit() itself.
>>=20
>> Hmm, right. So the way to do this correctly (from a fairness point of
>> view) would be something like this (in max_tx()):
>>=20
>> if (this_txq.stn.deficit > 0)
>>   return true;
>>=20
>> else if (any queued TXQ currently have positive deficit)
>>   return false; /* other TXQ should try may_tx() later and get=20
>> permission */
>>=20
>> else /* all deficits < 0 */
>>   return replenish_deficits(this_txq);
>>=20
>> And replenish_deficits() would be something like:
>>=20
>> replenish_deficits(this_txq) {
>> repeat:
>>   for (txq in queued txqs) {
>>     txq.stn.deficit +=3D stn.weight;
>>     if (txq.stn.deficit > 0 && !wake_txq)
>>       wake_txq =3D txq;
>>   }
>>   if not wake_txq:
>>     goto repeat;
>>=20
>>   if (this_txq.stn.deficit > 0)
>>     return true;
>>   else
>>     drv_wake_tx_queue(wake_txq);
>> }
>>=20
>> The wake_tx_queue call may have to be delegated to a tasklet still, to
>> avoid the infinite recursion problem I mentioned earlier. But the
>> tasklet could be made simpler and wouldn't have to be called so=20
>> often...
>>=20
>> Does the above make sense?
>>=20
> Hmm... mine is bit different. txqs are refilled only once for all txqs.
> It will give more opportunity for non-served txqs. drv_wake_tx_queue=20
> won't be
> called from may_tx as the driver anyway will not push packets in=20
> pull-mode.

So, as far as I can tell, this requires the hardware to "keep trying"?
I.e., if it just stops scheduling a TXQ after may_transmit() returns
false, there is no guarantee that that TXQ will ever get re-awoken
unless a new packet arrives for it?

-Toke
