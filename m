Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C0EFC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:29:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25F6D20657
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 16:29:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Dj9GyEjk";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OBqlmXvm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbfAPQ3N (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 11:29:13 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:50808 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725320AbfAPQ3N (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 11:29:13 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 32827607DE; Wed, 16 Jan 2019 16:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547656152;
        bh=Mx8xI5Et49VlkQlFAUQZRJGnf3pfMfSnFxGPFlPGgSY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Dj9GyEjkq+T5FnY8bFfUTu7MYqmMZa2i14WVNciP0KySTe65/oAVQAamqWZYdVtUM
         ng7GIZ8CkkeMM/tZS8CLv4UrA1MW5S3OWPE4bXbB/ol8TWO7cTq8UxkS6uat6bW9bV
         sLInCht5jj2iBlt7q9XNZ6Rmjv39Cob1iuZBt3FM=
Received: from x230.qca.qualcomm.com (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EA63A60208;
        Wed, 16 Jan 2019 16:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1547656151;
        bh=Mx8xI5Et49VlkQlFAUQZRJGnf3pfMfSnFxGPFlPGgSY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=OBqlmXvmfxu3pKeuXdjlUCB+yL1UPJR2V14qtdI3YrflY4KAFM4p9eNq0uH7QWpqm
         cPZYJEwlAtqaRCRTgND+qi9Tk0abrnUkPZxJZOLRw7LUzOkLkTH+aXQLEChRz06qMl
         EAjm0i70YbmETuCfoT3rIVeDYjxoA7kDuTmuzdk4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EA63A60208
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rt61pci: Work around a firmware bug with shared keys
References: <AM0PR07MB3874E8F6ADD41C4E1BCBE43EE4810@AM0PR07MB3874.eurprd07.prod.outlook.com>
        <20190116112129.GC5234@redhat.com>
Date:   Wed, 16 Jan 2019 18:29:07 +0200
In-Reply-To: <20190116112129.GC5234@redhat.com> (Stanislaw Gruszka's message
        of "Wed, 16 Jan 2019 12:21:30 +0100")
Message-ID: <87imyo4ld8.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Tue, Jan 15, 2019 at 02:01:29PM +0000, Bernd Edlinger wrote:
>> Apparently the rt2x61 firmware fails temporarily to decode
>> broadcast packets if the shared keys are not assigned
>> in the "correct" sequence. At the same time unicast
>> packets work fine, since they are encrypted with the
>> pairwise key.
>> 
>> At least with WPA2 CCMP mode the shared keys are
>> set in the following sequence: keyidx=1, 2, 1, 2.
>> After a while only keyidx 2 gets decrypted, and
>> keyidx 1 is ignored, probably because there is never
>> a keyidx 3.
>> 
>> Symptoms are arping -b works for 10 minutes, since
>> keyidx=2 is used for broadcast, and then it stops
>> working for 10 minutes, because keyidx=1 is used.
>> That failure mode repeats forever.
>> 
>> Note, the firmware does not even know which keyidx
>> corresponds to which hw_key_idx so the firmware is
>> trying to be smarter than the driver, which is bound
>> to fail.
>> 
>> As workaround the function rt61pci_config_shared_key
>> requests software decryption of the shared keys,
>> by returning EOPNOTSUPP. However, pairwise keys are
>> still handled by hardware which works just fine.
>> 
>> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
>
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>

The prefix should be "rt2x00:", I can change that.

-- 
Kalle Valo
