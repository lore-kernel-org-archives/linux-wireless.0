Return-Path: <SRS0=yLyd=MW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FB2BC43441
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:16:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DFABE2087D
	for <linux-wireless@archiver.kernel.org>; Wed, 10 Oct 2018 11:15:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="DG6bRZlB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DFABE2087D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbeJJShi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 10 Oct 2018 14:37:38 -0400
Received: from mail.toke.dk ([52.28.52.200]:41555 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbeJJShi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 10 Oct 2018 14:37:38 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1539170156; bh=l83TSPFgOA7/iNgoTuJGHFDhFN3+yZZdTthqNkKsqME=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=DG6bRZlBZ3CnF73Zj2tBcrIgPZj8OsSspLc3cngJhsMvgaAA1ATheOcXoCo8l3kTl
         lfpYV4+1zcpeDICh5Lb4u5RlHRQhX0cq3uYj9AYfKa/h6XpdtsX1EFgNwA4D+wp5T7
         QRbcdjSrzK6ddhiX8o8c4o/n7XRJzscRN7NWnr+S48R1jNvPcVrvV0v+IRa5HvBlmy
         hplxI/mJvUHcWlbHIiYMYNPwjyWtsZd/weFlqOh7Nupz6d4UDacHMbJQTckphcg9JD
         GVeNu7T2+Ov1KZPGjpO9JuOJj/aOpj3LqTlUqop7AtnAxwahI733GLf4jABQJyuUrp
         +YeW5KNhFIJEw==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>
Subject: Re: [PATCH RFC v5 3/4] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <a65909ee425585a49d9e17f6504cf0ba@codeaurora.org>
References: <153908805217.9471.9290979918041653328.stgit@alrua-kau> <153908837900.9471.5394468800857658136.stgit@alrua-kau> <a65909ee425585a49d9e17f6504cf0ba@codeaurora.org>
Date:   Wed, 10 Oct 2018 13:15:55 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87zhvm832s.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-10-09 05:32, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> This adds airtime accounting and scheduling to the mac80211 TXQ
>> scheduler. A new callback, ieee80211_sta_register_airtime(), is added
>> that drivers can call to report airtime usage for stations.
>>=20
>> When airtime information is present, mac80211 will schedule TXQs
>> (through ieee80211_next_txq()) in a way that enforces airtime fairness
>> between active stations. This scheduling works the same way as the=20
>> ath9k
>> in-driver airtime fairness scheduling. If no airtime usage is reported
>> by the driver, the scheduler will default to round-robin scheduling.
>>=20
>> For drivers that don't control TXQ scheduling in software, a new API
>> function, ieee80211_txq_may_transmit(), is added which the driver can=20
>> use
>> to check if the TXQ is eligible for transmission, or should be=20
>> throttled to
>> enforce fairness. Calls to this function must also be enclosed in
>> ieee80211_txq_schedule_{start,end}() calls to ensure proper locking.=20
>> TXQs
>> that are throttled by ieee802111_txq_may_transmit() will be woken up=20
>> again
>> by a check added to the ieee80211_wake_txqs() tasklet.
>>=20
>
> Toke,
>
> I am observing soft lockup issues again with this new series while
> running traffic with 50 clients. I am continuing testing with earlier
> series along with snippet I shared.

Are these new lockups (that was not in your patched previous version),
or did I just not get all your lock-related fixes incorporated?

> When driver operates in pull-mode, throttled txqs are marked and
> refilled in airtime_tasklet. This is causing major throughput drops
> and packet loss and I am suspecting the latency in replenishing
> deficit. Whereas in push-mode or in ath9k model, refill happens
> quicker at every packet indication as well as tx completion.

Yeah, the tasklet shouldn't be the main source of deficit replenishing.
Can see why that would give bad performance :)

> I am planning to get rid of tasklet completely as it is only meant for
> pull-mode. It would be better to refill in may_transmit() itself.

Hmm, right. So the way to do this correctly (from a fairness point of
view) would be something like this (in max_tx()):

if (this_txq.stn.deficit > 0)
  return true;

else if (any queued TXQ currently have positive deficit)
  return false; /* other TXQ should try may_tx() later and get permission */

else /* all deficits < 0 */
  return replenish_deficits(this_txq);

And replenish_deficits() would be something like:

replenish_deficits(this_txq) {
repeat:
  for (txq in queued txqs) {
    txq.stn.deficit +=3D stn.weight;
    if (txq.stn.deficit > 0 && !wake_txq)
      wake_txq =3D txq;
  }
  if not wake_txq:
    goto repeat;

  if (this_txq.stn.deficit > 0)
    return true;
  else
    drv_wake_tx_queue(wake_txq);
}

The wake_tx_queue call may have to be delegated to a tasklet still, to
avoid the infinite recursion problem I mentioned earlier. But the
tasklet could be made simpler and wouldn't have to be called so often...

Does the above make sense?

-Toke
