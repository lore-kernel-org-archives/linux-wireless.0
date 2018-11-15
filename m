Return-Path: <SRS0=mfDp=N2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E7BFC43441
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 06:44:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7346223CB
	for <linux-wireless@archiver.kernel.org>; Thu, 15 Nov 2018 06:44:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="TNexylXr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E7346223CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=qti.qualcomm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727099AbeKOQvT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 15 Nov 2018 11:51:19 -0500
Received: from alexa-out-tai-01.qualcomm.com ([103.229.16.226]:34060 "EHLO
        alexa-out-tai-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726958AbeKOQvT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Nov 2018 11:51:19 -0500
X-Greylist: delayed 376 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2018 11:51:17 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1542264285; x=1573800285;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=wPSvBJ4Ojy4I/McpN1B8xIcU8o6X+Sokw1xm8UB/g8w=;
  b=TNexylXrLlMnTh1IMeRFJRRH/6Eg5pfOScz602PhnJ4MfuBTZOZRsOf/
   j0JQDeO1ATGcSkAYmwe5hr7Q/oauXuu/ogHNttJM6spYcNtR/u5jVqhuX
   HI3C6isl4e7/bBCHzBzMh88XMg0v0tQ9D67kI+5WepYsnYnCz0kyFIT1e
   I=;
X-IronPort-AV: E=Sophos;i="5.56,235,1539619200"; 
   d="scan'208";a="1492821"
Subject: RE:  [PATCH] ath10k: support PCIe enter L1 state
Thread-Topic: [PATCH] ath10k: support PCIe enter L1 state
Received: from ironmsg01-tai.qualcomm.com ([10.249.140.6])
  by alexa-out-tai-01.qualcomm.com with ESMTP; 15 Nov 2018 14:38:27 +0800
X-IronPort-AV: E=McAfee;i="5900,7806,9077"; a="19032154"
Received: from aptaiexm02b.ap.qualcomm.com ([10.249.150.12])
  by ironmsg01-tai.qualcomm.com with ESMTP/TLS/AES256-SHA; 15 Nov 2018 14:38:27 +0800
Received: from aptaiexm02f.ap.qualcomm.com (10.249.150.16) by
 aptaiexm02b.ap.qualcomm.com (10.249.150.12) with Microsoft SMTP Server (TLS)
 id 15.0.1395.4; Thu, 15 Nov 2018 14:38:25 +0800
Received: from aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1]) by
 aptaiexm02f.ap.qualcomm.com ([fe80::4152:1436:e436:faa1%19]) with mapi id
 15.00.1395.000; Thu, 15 Nov 2018 14:38:25 +0800
From:   Wen Gong <wgong@qti.qualcomm.com>
To:     Brian Norris <briannorris@chromium.org>,
        Wen Gong <wgong@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Thread-Index: AQHUfHo2VSinFZ1kPUqtl7ly7haCqqVQYiVA
Date:   Thu, 15 Nov 2018 06:38:25 +0000
Message-ID: <c94346b26a6d4b11a045a176ca854051@aptaiexm02f.ap.qualcomm.com>
References: <1542163848-837-1-git-send-email-wgong@codeaurora.org>
 <20181115002836.GA71934@google.com>
In-Reply-To: <20181115002836.GA71934@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.249.136.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> -----Original Message-----
> From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Brian
> Norris
> Sent: Thursday, November 15, 2018 8:29 AM
> To: Wen Gong <wgong@codeaurora.org>
> Cc: linux-wireless@vger.kernel.org; ath10k@lists.infradead.org
> Subject: [EXTERNAL] Re: [PATCH] ath10k: support PCIe enter L1 state
>=20
> Hi Wen,
>=20
> >
> > Signed-off-by: Wen Gong <wgong@codeaurora.org>
>=20
> Is there some reason L1 was disabled in the first place? Wa
s it known to be
> unreliable?
>=20
Hi Brian,
It is a BUG for power, and it is not considered this BUG before.
So this change will fix the bug.

> Brian
>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
