Return-Path: <SRS0=8CYu=OJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE603C04EB8
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 19:05:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5E1420673
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 19:05:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=marvell.com header.i=@marvell.com header.b="peLeyysK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5E1420673
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=marvell.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726792AbeLAGPJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 1 Dec 2018 01:15:09 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:45326 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725842AbeLAGPJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Dec 2018 01:15:09 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id wAUJ04KK015940;
        Fri, 30 Nov 2018 11:04:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=9tBtL1JHl6ghZpe+NIX4glfnRUd/wIb0/aY17WCBgTs=;
 b=peLeyysKudjGH7Ae088rLNzWF2e4LRedcdP7zGfFbg1Y6P1K5VVoLzj1rP1DD37UkDHq
 OB7wUCL59WlZKuso8UEzgdTxxq4fV8mAJHHvHUQVZaMNJF/CZNSyAqvplbRTniv7Fpik
 JXo6fvbSAGPafBiQpKT/TqktzhhEYeZp/kAX+OTWzW5In9szVLE2NPzp2QqJZX7BcBuz
 KE4K2eYnF3P0LeHYpWcwjrYVvWXNL/ZZUvM+hr2wcjqtfa8Wg9t6AC49QDVaZ8oXRtJl
 UWvxEyeIHI15wAqWe8Y7dWuy1XoFb1TFh5E+5YbkGlV0k20hPE0jhc7OwVn+VOSzKL01 gg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2p322et5bu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 30 Nov 2018 11:04:50 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 30 Nov
 2018 11:04:49 -0800
Received: from SC-EXCH02.marvell.com ([fe80::980b:63cf:b3c0:7c95]) by
 SC-EXCH02.marvell.com ([fe80::980b:63cf:b3c0:7c95%20]) with mapi id
 15.00.1367.000; Fri, 30 Nov 2018 11:04:49 -0800
From:   Ganapathi Bhat <gbhat@marvell.com>
To:     Brian Norris <briannorris@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Amitkumar Karwar" <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [EXT] [4.20 PATCH] Revert "mwifiex: restructure
 rx_reorder_tbl_lock usage"
Thread-Topic: [EXT] [4.20 PATCH] Revert "mwifiex: restructure
 rx_reorder_tbl_lock usage"
Thread-Index: AQHUiNaKT7djGVDyUkmVsQwZLL0jnqVoq67Q
Date:   Fri, 30 Nov 2018 19:04:49 +0000
Message-ID: <2cbb1f04ef8545ad9eaf3d7551a5dc03@SC-EXCH02.marvell.com>
References: <20181130175957.167031-1-briannorris@chromium.org>
In-Reply-To: <20181130175957.167031-1-briannorris@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.93.176.43]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2018-11-30_09:,,
 signatures=0
X-Proofpoint-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=467 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1811300161
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Brian,
>=20
> This was clearly not tested well at all. I simply performed 'wget' in a l=
oop and
> it fell over within a few seconds.
Sorry. I had run a iperf test before sharing the patch (no regression obser=
ved).
It looks I failed to get this right for second time I will check this.

Regards,
Ganapathi
