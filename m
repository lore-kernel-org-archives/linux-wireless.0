Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B3B5C004D3
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 08:12:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0311B2081B
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 08:12:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qca.qualcomm.com header.i=@qca.qualcomm.com header.b="zLcLW8pU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0311B2081B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=qca.qualcomm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727579AbeJXQjI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 12:39:08 -0400
Received: from alexa-out-ams-01.qualcomm.com ([185.23.61.162]:54523 "EHLO
        alexa-out-ams-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726732AbeJXQjI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 12:39:08 -0400
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Oct 2018 12:39:06 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qca.qualcomm.com; i=@qca.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1540368723; x=1571904723;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=MUsGFMqrI/RqibRKHczBMT8v7IKt0yVamEjoy90YRc4=;
  b=zLcLW8pU9/1h/m7ZrKPhc64cnjwd5xRokPvdP26NSmXcSAQ/C5gm6Wko
   q4dquAgkYNbOEEUfFvIpQccG77H9Nv4SN0j3oZo41klN3sGg0tEMMG0zx
   52ydhIFy26SUGbbCvAJ+gJyf5pLRyNw9P4SxVt4Q1q44qlpKVKARpfu3r
   o=;
X-IronPort-AV: E=Sophos;i="5.54,419,1534802400"; 
   d="scan'208";a="1384585"
Received: from ironmsg03-ams.qualcomm.com ([10.251.56.4])
  by alexa-out-ams-01.qualcomm.com with ESMTP; 24 Oct 2018 10:05:47 +0200
X-IronPort-AV: E=McAfee;i="5900,7806,9055"; a="6106319"
Received: from euamsexm01e.eu.qualcomm.com ([10.251.127.42])
  by ironmsg03-ams.qualcomm.com with ESMTP/TLS/AES256-SHA; 24 Oct 2018 10:05:47 +0200
Received: from euamsexm01a.eu.qualcomm.com (10.251.127.40) by
 euamsexm01e.eu.qualcomm.com (10.251.127.42) with Microsoft SMTP Server (TLS)
 id 15.0.1365.1; Wed, 24 Oct 2018 10:05:45 +0200
Received: from euamsexm01a.eu.qualcomm.com ([10.251.127.40]) by
 euamsexm01a.eu.qualcomm.com ([10.251.127.40]) with mapi id 15.00.1365.000;
 Wed, 24 Oct 2018 10:05:45 +0200
From:   Kalle Valo <kvalo@qca.qualcomm.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
CC:     "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        Govind Singh <govinds@codeaurora.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "niklas.cassel@linaro.org" <niklas.cassel@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        David Brown <david.brown@linaro.org>
Subject: Re: [GIT] Networking
Thread-Topic: [GIT] Networking
Thread-Index: AQHUa3BdF4XdUlTYE0KLV6oOVLPx7Q==
Date:   Wed, 24 Oct 2018 08:05:45 +0000
Message-ID: <87h8hbu5uy.fsf@qca.qualcomm.com>
References: <20181023.202921.1185045750138652543.davem@davemloft.net>
        <CAHk-=whuhCGujWKO8JObGQaSdWOpJBXdkM-B-vD80QZifveScw@mail.gmail.com>
        <CAHk-=wh2H9jE2RXibQgWs3_Q539roj62_gzPXKjnhhKqSFcw2g@mail.gmail.com>
        <87lg6nu6k1.fsf@codeaurora.org>
In-Reply-To: <87lg6nu6k1.fsf@codeaurora.org> (Kalle Valo's message of "Wed, 24
        Oct 2018 10:50:38 +0300")
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [199.106.107.6]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Kalle Valo <kvalo@codeaurora.org> writes:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>> On Wed, Oct 24, 2018 at 7:01 AM Linus Torvalds
>> <torvalds@linux-foundation.org> wrote:
>>>
>>> Hmm. Tentatively pulled, but there's something wrong with the Kconfig r=
ules.
>>
>> Confirmed.
>
> BTW, our emails crossed and more info in the other email[1].
>
>> I did a978a5b8d83f ("net/kconfig: Make QCOM_QMI_HELPERS available when
>> COMPILE_TEST") to fix the breakage.
>
> Thanks, though I don't see it yet as I guess you haven't pushed it yet.
> Do note that it _might_ conflict the other commit which I suspect is in
> also coming to you:
>
> ccfb464cd106 ("soc: qcom: Allow COMPILE_TEST of qcom SoC Kconfigs")

git.kernel.org is alive again for me so I can now check both commits. It
seems that Niklas' commit[1] is more finegrained than what Linus did[2].
I guess either of the commits should be reverted when Niklas' commit
goes to Linus tree, or what's the best course of action?

[1] https://git.kernel.org/pub/scm/linux/kernel/git/agross/linux.git/commit=
/?h=3Dfor-next&id=3Dccfb464cd106890cfa51070f75921a273e2852e5

[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/comm=
it/?id=3Da978a5b8d83f795e107a2ff759b28643739be70e

--=20
Kalle Valo=
