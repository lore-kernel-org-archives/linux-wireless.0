Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A542ECDE46
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 18:55:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 222A6207DD
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 18:55:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="KCDJKewt";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Epwg0oA3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 222A6207DD
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbeJYDYi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 23:24:38 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:53982 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbeJYDYi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 23:24:38 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 93AAB60C4F; Wed, 24 Oct 2018 18:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540407325;
        bh=c9zkLL3Q89pQF1hlz9HdPCPB0Ch4uq6q6cRqvBwbZIA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KCDJKewt5G6SHr4QszPmlQJd5wKLGM7zMNYOUc71gqwwv0vkZ5DwPwzhDS5uizNlH
         8U7oYvux5BkP0DWBGp2mTqIYqYOYuUwZ+v7vDv+3N37248p1OKv5Bl4iOYvICqHs/y
         pzsMQ2cg28/noy6di0jd6WqG+XHpfYoIOAEktpGI=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 9D3ED60ADB;
        Wed, 24 Oct 2018 18:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1540407314;
        bh=c9zkLL3Q89pQF1hlz9HdPCPB0Ch4uq6q6cRqvBwbZIA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Epwg0oA3+eRJPk4O8qgiRj5ZCWF7WB+vh4E/cfaDUoKxwrBtqA0+ScEfpVTjZLP/f
         Ve1wQ1Im19D2Mh4CFVPtdW+g5yFGA0H0vDhbFnZjph/dy5ShQBq1fBoaFtYhCh7GdV
         pZriCoDXK+2B7tqQM8yt0JUa+3lToDk0tB2/EJUY=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Wed, 24 Oct 2018 11:55:14 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
        =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: Re: [PATCH 5/6] ath10k: migrate to mac80211 txq scheduling
In-Reply-To: <87a7n3u4kl.fsf@codeaurora.org>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org>
 <1540033534-11211-6-git-send-email-rmanohar@codeaurora.org>
 <87a7n3u4kl.fsf@codeaurora.org>
Message-ID: <051d255c3377cd9d1724cc288df2d8c2@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-24 01:33, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> ath10k maintains common txqs list for all stations. This txq
>> management can be removed by migrating to mac80211 txq APIs
>> and let mac80211 handle txqs reordering based on reported airtime.
>> By doing this, txq fairness maintained in ath10k i.e processing
>> N frames per txq is removed. By adapting to mac80211 APIs,
>> ath10k will support mac80211 based airtime fairness algorithm.
>> 
>> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
>> Signed-off-by: Rajkumar Manoharan <rmanohar@codeaurora.org>
> 
> Is Toke the original author? Then you should add "From:" tag to mark
> that. And you might want to use Co-developed-by to mark yourself as
> co-developer.
> 
Toke submitted ath10k changes in RFC v1 but those were dropped
in follow up series. When I reworked on ath10k, I retaining his s-o-b.

Will fix it.

-Rajkumar
