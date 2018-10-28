Return-Path: <SRS0=/i66=NI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58C08C2BC61
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Oct 2018 22:01:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08A2A2082B
	for <linux-wireless@archiver.kernel.org>; Sun, 28 Oct 2018 22:01:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Db8TnnhC";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Db8TnnhC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 08A2A2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727995AbeJ2Grj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Oct 2018 02:47:39 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57744 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727756AbeJ2Gri (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Oct 2018 02:47:38 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id E956E60B7D; Sun, 28 Oct 2018 22:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540764101;
        bh=VCT+ALNOAog7jLR7edfwE2eox8w3/Xl/gOUG6lut5Zg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Db8TnnhC/N5cVnFEiPDcGD6nLFwpBgDhdsHNTS0DJD8Kwgmfb8MYsY4eKelMv2Rgv
         h6r/FmfCE438hCccR0iSMwJPztmSPV5ByNlXFqQZTw4MSJ+zjrXogS6w/+H6SLL+qr
         Lmpueo+TS3qGBTA7AVbGpJJqoi9ju41DqMg+ipZg=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 578D96021A;
        Sun, 28 Oct 2018 22:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540764101;
        bh=VCT+ALNOAog7jLR7edfwE2eox8w3/Xl/gOUG6lut5Zg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Db8TnnhC/N5cVnFEiPDcGD6nLFwpBgDhdsHNTS0DJD8Kwgmfb8MYsY4eKelMv2Rgv
         h6r/FmfCE438hCccR0iSMwJPztmSPV5ByNlXFqQZTw4MSJ+zjrXogS6w/+H6SLL+qr
         Lmpueo+TS3qGBTA7AVbGpJJqoi9ju41DqMg+ipZg=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Sun, 28 Oct 2018 15:01:41 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH 3/6] mac80211: Add airtime accounting and scheduling to
 TXQs
In-Reply-To: <87woq2843q.fsf@toke.dk>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org>
 <1540033534-11211-4-git-send-email-rmanohar@codeaurora.org>
 <8736ssbxp9.fsf@toke.dk> <9c2b790132a9a89fecd7dd79dc67d891@codeaurora.org>
 <87woq2843q.fsf@toke.dk>
Message-ID: <8fd3524bfe022ccd2a8b61a3314ed32b@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-28 08:48, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> Yes. I do understand the user can change airtime at anytime but It
>> must be noted that different airtime weight will result in different
>> throughput. IMHO the defaults should not impact current benchmark.
>> Otherwise it will be alarmed as regression later. isn't it?
> 
> My point is that if the user has to know the implementation-specific
> limitations of each driver before setting a weight, then it's not a
> particularly friendly API. I think we should be able to do better than
> that...
> 
Hmm.. I was trying to balance throughput vs CPU usage. Keeping lower
threshold is causing more lock contention and impacting throughput.
I thought of configuring default airtime_weight from hostapd for
legacy, 11n and 11ac stations.

>> airtime   station1(%airtime)  station2     station3       station4
>> (Mbps)
>> 
>> No ATF      182               168          166            169
>> 
>> 4ms         170 (100%)        164 (100%)   185  (100%)    175 (100%)
>> 
>> 4ms         277 (70%)         115 (10%)    103 (10%)      105 (10%)
>> 
>> 4ms         223 (40%)         214 (40%)    109 (10%)       94 (10%)
>> 
>> 4ms         337 (90%)         182 (8%)      23 (1%)        30 (1%)
> 
> So this looks like it's doing *something*, but not like it's succeeding
> in achieving the set percentages. Did you check if the actual airtime
> values (in debugfs) corresponds to the configured weights?
> 
No. Will check that.

>> The only way to enforce mac80211 ordering in ath10k is to disable pull
>> mode in firmware and always operates in push mode similar to ath9k.
> 
> And I assume that is not too likely to happen, or? What is the benefit
> of pull mode at the firmware level?
> 
Pull mode mainly required to support MU-MIMO. IMHO both MUMIMO & ATF can 
not
co-exist unless both are implemented at host driver. Fixing tx mode in 
ath10k
needs firmware reload. By introducing modparam, pull-mode can be 
disabled.

-Rajkumar
