Return-Path: <SRS0=1g4v=XS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D03C04EBF
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 12:12:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95BA520820
	for <linux-wireless@archiver.kernel.org>; Mon, 23 Sep 2019 12:12:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iQhJqro0";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="iQhJqro0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730199AbfIWMMN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 23 Sep 2019 08:12:13 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:43086 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726212AbfIWMMM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Sep 2019 08:12:12 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id CC81160736; Mon, 23 Sep 2019 12:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569240731;
        bh=HPVEQ3qiV4dE5Y7MN8XXgTbjV11uMPNbSBokopg4sog=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iQhJqro0695diy/Mv9ZHAGi0vqvzg8md86xhrwDqkj2lUjm5NIeUNoHfqt/lho4fD
         L7EbyL3T/1Kpq+/Yju1TN4rYMWwULDAfOiPEodWi4/nxzcp1IrIN3ZEuh7aNu71gGj
         QFWl+dAR60sLY35CXhAgsQJowlWkZjQVmJOnIzYo=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 787AB6013C;
        Mon, 23 Sep 2019 12:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1569240731;
        bh=HPVEQ3qiV4dE5Y7MN8XXgTbjV11uMPNbSBokopg4sog=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iQhJqro0695diy/Mv9ZHAGi0vqvzg8md86xhrwDqkj2lUjm5NIeUNoHfqt/lho4fD
         L7EbyL3T/1Kpq+/Yju1TN4rYMWwULDAfOiPEodWi4/nxzcp1IrIN3ZEuh7aNu71gGj
         QFWl+dAR60sLY35CXhAgsQJowlWkZjQVmJOnIzYo=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Mon, 23 Sep 2019 20:12:11 +0800
From:   Wen Gong <wgong@codeaurora.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: add fw coredump for sdio when firmware assert
In-Reply-To: <87v9tj6y5p.fsf@codeaurora.org>
References: <1567132338-7407-1-git-send-email-wgong@codeaurora.org>
 <874l15c20j.fsf@codeaurora.org>
 <6b7927f633cb7cbe2ba0d958d7d06f9a@codeaurora.org>
 <87v9tj6y5p.fsf@codeaurora.org>
Message-ID: <e61e7cbe3fd9dfad4679bd1d686bc44d@codeaurora.org>
X-Sender: wgong@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-09-23 19:37, Kalle Valo wrote:
> Wen Gong <wgong@codeaurora.org> writes:
> 
>> On 2019-09-21 19:38, Kalle Valo wrote:
>>> 
>>> What's wrong with ath10k_sdio_hif_diag_read()? AFAICS this whole
>>> function duplicates just what it does.
>> 
>> ath10k_sdio_hif_diag_read's buffer size is limit,
>> and the dump memory/register's buffer size is larger than the diag
>> window's limit,
>> if use it directly will trigger crash like this for every time.
> 
> You shouldn't blindly add extra code to ath10k workaround issues. And 
> if
> you really need to use a workaround, then it needs to properly 
> explained
> in the commit and as well as commented in the code. But before that the
> issue needs to be thoroughly investigated and understood where the
> problem is coming from. Because it might be even completely unrelated 
> to
> ath10k.

> 
>> [  149.947624] ath10k_sdio mmc1:0001:1: ath10k_sdio_hif_diag_read
>> buf_len :4
>> [  149.954741] ath10k_sdio mmc1:0001:1: ath10k_sdio_hif_diag_read
>> buf_len :240
>> [  151.005143] Unable to handle kernel paging request at virtual

>> [  151.114537] Process swapper/0 (pid: 0, stack limit =
>> 0x00000000e30dc665)
、
> 
> Did you investigate this? Is the buffer you reading to DMA accessible?
> What about the alignment? Is there a certain length which is the limit
> for crashes? And so on...
the limit is 4 byte.
for 5 bytes, it will crash.
