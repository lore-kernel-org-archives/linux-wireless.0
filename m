Return-Path: <SRS0=2I9a=RX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01F1CC43381
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 05:36:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C675B2186A
	for <linux-wireless@archiver.kernel.org>; Wed, 20 Mar 2019 05:36:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="dkX+tfoa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727682AbfCTFgP (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 20 Mar 2019 01:36:15 -0400
Received: from mout.gmx.net ([212.227.17.22]:49721 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbfCTFgP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 20 Mar 2019 01:36:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1553060162;
        bh=kWBahTr4EBmI1Q7hvCWRCwSa+fuLA6gThCEi1Fh98QE=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=dkX+tfoaZrUfdVymlzBqAf1kh73oxrtpFE/lUwfDGYv7By/fC8OQAkWpr37XKUP0R
         XmEj0r6G2AwoEGL9QCtNURJvnt6voNJvCvjxjMcKu7AfQAPb1G0LaeQRSfGNN5kK22
         CMhqK735WEKEjVL9yXJPL+PDSEZDMtXgTw8+fj1E=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.202] ([217.250.36.4]) by mail.gmx.com (mrgmx103
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0MUHbK-1hXOgC229y-00Qx5M; Wed, 20
 Mar 2019 06:36:02 +0100
Subject: Re: [PATCH] ath9k: Check for errors when reading SREV register
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190318190557.21599-1-timschumi@gmx.de>
 <CAKR_QV+wjuOZVfv9awX5bRLYC8xkoAy0h22LSPvL0DX6yg4-yw@mail.gmail.com>
 <57195909-b18b-8490-e1b8-043ff9727e5a@gmx.de>
 <CAKR_QVKWbrx2EmcaCBhyuaYRd+T3pFW0i2jVcDZG6=wee=DaMA@mail.gmail.com>
From:   Tim Schumacher <timschumi@gmx.de>
Openpgp: preference=signencrypt
Autocrypt: addr=timschumi@gmx.de; keydata=
 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
Message-ID: <db5b0b39-525b-3e79-1461-e8d42bfff419@gmx.de>
Date:   Wed, 20 Mar 2019 06:35:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CAKR_QVKWbrx2EmcaCBhyuaYRd+T3pFW0i2jVcDZG6=wee=DaMA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:eX3EcL2RmHJoacRInx+KQ/0yYVmJh7ghpRQjx9wvZ6Y+OyrNgGc
 MK0o4P6ztujRRDgWrQNgZyr5n15XkY0iP1SWEOa2jLukmyWD3Zw3ysX6hhPEyiq5fCZmok1
 Xjsgf58TknU15+XpI30EkGcKpfszYdyXIklvp8k1rz//DnvX+ATapLLcs7t1749lcedaLQ/
 3gUPPB2VzVDIIMgJRwNhQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Tj1UonexgbE=:gPuAA1LEfEfgNkeEJnhf0R
 LrPN4+zsEIbLu9neZfPfmgqEJLKNeyFO3t/gTBDq4ba+R2Fx8TMB3k8G4ZwKkbjq3C7JT9Uju
 W6kwsethXPXHFIFfigpXTlvruFyTHgq1Ord1pAngZ6M2paAbAbp0jRc1tdwhDKyq/nuFzqoTp
 lMf+bS+uLsXVt3z/bT0AKvWbgRwvMYaaJtcIfD7f7O/HVHoGvbWIh8XtIMfQfhJjz2pILGsci
 jzIhUsFn3TAfVomUB3xlWHfHlkskUoiRS302Q+qt8CCRdJpP0mnfoxdURYUxSFLTx8CFT49kS
 jhJHfqOCsYMBmlZ/f/1thiz8SMz+yI3x2/pOtZp622kBz8aOKruuiU7Rp8A90zIwY9ghVlZyN
 dyYzixc930LQvci4OxgiClD/t30Hxjlt+KDb1GJuzoyx6/u27dt+wo9daC3/2pwFJyQWzjuMt
 zZ0Ku98MAkQ92mMsxoDLI5U6CP8IUGE9sLT2u2Ppd+kN5lNRNG/34SUDR/l+djZIq/VQ//MQU
 DpiD3gL5bs75uZrdBlb9CrFQmmvzMwpPg2k4CuoNlv9cI5LoS2nHsf7+di+DrKlV+S4HEKh98
 ljDBpqlKpUE80G63fadhnvxwsZYl/TECO5DGlf3RHakMVLdwgXod+RU3H0bS+l6oBcI/oCqRS
 jDXbAHgqNbKyHUzUZ08+UpY3NpgT6oj1cPAitduw4P2CKiXc6BlP1maVpmTgiy53U6bo31v7q
 3IkJC7f4btbQHnlfTB+ND+bf9erykLw0jTbTjQvJZbah7HkITOe48RtwhP1v0EfXiw2HgnEJ3
 L0DDutz0VKJ1n4h2WoYCW2KVQZSWE6iMFTvLFhko+xXlj+XYwq/Gtms7eWwqPEPdyKykF5AeV
 pZOxcIUOasBsyJdnyMV2f0hyijeHs6Hvnfy2YajRdAggLUpnreS5nae19NWQ0d08WK5fya8Fd
 WBsF+PGbGbw==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 20.03.19 00:38, Tom Psyborg wrote:
> On 19/03/2019, Tim Schumacher <timschumi@gmx.de> wrote:
>>
>> The case in where the revision succeeded to read, but it simply
>> isn't supported by the driver, is untouched and it still prints
>> the original message.
>>
>
> In that case this change is fine.
>
>> I don't know why it fails to read the SREV register in my specific
>> case (I tracked it down to a WMI command timeout, which seems to
>> only happen on a Raspberry Pi 3), but having the SREV error message
>> (which points to the actual issue) instead of the false-positive
>> "Rev not supported" message would have saved me quite some time that
>> I spent with debugging the issue, searching for the source of the
>> wrong value.
>>
>
> Did you try some other device than RPI3 ? I've noticed that on router
> and laptop while doing some htc fw builds.
>

I don't have that many other devices to test, but everything worked
fine on both of my PCs and it was fine on the RPi3 that was running
a raspbian-based kernel instead of mainline.
