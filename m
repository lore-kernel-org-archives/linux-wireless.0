Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE893C04EB9
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 19:36:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82EC6208A3
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 19:36:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="c8LaebeD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 82EC6208A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbeLCTgo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 14:36:44 -0500
Received: from mail.toke.dk ([52.28.52.200]:54193 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725890AbeLCTgo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 14:36:44 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1543865800; bh=wUmp+n1eeYbdxIQE3qHWLj3hQSfFxx0y+70w+5RIw80=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=c8LaebeDA7VTQC4wWRPSsOKZ+RTUWzqnS1cHxV00Xx+iop+YXAnyujz9Zz8I2nm6v
         eRt/ChK/LOx0GPExU6uim+O/uxB7cSta1C5ON/E/eOaJze8kVLlD0LOIu+iuO8cEw+
         Sx2KGpQZHW/biGPae9UvzEXYHAN8K4xYl4vH135CKyr4UM1pAZVV1mVvvSUqbXN2UG
         YEKTdnR+rhk/nfzHM6BB5otY72q5BcLamAfxBThfdMsyv/v08BaDv53yRvSg4eQd3Y
         qfe3rImB39pK+9NVGX/xMm/EpEZMlNWHG6fVuhg+n8NhqEIOb3/sMsN8aJhtB4bwq7
         yKocE9ftNs4vQ==
To:     Johannes Berg <johannes@sipsolutions.net>,
        =?utf-8?Q?Micha=C5=82?= Kazior <kazikcz@gmail.com>,
        lorenzo.bianconi@redhat.com
Cc:     kvalo@codeaurora.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>, brouer@redhat.com
Subject: Re: [RFC 0/5] add XDP support to mt76x2e/mt76x0e drivers
In-Reply-To: <bb855ffd6043743ef10058c9395d0c6b42a7832a.camel@sipsolutions.net>
References: <cover.1543343124.git.lorenzo.bianconi@redhat.com> <8736rla4ow.fsf@purkki.adurom.net> <20181128104436.GA2298@localhost.localdomain> <87bm69v0ol.fsf@toke.dk> <20181128131141.GD2298@localhost.localdomain> <875zwhuvta.fsf@toke.dk> <20181128143533.GE2298@localhost.localdomain> <87zhtttg8p.fsf@toke.dk> <20181128153508.GG2298@localhost.localdomain> <87in0gu78s.fsf@toke.dk> <20181129125929.GB6365@localhost.localdomain> <CABvG-CVpYXpjE9vxsA90qzsGm3n48SBYv-dYWAB8vi9-dvhK4A@mail.gmail.com> <87k1kwq9bo.fsf@toke.dk> <bb855ffd6043743ef10058c9395d0c6b42a7832a.camel@sipsolutions.net>
Date:   Mon, 03 Dec 2018 21:36:37 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87bm62jtbu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Johannes

I think your email can be basically summed up to:

> [ ... ] but really I think it's a can of worms.

...right? :)

I sort of had a feeling it would be, but thank you for spelling out in
excruciating detail why that is so.

Given this, I think I agree that it's not worth it for now, and we
should hold off on adding XDP support until we have 802.3/.11 conversion
offload working... Which I think is also where you ended up? :)

-Toke
