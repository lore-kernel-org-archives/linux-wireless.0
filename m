Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 208DCC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 11:09:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D75A52086C
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 11:09:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="R3phv8cP"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D75A52086C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=nbd.name
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732655AbeKOVQl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 16:16:41 -0500
Received: from nbd.name ([46.4.11.11]:40822 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725827AbeKOVQl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 16:16:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=bzGIccfhrqEdxhQpNnp0dS/+camL9si+7bgdOwhBVjg=; b=R3phv8cPlz3JFUf5VuxSJbwXVQ
        adIph15REkIMQ5VeS00EMtIg8MYNPTuHpm/6QXG7C5LQONRuq58q3hEz7drPv1PFwOkOSgxK9nsA/
        OisN+UJfqJmmGRGhorO6fyXe4eOALkhJLw28myt06leTlBVFhMUv/vDdKtKEBTsr1FYE=;
Subject: Re: [PATCH v3 3/6] mac80211: Add airtime accounting and scheduling to
 TXQs
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@toke.dk>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net
References: <1542063113-22438-1-git-send-email-rmanohar@codeaurora.org>
 <1542063113-22438-4-git-send-email-rmanohar@codeaurora.org>
 <e5344cad-2a18-a938-f2ed-43870027251c@nbd.name> <871s7nv9pl.fsf@toke.dk>
From:   Felix Fietkau <nbd@nbd.name>
Openpgp: preference=signencrypt
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <8e7847ff-4c88-10ae-2223-2fc7321641d9@nbd.name>
Date:   Thu, 15 Nov 2018 12:09:08 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <871s7nv9pl.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-11-14 18:40, Toke Høiland-Jørgensen wrote:
>> This part doesn't really make much sense to me, but maybe I'm
>> misunderstanding how the code works.
>> Let's assume we have a driver like ath9k or mt76, which tries to keep a
>> number of aggregates in the hardware queue, and the hardware queue is
>> currently empty.
>> If the current txq entry is kept at the head of the schedule list,
>> wouldn't the code just pull from that one over and over again, until
>> enough packets are transmitted by the hardware and their tx status
>> processed?
>> It seems to me that while fairness is still preserved in the long run,
>> this could lead to rather bursty scheduling, which may not be
>> particularly latency friendly.
> 
> Yes, it'll be a bit more bursty when the hardware queue is completely
> empty. However, when a TX completion comes back, that will adjust the
> deficit of that sta and cause it to be rotated on the next dequeue. This
> obviously relies on the fact that the lower-level hardware queue is
> sufficiently shallow to not add a lot of latency. But we want that to be
> the case anyway. In practice, it works quite well for ath9k, but not so
> well for ath10k because it has a large buffer in firmware.
> 
> If we requeue the TXQ at the end of the list, a station that is taking
> up too much airtime will fail to be throttled properly, so the
> queue-at-head is kinda needed to ensure fairness...
Thanks for the explanation, that makes sense to me. I have an idea on
how to mitigate the burstiness within the driver. I'll write it down in
pseudocode, please let me know if you think that'll work.

do {
	struct ieee80211_txq *pending_txq[4];
	int n_pending_txq = 0;
	int i;

	if (hwq->pending < 4)
		break;

	nframes = 0;

	ieee80211_txq_schedule_start(hw, ac)
	do {
		bool requeue = false;

		struct ieee80211_txq *txq;

		txq = ieee80211_next_txq(hw, ac);
		if (!txq)
			break;

		nframes += schedule_txq(txq, &requeue);
		if (requeue)
			pending_txq[n_pending_txq++] = txq;

	} while (n_pending_txq < ARRAY_SIZE(pending_txq));

	for (i = n_pending_txq; i > 0; i--)
		ieee80211_return_txq(hw, pending_txq[i - 1]);

	ieee80211_txq_schedule_end(hw, ac)
} while (nframes);

- Felix
