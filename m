Return-Path: <SRS0=E2P1=NN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34B0FC32789
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 10:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEC242082E
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Nov 2018 10:30:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="spvxRAGi"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EEC242082E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbeKBThH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Nov 2018 15:37:07 -0400
Received: from mail.toke.dk ([52.28.52.200]:43623 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726049AbeKBThG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Nov 2018 15:37:06 -0400
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1541154623; bh=+xEZwZMEkrDviQ/DQTMjM2yo0vsKCB+oDNN28248mM8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=spvxRAGipMCAVzovVOY53TScW8QTMU55eYacxQOZ0YsNc8o/g++0DBTNq6ASm1oXN
         efgu4qOZWXqooUEQKZvQpBnrJHCiFNH98UnyEiCARZKxsG1j1+RNRWcz/WsYg/hq55
         uJqIXwMBhdKfGxNFcIjFiZutNug1CcL1mA33P7dotPh2jAlOOW1NS5GpbKE6BhG7KN
         HLuESOLN+Y8MTQd9meUWTMIRuTAPnxYTSUkKCDAcf2XciWQ/7/AT/KaiwCVsBYIK4l
         93pM7MYZPPoYSjWf+DEJMWbiMHLDAfhB9ACfwrLAn9xVwxolID9CuXjKkfx4I7ALnV
         n4a3NQcPeZ3/w==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH 3/6] mac80211: Add airtime accounting and scheduling to TXQs
In-Reply-To: <5d8415fe50e8505eb62c5a0d1b40bb2a@codeaurora.org>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org> <1540033534-11211-4-git-send-email-rmanohar@codeaurora.org> <8736ssbxp9.fsf@toke.dk> <9c2b790132a9a89fecd7dd79dc67d891@codeaurora.org> <87woq2843q.fsf@toke.dk> <8fd3524bfe022ccd2a8b61a3314ed32b@codeaurora.org> <5d8415fe50e8505eb62c5a0d1b40bb2a@codeaurora.org>
Date:   Fri, 02 Nov 2018 11:30:22 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87h8gzpy9t.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rajkumar Manoharan <rmanohar@codeaurora.org> writes:

> On 2018-10-28 15:01, Rajkumar Manoharan wrote:
>> On 2018-10-28 08:48, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>>>=20
>>>>=20
>>>> 4ms         223 (40%)         214 (40%)    109 (10%)       94 (10%)
>>>>=20
>>>> 4ms         337 (90%)         182 (8%)      23 (1%)        30 (1%)
>>>=20
>>> So this looks like it's doing *something*, but not like it's=20
>>> succeeding
>>> in achieving the set percentages. Did you check if the actual airtime
>>> values (in debugfs) corresponds to the configured weights?
>>>=20
>> No. Will check that.
>>=20
> Toke,
>
>  From above results, different airtime for each station is reflecting on
> output performance. Unfortunately I don't see such tput difference, when
> the tx mode is fixed in push-only. Even low weight station is giving=20
> same
> performance. Are you also seeing the same behavior in your setup? Could
> you please share your results?

Sorry, I've been travelling this week; I'll be back in the office next
week and can run some tests then. I may also have an idea for a
different algorithm that will work better in pull mode, but need to see
if it works at all first :)

How do I force ath10k into push mode?

-Toke
