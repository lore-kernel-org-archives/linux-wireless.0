Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD378C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 06:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8A4A420872
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 06:42:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727142AbfCSGmB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 02:42:01 -0400
Received: from mout.gmx.net ([212.227.15.19]:33499 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbfCSGmA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 02:42:00 -0400
Received: from [10.2.0.3] ([217.250.40.46]) by mail.gmx.com (mrgmx003
 [212.227.17.190]) with ESMTPSA (Nemesis) id 0MV5hN-1hVob02Z01-00YUV6; Tue, 19
 Mar 2019 07:41:47 +0100
Subject: Re: [PATCH] ath9k: Check for errors when reading SREV register
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190318190557.21599-1-timschumi@gmx.de>
 <CAKR_QV+wjuOZVfv9awX5bRLYC8xkoAy0h22LSPvL0DX6yg4-yw@mail.gmail.com>
From:   Tim Schumacher <timschumi@gmx.de>
Openpgp: preference=signencrypt
Autocrypt: addr=timschumi@gmx.de; keydata=
 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
Message-ID: <57195909-b18b-8490-e1b8-043ff9727e5a@gmx.de>
Date:   Tue, 19 Mar 2019 07:41:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <CAKR_QV+wjuOZVfv9awX5bRLYC8xkoAy0h22LSPvL0DX6yg4-yw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:PuVpnyiEl1n5X8FlpFTxMHlcQH/K+zv1VMYQh34DDpBvjQONBv6
 l4Tk3vnh/OcCWkywRli7ZZ6dTjYb7PkJ+z2Y9HZHuLly8o4zr5GWOdZbSVTBOtlJ79WNOkf
 IhBk5V3xguTWHujPAu3E4xp1ohTinH6CrmeBBUlq7o+RoVloGKfiVOtYSN5LMc2stW03KoF
 LCgOSeKfrI8Kw6Y35BJRQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:eoHB45S6n2A=:WzRPDQxrVzO6QCg9cJqTCv
 5MTEk2MaIxOgf4zGTXV+ocWrRRF3czsy+retJViB120aWUZ9qoRhfnVZQnNXZnzLBcyDe71YP
 RIZOBj5pLfjh4v8umIFqE/PCui8DnWHMGMT3b1xe/pKXQ+nDhHt2JZUsY4IJywUsM07kzWEV7
 VozAEBqMMwQcqyXDBGQl2WNHSvwnpKgwWCNMtcVKWuUiXcQmpUpdJHyxmIztJ8XkBnMLZG4h5
 oPddld0J3TmRwOV2dlHsng/wZVz4N42x2BETNaBsRFLaN1eLa2e/QMCRE2PO0wA3EJi/srIys
 gkyu2GgP0tUzJom10L4Yg+UpIgl4Q6byE3dNtWw6YVSIqLhJnodEMSgjB4+71p58kdjnr3kuG
 OTFRJ5Gs3ohjhJjXaxJmwqVV/awVAqttJuHnoL2TmjeQHJ5b/U/1iLciUVbKVA5pgA2ndJh00
 5uMFi2ZP74uUTu2Tn+DjsaSQODQu23P9RVwkfTRanwXRm00Zdg60Ck52XYUuZEWYrDlO3bq7T
 +RkhKd3915XnpN+qCM0eu8/hlpDrabHVokKOVaWAPKlB5v8+V5Abn0jnVHfpTnfPJdF8/+33x
 IImFqxQb33uRBuzL4b3u6egJZlzeV9ODRNzTMZIe+jgpjGzyGhNIbArbEo5QnekAVmXjtG8kG
 Mv0eZ0rkj7zdjgWhHI8VJag/CkdpW27arJ2JVslqhKESStHQ2yidI/AGN5NWVBIClItrEZl9g
 iuol3YDaVowZ4qKib2+Ft+B1E8zip4mjIzK3XzJ9ALhdsJ1h8nbxBBVYDHID1Nnzr37gd/Q6E
 Mjo8bqMYsA7EcbC2RUiMedjbGsyNpYrr7JGQDIlYvHcNsl6Ey6i81ZyKhdqxdzXDS3heC+JCq
 69EfntqlIv7Q0UFt3TbSCuglN8bVtS2R8l/XJ660o9Esuhwr7SKlNywMhmOA9eUwIJz/0KsnL
 W/d6Oex50KQ==
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 18.03.19 23:35, Tom Psyborg wrote:
> On 18/03/2019, Tim Schumacher <timschumi@gmx.de> wrote:
>> Right now, if an error is encountered during the SREV register
>> read (i.e. an EIO in ath9k_regread()), that error code gets
>> passed all the way to __ath9k_hw_init(), where it is visible
>> during the "Chip rev not supported" message.
>>
>>     ath9k_htc 1-1.4:1.0: ath9k_htc: HTC initialized with 33 credits
>>     ath: phy2: Mac Chip Rev 0x0f.3 is not supported by this driver
>>     ath: phy2: Unable to initialize hardware; initialization status: -95
>>     ath: phy2: Unable to initialize hardware; initialization status: -95
>>     ath9k_htc: Failed to initialize the device
>>
>> Check for -EIO explicitly in ath9k_hw_read_revisions() and return
>> a boolean based on the success of the operation. Check for that in
>> __ath9k_hw_init() and abort with a more debugging-friendly message
>> if reading the revisions wasn't successful.
>>
> 
> you are still passing it all the way from ath9k_hw_init
> 

I meant the actual error code (i.e. -EIO) there, which gets checked
for right after the REG_READ() call in ath9k_hw_read_revisions(). If
it's present, it immediately prints the "SREV register" message and
returns false instead of true.

>>     ath9k_htc 1-1.4:1.0: ath9k_htc: HTC initialized with 33 credits
>>     ath: phy2: Failed to read SREV register
>>     ath: phy2: Could not read hardware revision
>>     ath: phy2: Unable to initialize hardware; initialization status: -95
>>     ath: phy2: Unable to initialize hardware; initialization status: -95
>>     ath9k_htc: Failed to initialize the device
>>
>> This helps when debugging by directly showing the first point of
>> failure and it could prevent possible errors if a 0x0f.3 revision
>> is ever supported.
>>
> 
> I don't think this is required. Mac Chip Rev 0x0f.3 at least prints
> what the problem is instead of generic SREV read failure.

The point of this patch is that the "Mac Chip Rev" (in this case)
is a false message and that it actually _doesn't_ show what the
problem is. There is no Rev that is 0x0f.3. It just falsely takes
the -EIO from ath9k_regread() as a valid return value (since it
is never caught earlier) and tries to extract a revision from it,
which results in 0x0f.3.

The case in where the revision succeeded to read, but it simply
isn't supported by the driver, is untouched and it still prints
the original message.

> Either wrong
> define in driver or address overlap caused by large/bad firmware in
> ath9k_htc case.
>

I don't know why it fails to read the SREV register in my specific
case (I tracked it down to a WMI command timeout, which seems to
only happen on a Raspberry Pi 3), but having the SREV error message
(which points to the actual issue) instead of the false-positive
"Rev not supported" message would have saved me quite some time that
I spent with debugging the issue, searching for the source of the
wrong value.
