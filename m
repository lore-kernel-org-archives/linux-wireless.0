Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF216C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 07:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A2E952086C
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 07:00:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=newmedia-net.de header.i=@newmedia-net.de header.b="wzHm1Fag"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A2E952086C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=newmedia-net.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728019AbeKIQjO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 11:39:14 -0500
Received: from webmail.newmedia-net.de ([185.84.6.166]:55896 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727657AbeKIQjO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 11:39:14 -0500
X-Greylist: delayed 985 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Nov 2018 11:39:14 EST
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=newmedia-net.de; s=mikd;
        h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject; bh=ZcQPK3qKB3mZ/sm+z792gJfJ8iJ0Kraezd6yZpJd+KM=;
        b=wzHm1Fag/dQWd3YXRTOB0EjWalk5TEVOyK3AR+f4i9bV3HuXwJaQftJCBPv0WUqKycgNEFR+VCrY4mXas3IUZEWBMsQr64lOK/cf5JR/DgMmfL0dIBd8vIwggKAUozXncY9o4xVfoubooLRwA0EWFJ62ari5QwYPZKprqM0MRKo=;
Subject: Re: [PATCH] ath10k: Disable 4addr source port learning in 10.4 FW by
 default
To:     Sathishkumar Muruganandam <murugana@codeaurora.org>,
        ath10k@lists.infradead.org
Cc:     linux-wireless@vger.kernel.org
References: <20181109061121.4184-1-murugana@codeaurora.org>
From:   Sebastian Gottschall <s.gottschall@newmedia-net.de>
Message-ID: <adc29966-6d95-e666-b61f-238053b0dea2@newmedia-net.de>
Date:   Fri, 9 Nov 2018 07:43:38 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20181109061121.4184-1-murugana@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Received:  from [2003:c9:3f20:e600:a8f2:f0d7:63ab:c05a]
        by webmail.newmedia-net.de with esmtpsa (TLSv1:AES128-SHA:128)
        (Exim 4.72)
        (envelope-from <s.gottschall@newmedia-net.de>)
        id 1gL0W4-0003PJ-VY; Fri, 09 Nov 2018 07:43:41 +0100
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

thank you very much. waiting for this fix since a long time. i also 
reported this issue years ago with no response

Sebastian

Am 09.11.2018 um 07:11 schrieb Sathishkumar Muruganandam:
> One such visible functional impact is when GTK rekey frame from
