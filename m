Return-Path: <SRS0=tUzJ=SY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6620C282E1
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 04:29:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BD7920811
	for <linux-wireless@archiver.kernel.org>; Mon, 22 Apr 2019 04:29:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="ZJL3L8iH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbfDVE1P (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 22 Apr 2019 00:27:15 -0400
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:34037 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725904AbfDVE1P (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Apr 2019 00:27:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1555907234; x=1587443234;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=OJ20iIf9v2b9Zs5hT7WyoUqOHNO1i2IzA/TKXJbNPrE=;
  b=ZJL3L8iHZ0ae/8KPhePgP2qcE9VgWKoq0cA2/5HLoNVngF2T/HPiPLJ+
   OFySNzZV8S7steAoF8IixnVIjlVJ9nqa8OuD1gN/Yz60qx1lqohq49YK7
   qWY1X3slNyOWNXPWBdpvMH4IkZiC9R5Mea4uHYbIs3vnZkZowZ3fp6QrK
   g=;
X-IronPort-AV: E=Sophos;i="5.60,380,1549900800"; 
   d="scan'208";a="2208477"
Subject: RE: [PATCH v2] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Thread-Topic: [PATCH v2] ath10k: Remove ATH10K_STATE_RESTARTED in simulate fw crash
Received: from ironmsg01-tai.qualcomm.com ([10.249.140.6])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 22 Apr 2019 12:27:12 +0800
X-IronPort-AV: E=McAfee;i="5900,7806,9234"; a="27527188"
Received: from aptaiexm02f.ap.qualcomm.com ([10.249.150.16])
  by ironmsg01-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 22 Apr 2019 12:27:12 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02f.ap.qualcomm.com (10.249.150.16) with Microsoft SMTP Server (TLS)
 id 15.0.1395.4; Mon, 22 Apr 2019 12:27:10 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1395.000; Mon, 22 Apr 2019 12:27:10 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     Wen Gong <wgong@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Thread-Index: AQHU8Q11Cs6Zgqo75ECaXs0knszql6ZHo+nQ
Date:   Mon, 22 Apr 2019 04:27:09 +0000
Message-ID: <8db13f128fc345a9a7d0a021d19cf9cf@aptaiexm02f.ap.qualcomm.com>
References: <1555059170-11988-1-git-send-email-wgong@codeaurora.org>
In-Reply-To: <1555059170-11988-1-git-send-email-wgong@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.249.136.10]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> -----Original Message-----
> From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Wen Gong
> Sent: Friday, April 12, 2019 4:53 PM
> To: ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Subject: [EXT] [PATCH v2] ath10k: Remove ATH10K_STATE_RESTARTED in
> simulate fw crash
> @@ -554,6 +555,9 @@ static ssize_t ath10k_write_simulate_fw_crash(struct
> +	sscanf(buf, "%s %s", buf_cmd, buf_flag);
> +	ath10k_info(ar, "buf_cmd:%s, buf_flag:%s\n", buf_cmd, buf_flag);
> +
> +	wait_ready =3D !strcmp(buf_cmd, "wait-ready");
>  	mutex_lock(&ar->conf_mutex);
>=20
> -	if (ar->state !=3D ATH10K_STATE_ON &&
> -	    ar->state !=3D ATH10K_STATE_RESTARTED) {
> +	if ((!wait_ready &&
> +	     ar->state !=3D ATH10K_STATE_ON &&
> +	     ar->state !=3D ATH10K_STATE_RESTARTED) ||
> +	    (wait_ready &&
> +	     ar->state !=3D ATH10K_STATE_ON)) {
>  		ret =3D -ENETDOWN;
>  		goto exit;
>  	}
>=20

Hi Micha=B3,

Do you have any comments for the patch v2?

> 1.9.1
>=20
>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
