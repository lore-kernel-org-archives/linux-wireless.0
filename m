Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97AB1EB64DA
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jul 2023 09:10:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235403AbjGNJKm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Jul 2023 05:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235100AbjGNJKl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Jul 2023 05:10:41 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CD262682
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jul 2023 02:10:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Qa6yXh1WvqZZFFhVuvsf4c5pd78bRCTOhNnyd7qma9I=; b=KqXDfWMhgIoAgZD7dpNGFWWQJu
        5HYKALqjiQ5S7W1zFlvTvSifKdALqg1BNU9cNIuaSVar2HDpuOO7HrM8yhq8aL5VHQVevVnNCGQm2
        nuiobnqmCKSMjFoZn3EKb4PoaXuKEAFOx9DivooCQTwlXjK0kPvQgI11iG6q7F1AO1tA=;
Received: from p4ff134dd.dip0.t-ipconnect.de ([79.241.52.221] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1qKEou-000pNC-Fo; Fri, 14 Jul 2023 11:10:36 +0200
Message-ID: <be80dd0f-a266-4666-4987-0659ca0449f3@nbd.name>
Date:   Fri, 14 Jul 2023 11:10:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH] wifi: mt76: use native timestamps for RX reordering
To:     Dmitry Antipov <dmantipov@yandex.ru>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org
References: <20230712173437.162921-1-dmantipov@yandex.ru>
Content-Language: en-US
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20230712173437.162921-1-dmantipov@yandex.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 12.07.23 19:34, Dmitry Antipov wrote:
> Prefer native (i.e. unsigned long) timestamps for RX reordering. Since
> 'struct mt76_rx_status' with native timestamp becomes too large to fit
> into 48-byte 'cb' area of 'struct sk_buff', use separate timestamps in
> reorder array of 'struct mt76_rx_tid' instead.
> 
> Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Why?

- Felix


