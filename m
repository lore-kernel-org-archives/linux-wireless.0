Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DB8CC10F0B
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 07:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 150EE214DA
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 07:27:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="P7qm4JqO";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="S/iegJG8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbfDRH07 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 03:26:59 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34904 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfDRH07 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 03:26:59 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 2B24A6072E; Thu, 18 Apr 2019 07:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555572418;
        bh=P1Y0lZ3w5CLY9Miph+oPMeWdcsmC1FM3wKp6Zn7vRGk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P7qm4JqOyXFn6aPfFBD36Q429+fUF5f4Gv9oFJNleltuVSNofgwbPzww0jia3V4/B
         IwbOI8apq8oyFRpv1l981B4v9n9bhD6VZHcq8r/bxkiQFbvsTZzAGueN3sMqQrVt63
         NNSVJ2T0SiGujgAJxqHE9+WAZw0rFtKskKPXNsKY=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id AF4106055C;
        Thu, 18 Apr 2019 07:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555572417;
        bh=P1Y0lZ3w5CLY9Miph+oPMeWdcsmC1FM3wKp6Zn7vRGk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=S/iegJG830+YhWg7Z9lvgWXA8AvLc2KVvWYmpaixDRx8l2tpIlmZc9HfxjAWaT8Au
         XpFYObS+PlwvUzp3p6ZRva9jRpweT16iIdGZDOmx93xNQnhgkX4NnJBdhWFdYKkBqE
         WnO49Rb5MAs27ysT79Jj/4vZnLQwqFWr+QCfOm5M=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 18 Apr 2019 15:26:57 +0800
From:   leiwa@codeaurora.org
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: fix different tx duration output
In-Reply-To: <87mukprnie.fsf@toke.dk>
References: <1555489045-18070-1-git-send-email-leiwa@codeaurora.org>
 <87mukprnie.fsf@toke.dk>
Message-ID: <298a645b17aac0f5c466f011225533b0@codeaurora.org>
X-Sender: leiwa@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-04-17 17:26, Toke Høiland-Jørgensen wrote:
> Lei Wang <leiwa@codeaurora.org> writes:
> 
>> TX duration output of tx_stats in debugfs and station dump had big
>> difference because they got tx duration value from different statistic
>> data. We should use the same statistic data.
> 
> So are you sure you picked the most accurate one of the two? :)
> 
> -Toke

Hi Toke,

Yes.
Now for ath10k, there are two ways to get tx duration output.
One is got from tx_stats in debugfs reported by firmware. It is a total 
value including all the frames which created by host and firmware sent 
to the peer.
And the second is calculated from 
ath10k_htt_rx_tx_compl_ind()-->ieee80211_sta_register_airtime(), here 
the tx duration just includes the data frames sent from host to the 
peer.
So the first value is preferable for station dump.

Thanks.
Lei
