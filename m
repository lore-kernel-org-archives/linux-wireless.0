Return-Path: <SRS0=/7yp=NT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7ACCECDE47
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 13:46:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 771EF20825
	for <linux-wireless@archiver.kernel.org>; Thu,  8 Nov 2018 13:46:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="Omk4p5Ro"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 771EF20825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbeKHXVm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 18:21:42 -0500
Received: from mail.toke.dk ([52.28.52.200]:36221 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727038AbeKHXVm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 18:21:42 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1541684767; bh=BbP4htCdPNdlVee+3vPB014QlGVnQwVlMsYaljhRpwY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=Omk4p5RoXq0eCQBBHsEUkqIoJDOPPjHID+syI7hgd8FtRMlO2U9DADYwzbtKnatxZ
         sUtxXo920DzrVhI0U4vHVvWaxisv/zzUkVxy+QVADTjtK2yPeuk6zvIYkk/Y8vB+JK
         t3YBpSS6n8R66jqg0i6MWMXAJcDv1IjvbAREZSiddIaUsHldANhgkZnb1G5R57jkDj
         eTn80QVCeXPJ5haTGYeGa7QnPlb0M4uQWDAeKSsXwTOF1GdQCNrP+cGZeF1l1JmGfm
         wMxx59iy5Vs7EDNxHLk85E0804QTARIWLzmBEFZMWZjai34/p7GBDyrX0S4BuRpO00
         vpWCKojuFSGtg==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 3/6] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <e018fec62487536859ea8202b187c63e@codeaurora.org>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org> <1540033534-11211-4-git-send-email-rmanohar@codeaurora.org> <8736ssbxp9.fsf@toke.dk> <9c2b790132a9a89fecd7dd79dc67d891@codeaurora.org> <87woq2843q.fsf@toke.dk> <8fd3524bfe022ccd2a8b61a3314ed32b@codeaurora.org> <5d8415fe50e8505eb62c5a0d1b40bb2a@codeaurora.org> <87h8gzpy9t.fsf@toke.dk> <10b644b6c7f436a892e3e9f4fd5e179d@codeaurora.org> <87va59uegc.fsf@toke.dk> <e018fec62487536859ea8202b187c63e@codeaurora.org>
Date:   Thu, 08 Nov 2018 14:46:06 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <874lcrvg0x.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-11-07 06:53, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>=20
>>> Meanwhile we did some more experiments with both modes. The experiment
>>> was done in open environment and fixed rate and UDP traffic ran for 60
>>> seconds.
>>>=20
>>> Seems like push mode not honoring the configured weight. Always the
>>> airtime was almost same whereas in pull-mode airtime is changing based
>>> on configured weight. Hence I would like to know your results.
>>=20
>> Right, so I verified that the current version of the patch set still
>> works with ath9k. However, the ath10k card I have doesn't seem to
>> support peer stats, so I can't test ath10k.
>>=20
>> $ lspci | grep Qualcomm
>> 03:00.0 Network controller: Qualcomm Atheros QCA986x/988x 802.11ac
>> Wireless Network Adapter
>>=20
>> $ cat /sys/kernel/debug/ieee80211/phy1/ath10k/chip_id
>> 0x043202ff
>>=20
>> $ cat /sys/kernel/debug/ieee80211/phy1/ath10k/wmi_services  | grep PEER
>> WMI_SERVICE_PEER_CACHING                 -
>> WMI_SERVICE_PEER_STATS                   -
>>=20
>
> Oops... Yeah 988x firmware (10.2.4) does not have peer stats support.
>
>>=20
>> Is there a way to force-enable airtime support, is this a hardware=20
>> issue?
>>=20
> Unfortunately not. There is one more pending change that handles
> airtime report from HTT tx-compl. Again it depends firmware support.
> These experiments are taken with this f/w interface. Will post the
> change.

Right, thought so. Too bad. Guess you are doing all the ath10k testing,
then ;)

>>> 		sta1		sta2		sta3		sta4
>>> pull-mode	8s(205us)	18s(3.2ms)	8s(205us)	14s(410us)
>>> 		12s(256us)	12s(256us)	13s(256us)	12s(256us)
>>> 		14s(4ms)	13s(4ms)	14s(4ms)	13s(4ms)
>>>=20
>>> push-mode	15s(205us)	12s(3.2ms)	16s(205us)	12s(410us)
>>> 		15s(256us)	12s(256us)	16s(256us)	12s(256us)
>>> 		14s(4ms)	13s(4ms)	16s(4ms)	12s(4ms)
>>=20
>> Right, so the pull-mode results are encouraging! *Something* is
>> happening, at least, even though the aggregate airtime doesn't quite
>> match the ratios of the configured weights.
>>=20
>> Are you running the UDP generator on the AP itself, or on a separate
>> device, BTW? If it's on the AP, the userspace socket can get throttled,
>> which will interfere with results, so it's better to have it on a
>> separate device (connected via ethernet).
>>=20
> Traffic b/w wired client (via ethernet) and wireless clients.

Cool.

>> As for push-mode, could this be because of bad buffer management? I.e.,
>> because there's a lag between the time airtime is registered, and the
>> time that airtime usage is reported, the driver just pushes a whole
>> bunch of packets to the firmware when it gets the chance, which=20
>> prevents
>> the scheduler from throttling properly. This could also explain the
>> better, but not quite perfect, results in pull mode, assuming that pull
>> mode results in better firmware buffer management which reduces, but
>> doesn't quite remove, the lag.
>>=20
> Hmm... I agree that lag in reporting airtime may cause more data push
> to hw. Right now both tx and tx-compl are serialized by
> active_txq_lock. So once lock acquired by tx path, it will download
> all frames. i.e it is even true for ath9k driver. Hence I am wondering
> how it is working only with ath9k.

If enough packets are dequeued at once that the TXQ empties and is not
put back on the scheduling loop, the next_txq() loop is just going to
loop through the remaining TXQs and immediately increase their quantum.
In ath9k, there's a maximum of two outstanding aggregates below the TXQ
level, but I think you mentioned that ath10k can queue thousands in
firmware?

Your patch removes the 'max 16 packets at a time' check before the call
to ath10k_mac_tx_push_txq(); try adding that back and see if it helps?

>> If this is indeed the reason, the queue limit patches should hopefully
>> be a solution. So guess we need to get those working as well :)
>>=20
> I would prefer to baseline the basic infra into upstream first and do
> enhancement on top of that.

Sure, I'm fine with merging this first and building on top.

> I request you to revisit maintaining per driver default. Otherwise
> there would be performance impact with 256us. :(

Hmm, how about we make it a driver-specified multiplier instead (which
could be 4, 8 or 16 for ath10k)? That way it would still work even if
userspace changes the weights. It would affect the minimum possible
granularity, but that is probably acceptable; and we would be free to
change the mechanism later, without affecting the userspace API.

-Toke
