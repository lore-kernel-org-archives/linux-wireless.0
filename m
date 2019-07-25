Return-Path: <SRS0=wvrd=VW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87359C7618B
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Jul 2019 05:59:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B535206DD
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Jul 2019 05:59:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="IHN1HE79";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="DhxaidlF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbfGYF7p (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Jul 2019 01:59:45 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:38684 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728970AbfGYF7p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jul 2019 01:59:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1C48460312; Thu, 25 Jul 2019 05:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564034384;
        bh=ADI4qEjHe7gkm/jWbTCwTSNbvBnDACdDyQAayf58nYw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=IHN1HE79hHMp0TRyMiOoxNdkszJrnzEfU9KMT9Zef8coJ4ywasvPnjje7/dId0fje
         ztM0yBTOQeZC2JrX7ZOHep2CsEtVDnbHGRGsW7zRN/svrc7fL4fkF2UZ2Fyl+tHVR8
         dWYqDQIB/GIBKJXoqK3zmX9ZcK19tq+4JxQzFJjQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id C52BE602B7;
        Thu, 25 Jul 2019 05:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564034383;
        bh=ADI4qEjHe7gkm/jWbTCwTSNbvBnDACdDyQAayf58nYw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DhxaidlFEupym/VTOeH6Vqj6vjgzhNo8N6UgDnSH6GM/1DA88pCUsqrGkLUBsUZuI
         SDR9avVXEHJ/nBroGzDcQE2yDvNgdGRV0+4rXe+fNle1mGy2KZ23I8io6AQgDYVGAq
         NC3ZsOJZBEvW+FK51r+uANiHmWUSKbgC76A5f4Kw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org C52BE602B7
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Brian Norris <briannorris@chromium.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC PATCH] rtw88: use txpwr_lmt_cfg_pair struct, not arrays
References: <20190713013232.215138-1-briannorris@chromium.org>
        <20190724112304.7DDF960909@smtp.codeaurora.org>
        <F7CD281DE3E379468C6D07993EA72F84D187DDAE@RTITMBSVM04.realtek.com.tw>
Date:   Thu, 25 Jul 2019 08:59:40 +0300
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D187DDAE@RTITMBSVM04.realtek.com.tw>
        (Tony Chuang's message of "Thu, 25 Jul 2019 02:26:45 +0000")
Message-ID: <87ef2ezmb7.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> Brian Norris <briannorris@chromium.org> wrote:
>> 
>> > We're just trusting that these tables are of the right dimensions, when
>> > we could do better by just using the struct directly. Let's expose the
>> > struct txpwr_lmt_cfg_pair instead.
>> >
>> > The table changes were made by using some Vim macros, so that should
>> > help prevent any translation mistakes along the way.
>> >
>> > Remaining work: get the 'void *data' out of the generic struct
>> > rtw_table; all of these tables really deserve to be their own data
>> > structure, with proper type fields.
>> >
>> > Signed-off-by: Brian Norris <briannorris@chromium.org>
>> 
>> To me this looks like a clear improvement and I'm inclined to apply it. Tony,
>> what do you think?
>
> I think it indeed is better to use struct instead of arrays to access the table.
> But what I am trying to do is to figure a way to write a proper struct for
> radio_[ab] tables. Since the parsing logic is more complicated than others.
>
> Once I finished them, I will send a patch to change the tables.

Are you saying that your patch will also clean up these txpwr tables and
I should drop this patch? Or can I apply this?

-- 
Kalle Valo
