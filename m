Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E50C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:39:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D51C820825
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 12:39:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=toke.dk header.i=@toke.dk header.b="wLxa6AJJ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D51C820825
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=toke.dk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbeKIWTi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 17:19:38 -0500
Received: from mail.toke.dk ([52.28.52.200]:60671 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727662AbeKIWTi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 17:19:38 -0500
Date:   Fri, 09 Nov 2018 13:39:06 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1541767149; bh=4KjkzuqO9d8leHtnfZeoqpLHd9kYIBXWTowMv3YeeVI=;
        h=Date:In-Reply-To:References:Subject:To:From:From;
        b=wLxa6AJJO/2PqCPC+i8GUe6OuTYQ7IvnsHvghNEQDaWM6UXaRDg/9SNoR+h+Inoy5
         EZD3zvoqwawh9wTk5pdZKLLKSaqE1l192vDSo+73W2Z/laufC4GQ3jcfVRxale5qvM
         r4zl63x0AbrI6jYV7+QcQTBI9I+hBGRoXWqAGoGQ71yC0jtEVoXqAmlRlcCLikgXAi
         kOSDapEdr4R2C9OFeNDt0y3PfYtN0G4BbVHH3MBtR2UpxpBL9UdSBkw6EeUQVj1X+H
         KTW4OEA1lQei59XrnMbWdEA0WLSsCD1kaEKh/ufeGikw/tKeISv3xxCuKzpCm/gFLY
         aXCJNPvc3cBfA==
In-Reply-To: <78adf728bab8943152dc4db311c50fedbe5710f1.camel@sipsolutions.net>
References: <1540033534-11211-1-git-send-email-rmanohar@codeaurora.org> <1540033534-11211-2-git-send-email-rmanohar@codeaurora.org> (sfid-20181020_130555_381291_6F3867B0) <78adf728bab8943152dc4db311c50fedbe5710f1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/6] mac80211: Add TXQ scheduling API
To:     Johannes Berg <johannes@sipsolutions.net>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
From:   =?ISO-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@toke.dk>
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <A76C82FF-46AD-4BDB-A5DA-932E97536FEB@toke.dk>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



On 9 November 2018 13:00:04 CET, Johannes Berg <johannes@sipsolutions=2Ene=
t> wrote:
>On Sat, 2018-10-20 at 04:05 -0700, Rajkumar Manoharan wrote:
>>=20
>> + * @txq: pointer obtained from station or virtual interface, or from
>> + *       ieee80211_next_txq()
>
>nit: please just indent by a single tab for continuation, trying to
>line
>it all up doesn't really make it more readable

Not sure I agree about the "not more readable" part, but OK=2E

>I see you're still discussing all this, so I'm going to assume you'll
>resend this series eventually :-)

Yup=2E Think we're getting close to something that might be mergeable=2E W=
ill send another version then :)

-Toke
