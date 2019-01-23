Return-Path: <SRS0=ZHYo=P7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0213CC282C9
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 04:25:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C576B21019
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Jan 2019 04:25:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WH773/Ux";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WH773/Ux"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727056AbfAWEZf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 22 Jan 2019 23:25:35 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33958 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726963AbfAWEZf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Jan 2019 23:25:35 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 70BA56044E; Wed, 23 Jan 2019 04:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548217534;
        bh=9bdqg6OpZ8ek1oU3R3Vu/FLqBQ9mD8YwsTtbzaFP8dQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WH773/UxFi//9rZN1tBisF+0R2C4Wu5Qwi5/dYELTEdif5Ct+M8dqymh+dGxQsHh5
         LLDHxw0B1RwhddpOSbpqKVqq7WIXNnvfzt2EJ1oEyl3m8n/qSDDhbP10YLzMyA533m
         t2z50hr2Lj+nhQN0qjw4uSbM0Ef94ECIRZlpGWYg=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id A77A26013C;
        Wed, 23 Jan 2019 04:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548217534;
        bh=9bdqg6OpZ8ek1oU3R3Vu/FLqBQ9mD8YwsTtbzaFP8dQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WH773/UxFi//9rZN1tBisF+0R2C4Wu5Qwi5/dYELTEdif5Ct+M8dqymh+dGxQsHh5
         LLDHxw0B1RwhddpOSbpqKVqq7WIXNnvfzt2EJ1oEyl3m8n/qSDDhbP10YLzMyA533m
         t2z50hr2Lj+nhQN0qjw4uSbM0Ef94ECIRZlpGWYg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org A77A26013C
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?B?5aec5pm65Lyf?= <qq282012236@gmail.com>
Cc:     ath9k-devel@qca.qualcomm.com, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath: move spin_lock_bh to spin_lock in tasklet
References: <20190122163033.51095-1-qq282012236@gmail.com>
        <87ef94myo0.fsf@kamboji.qca.qualcomm.com>
        <CANHzP_uiEoYaSg4fC1gHHjc=gRLjaxt8S3=p6a-rkg5-WjR7MA@mail.gmail.com>
Date:   Wed, 23 Jan 2019 06:25:29 +0200
In-Reply-To: <CANHzP_uiEoYaSg4fC1gHHjc=gRLjaxt8S3=p6a-rkg5-WjR7MA@mail.gmail.com>
        (=?utf-8?B?IuWnnOaZuuS8nyIncw==?= message of "Wed, 23 Jan 2019 10:51:19
 +0800")
Message-ID: <87a7jsm24m.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

=E5=A7=9C=E6=99=BA=E4=BC=9F <qq282012236@gmail.com> writes:

> Will do, thanks!=20

Also don't send HTML mail :) Maillists drop those automatically.

--=20
Kalle Valo
