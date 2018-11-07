Return-Path: <SRS0=0pA5=NS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 194E9C0044C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 22:35:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C978C2086C
	for <linux-wireless@archiver.kernel.org>; Wed,  7 Nov 2018 22:35:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cBQxF+mI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OViGGgoM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C978C2086C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbeKHIH7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 8 Nov 2018 03:07:59 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46086 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727694AbeKHIH7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Nov 2018 03:07:59 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1D17660741; Wed,  7 Nov 2018 22:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541630130;
        bh=6DNhox7PrMGjZlSIVUTzt2m9O8W8svFV3wZI4+DS/4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cBQxF+mIz/80JzfFNdCD0x5Rm9z2kmIlwHvyTnHe7w4ByayedevZu5twuYO9AhYyy
         CN2mPRc0/TO21GqUgWB88L/iHsJI/LIPbwDat/16Zn9wsbNPqTc6GsWtyTtubFJ5Rl
         g3vpUVAYST72xXTstQGYvfYZ3oIRz/cRZkLdLdV4=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 5CFB5603D2;
        Wed,  7 Nov 2018 22:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541630129;
        bh=6DNhox7PrMGjZlSIVUTzt2m9O8W8svFV3wZI4+DS/4g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OViGGgoM8BRMqMroX572hQ2FQ5agJj+nw9i5iMpD01p04vaiQWXdSO36uin/vVTxY
         HwMjHFFSE6edKLwpCJJyy+OFm/u7UmKuvJ5qPUpTvowqmkoo8a3WlNTreUwMa0c618
         NN3VSOQ9/v0tEGj3EKiv3R0TOot8bs8rpaHsIzes=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 07 Nov 2018 14:35:29 -0800
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 3/6] mac80211: Add airtime accounting and scheduling to
 TXQs
In-Reply-To: <87va59uegc.fsf@toke.dk>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org>
 <1540033534-11211-4-git-send-email-rmanohar@codeaurora.org>
 <8736ssbxp9.fsf@toke.dk> <9c2b790132a9a89fecd7dd79dc67d891@codeaurora.org>
 <87woq2843q.fsf@toke.dk> <8fd3524bfe022ccd2a8b61a3314ed32b@codeaurora.org>
 <5d8415fe50e8505eb62c5a0d1b40bb2a@codeaurora.org> <87h8gzpy9t.fsf@toke.dk>
 <10b644b6c7f436a892e3e9f4fd5e179d@codeaurora.org> <87va59uegc.fsf@toke.dk>
Message-ID: <e018fec62487536859ea8202b187c63e@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-07 06:53, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> Meanwhile we did some more experiments with both modes. The experiment
>> was done in open environment and fixed rate and UDP traffic ran for 60
>> seconds.
>> 
>> Seems like push mode not honoring the configured weight. Always the
>> airtime was almost same whereas in pull-mode airtime is changing based
>> on configured weight. Hence I would like to know your results.
> 
> Right, so I verified that the current version of the patch set still
> works with ath9k. However, the ath10k card I have doesn't seem to
> support peer stats, so I can't test ath10k.
> 
> $ lspci | grep Qualcomm
> 03:00.0 Network controller: Qualcomm Atheros QCA986x/988x 802.11ac
> Wireless Network Adapter
> 
> $ cat /sys/kernel/debug/ieee80211/phy1/ath10k/chip_id
> 0x043202ff
> 
> $ cat /sys/kernel/debug/ieee80211/phy1/ath10k/wmi_services  | grep PEER
> WMI_SERVICE_PEER_CACHING                 -
> WMI_SERVICE_PEER_STATS                   -
> 

Oops... Yeah 988x firmware (10.2.4) does not have peer stats support.

> 
> Is there a way to force-enable airtime support, is this a hardware 
> issue?
> 
Unfortunately not. There is one more pending change that handles airtime 
report
from HTT tx-compl. Again it depends firmware support. These experiments 
are
taken with this f/w interface. Will post the change.

>> 		sta1		sta2		sta3		sta4
>> pull-mode	8s(205us)	18s(3.2ms)	8s(205us)	14s(410us)
>> 		12s(256us)	12s(256us)	13s(256us)	12s(256us)
>> 		14s(4ms)	13s(4ms)	14s(4ms)	13s(4ms)
>> 
>> push-mode	15s(205us)	12s(3.2ms)	16s(205us)	12s(410us)
>> 		15s(256us)	12s(256us)	16s(256us)	12s(256us)
>> 		14s(4ms)	13s(4ms)	16s(4ms)	12s(4ms)
> 
> Right, so the pull-mode results are encouraging! *Something* is
> happening, at least, even though the aggregate airtime doesn't quite
> match the ratios of the configured weights.
> 
> Are you running the UDP generator on the AP itself, or on a separate
> device, BTW? If it's on the AP, the userspace socket can get throttled,
> which will interfere with results, so it's better to have it on a
> separate device (connected via ethernet).
> 
Traffic b/w wired client (via ethernet) and wireless clients.

> As for push-mode, could this be because of bad buffer management? I.e.,
> because there's a lag between the time airtime is registered, and the
> time that airtime usage is reported, the driver just pushes a whole
> bunch of packets to the firmware when it gets the chance, which 
> prevents
> the scheduler from throttling properly. This could also explain the
> better, but not quite perfect, results in pull mode, assuming that pull
> mode results in better firmware buffer management which reduces, but
> doesn't quite remove, the lag.
> 
Hmm... I agree that lag in reporting airtime may cause more data push to 
hw.
Right now both tx and tx-compl are serialized by active_txq_lock. So 
once
lock acquired by tx path, it will download all frames. i.e it is even 
true for
ath9k driver. Hence I am wondering how it is working only with ath9k.

In ath10k, The airtime always be reported in tx-completion. I dont see 
much lag
from my experiments.

> If this is indeed the reason, the queue limit patches should hopefully
> be a solution. So guess we need to get those working as well :)
> 
I would prefer to baseline the basic infra into upstream first and do 
enhancement
on top of that. I request you to revisit maintaining per driver default. 
Otherwise
there would be performance impact with 256us. :(

-Rajkumar
