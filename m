Return-Path: <SRS0=xI28=P5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4675C2F441
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 16:48:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 81D1820663
	for <linux-wireless@archiver.kernel.org>; Mon, 21 Jan 2019 16:48:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="ICLfXLei"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730366AbfAUQsl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 21 Jan 2019 11:48:41 -0500
Received: from mail.toke.dk ([52.28.52.200]:34375 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730135AbfAUQsl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 21 Jan 2019 11:48:41 -0500
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1548089319; bh=r14cw7ZTUoQ1g4hz99LMnr1pSAW48GyAl0gMHC4xJrQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ICLfXLeilaNBk4jMoPimgwPV2d0LNe/wKyvlbTiTCmE9mmwC8va8gZhS6NcE0GArt
         hiPLwCvPxbxJe2iqa088ssDMjy6jwET/GqxuyrUBmZ1TCGPPOGYdRIK0bwlY9XLLzH
         bsb9scYcbxFY/oSYEbyKcAXk+wy5uZOcFzW9P3nPKPZMfshTfOVN/vAlR+3bhL00/P
         2IRHkAY7NAGByWv0cpgumF/e4WNtnzbX3wiPIk0pyictUszSJbyenj6buKO+2Aal6r
         Gb/uT/TJTjgopGJdVjIBNO/Z2nDFkik8IIPTrJYmQGOD9x7mvPMq5Ihpfso7is2VHH
         /O9Cg6+Az5Wrw==
To:     Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     make-wifi-fast@lists.bufferbloat.net, Kan Yan <kyan@google.com>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Subject: Re: [PATCH v4 6/6] ath10k: reporting estimated tx airtime for fairness
In-Reply-To: <8736pmmjbk.fsf@toke.dk>
References: <1545172374-1072-1-git-send-email-rmanohar@codeaurora.org> <1545172374-1072-7-git-send-email-rmanohar@codeaurora.org> <8736pmmjbk.fsf@toke.dk>
Date:   Mon, 21 Jan 2019 17:48:39 +0100
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87sgxmklco.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk> writes:

> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
>
>> From: Kan Yan <kyan@google.com>
>>
>> Transmit airtime will be estimated from last tx rate used.
>> Firmware report tx rate by peer stats. Airtime is computed
>> on tx path and the same will be reported to mac80211 upon
>> tx completion.
>
> FYI, it seems that this last patch in the series no longer applies
> cleanly on top of mac80211-next. May need a refresh.
>
> The mac80211 parts were merged into mac80211-next (thanks, Johannes!); I
> guess the driver updates are waiting for drivers-next to catch up to
> that?
>
> Patches 4 and 5 in the series are fine...

This was meant to be a reply to v5 of the patch set (which is where I
had the issue); apologies for picking the wrong one to reply to...

-Toke
>
> -Toke
