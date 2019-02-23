Return-Path: <SRS0=o7U+=Q6=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61DB0C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 11:50:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E58A20850
	for <linux-wireless@archiver.kernel.org>; Sat, 23 Feb 2019 11:50:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="RxPj5v4g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbfBWLuC (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 23 Feb 2019 06:50:02 -0500
Received: from mail.toke.dk ([52.28.52.200]:50931 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726326AbfBWLuB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 23 Feb 2019 06:50:01 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1550922599; bh=QNrDEdMdycbcQNCifwf0LmANy1ACZijCXl+8BgfAoEg=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=RxPj5v4gmyl7dcodlW/C53sZGXN+5dSzgFVTGPpYaXcY4EQHs7YGXE6VLUiW8G8Ls
         cvfhcnINGMH3Kj9WV08V4/omOq6+Ij9R9SRrXqPuFtfkTZKgM3GjVYYqE1IPuOQnzU
         pGtpRYDRZrTQq1bovzr13V8NmgY5JHsNmcjUmVj/TiVizqUzv7j+vd3HUpr3XsikW3
         hyH8fH8G24M3A79gBoXvlzNc4Hpw9Nx0XoeAaY1AhDDFz4/grDv9PO8uTc/ohB/4FU
         BP41EbBgfKELao0a9h6hmMuTXxOrpc9kkFYBfkq1Wck3vOTlb7Ciz5Q41gjqwoDZjX
         4Kj9MZkf/Gnig==
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>,
        Grant Grundler <grundler@google.com>,
        Kalle Valo <kvalo@codeaurora.org>, wgong@qti.qualcomm.com,
        ath10k@lists.infradead.org, wgong@codeaurora.org,
        Kan Yan <kyan@google.com>
Subject: Re: [PATCH] mac80211: Change default tx_sk_pacing_shift to 7
In-Reply-To: <44add7675ef89dd61fcea9da6b55804c498a2d24.camel@sipsolutions.net>
References: <20190221172936.21816-1-toke@redhat.com> <E1gx9x3-0002j0-1J@sipsolutions.net> <87lg28vup0.fsf@toke.dk> <a5151441bdfe02cb11043aa0786185b8ee3c3ee9.camel@sipsolutions.net> <87imxcvt4z.fsf@toke.dk> <44add7675ef89dd61fcea9da6b55804c498a2d24.camel@sipsolutions.net>
Date:   Sat, 23 Feb 2019 12:49:58 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87d0niwwpl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Johannes Berg <johannes@sipsolutions.net> writes:

> On Fri, 2019-02-22 at 14:40 +0100, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>=20
>> And send it directly to stable, or does it need to go through you?
>
> I added a Cc: stable tag. So all you really need to do is wait for the
> emails telling you it failed to apply, and handle accordingly :)

Cool, that I can do; thanks! :)

-Toke
