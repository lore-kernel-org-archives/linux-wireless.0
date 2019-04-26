Return-Path: <SRS0=OO7s=S4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9539C43219
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 13:45:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8FAC0206E0
	for <linux-wireless@archiver.kernel.org>; Fri, 26 Apr 2019 13:45:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="HLkX+Ol6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbfDZNpF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 26 Apr 2019 09:45:05 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:12763 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726069AbfDZNpF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Apr 2019 09:45:05 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Apr 2019 09:45:05 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1556286304; x=1587822304;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=FxXewssfjh16gy3kH0I7m4ychNwk0S1CpyahnqM8e5g=;
  b=HLkX+Ol6V+t1R/bVBMJWWHNyzjItF96v1omIUXklMBUqXIy4/AsqjZzO
   WOEOkQ1MTgfPhcT+aWx7Tc8L30ihZSlcTh5p+4GBoPmnrIS58Qoaq+3B/
   LQaPNVD6WkuNdSgBY6TNb1m1V3+bjlRDoie8KwGzhx//7k9Rwv4fIZ233
   Q=;
X-IronPort-AV: E=Sophos;i="5.60,397,1549958400"; 
   d="scan'208";a="44796905"
Subject: RE: [PATCHv2] ath10k: Add wrapper function to ath10k debug
Thread-Topic: [PATCHv2] ath10k: Add wrapper function to ath10k debug
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 26 Apr 2019 06:38:57 -0700
Received: from nasanexm01c.na.qualcomm.com ([10.85.0.83])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/AES256-SHA; 26 Apr 2019 06:38:57 -0700
Received: from APSANEXR01B.ap.qualcomm.com (10.85.0.37) by
 NASANEXM01C.na.qualcomm.com (10.85.0.83) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 26 Apr 2019 06:38:57 -0700
Received: from APSANEXR01F.ap.qualcomm.com (10.85.0.39) by
 APSANEXR01B.ap.qualcomm.com (10.85.0.37) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Fri, 26 Apr 2019 06:38:54 -0700
Received: from APSANEXR01F.ap.qualcomm.com ([10.85.0.39]) by
 APSANEXR01F.ap.qualcomm.com ([10.85.0.39]) with mapi id 15.00.1395.000; Fri,
 26 Apr 2019 06:38:53 -0700
From:   Venkateswara Naralasetty <vnaralas@qti.qualcomm.com>
To:     Ben Greear <greearb@candelatech.com>,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC:     Kan Yan <kyan@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Thread-Index: AQHU/DMHYOGTaL3nPkmlHm5n3SU94aZObvhA
Date:   Fri, 26 Apr 2019 13:38:53 +0000
Message-ID: <be151755e771423eaa0ad6e6e2e81c2b@APSANEXR01F.ap.qualcomm.com>
References: <1556283505-29539-1-git-send-email-vnaralas@codeaurora.org>
 <b9f263a4-e9da-18bb-5932-941a018ee860@candelatech.com>
In-Reply-To: <b9f263a4-e9da-18bb-5932-941a018ee860@candelatech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.80.80.8]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> -----Original Message-----
> From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Ben
> Greear
> Sent: Friday, April 26, 2019 6:52 PM
> To: Venkateswara Naralasetty <vnaralas@codeaurora.org>;
> ath10k@lists.infradead.org
> Cc: Kan Yan <kyan@chromium.org>; linux-wireless@vger.kernel.org
> Subject: [EXT] Re: [PATCHv2] ath10k: Add wrapper function to ath10k debug
>=20
> On 4/26/19 5:58 AM, Venkateswara Naralasetty wrote:
> > ath10k_dbg() is called in ath10k_process_rx() with huge set of
> > arguments which is causing CPU overhead even when debug_mask is not
> set.
> > Good improvement was observed in the receive side performance when
> > call to ath10k_dbg() is avoided in the RX path.
> >
> > Since currently all debug messages are sent via tracing
> > infrastructure, we cannot entirely avoid calling ath10k_dbg.
> > Therefore, call to
> > ath10k_dbg() is made conditional based on tracing config in the driver.
> >
> > Trasmit performance remains unchanged with this patch; below are some
> > experimental results with this patch and tracing disabled.
> >
> > mesh mode:
> >
> > 		w/o this patch          with this patch
> > Traffic       TP      CPU Usage      TP      CPU usage
> >
> > TCP          840Mbps    76.53%      960Mbps    78.14%
> > UDP          1030Mbps   74.58%      1132Mbps   74.31%
> >
> > Infra mode:
> >
> > 		w/o this patch          with this patch
> > Traffic        TP      CPU Usage      TP      CPU usage
> >
> > TCP Rx       1241Mbps   80.89%      1270Mbps   73.50%
> > UDP Rx       1433Mbps   81.77%      1472Mbps   72.80%
> >
> > Tested platform	: IPQ8064
> > hardware used	: QCA9984
> > firmware ver	: ver 10.4-3.5.3-00057
> >
> > Signed-off-by: Kan Yan <kyan@chromium.org>
> > Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
> > ---
> > v2:
> >   * changed trace enabled check from
> IS_ENABLED(CONFIG_ATH10K_TRACING)
> >   * to trace_ath10k_log_dbg_enabled().
> >
> >   drivers/net/wireless/ath/ath10k/core.c  |  2 ++
> >   drivers/net/wireless/ath/ath10k/debug.c |  8 ++++----
> >   drivers/net/wireless/ath/ath10k/debug.h | 22 ++++++++++++++++------
> >   drivers/net/wireless/ath/ath10k/trace.c |  1 +
> >   drivers/net/wireless/ath/ath10k/trace.h |  6 +++++-
> >   5 files changed, 28 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/net/wireless/ath/ath10k/core.c
> > b/drivers/net/wireless/ath/ath10k/core.c
> > index cfd7bb2..ab709bf 100644
> > --- a/drivers/net/wireless/ath/ath10k/core.c
> > +++ b/drivers/net/wireless/ath/ath10k/core.c
> > @@ -26,6 +26,8 @@
> >   #include "coredump.h"
> >
> >   unsigned int ath10k_debug_mask;
> > +EXPORT_SYMBOL(ath10k_debug_mask);
> > +
> >   static unsigned int ath10k_cryptmode_param;
> >   static bool uart_print;
> >   static bool skip_otp;
> > diff --git a/drivers/net/wireless/ath/ath10k/debug.c
> > b/drivers/net/wireless/ath/ath10k/debug.c
> > index 32d967a..1b63929 100644
> > --- a/drivers/net/wireless/ath/ath10k/debug.c
> > +++ b/drivers/net/wireless/ath/ath10k/debug.c
> > @@ -2620,8 +2620,8 @@ void ath10k_debug_unregister(struct ath10k *ar)
> >   #endif /* CONFIG_ATH10K_DEBUGFS */
> >
> >   #ifdef CONFIG_ATH10K_DEBUG
> > -void ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
> > -		const char *fmt, ...)
> > +void __ath10k_dbg(struct ath10k *ar, enum ath10k_debug_mask mask,
> > +		  const char *fmt, ...)
> >   {
> >   	struct va_format vaf;
> >   	va_list args;
>=20
> Do you still need the check later in this method:
>=20
> if (ath10k_debug_mask & mask)
>=20
> since you already checked in the ath10k_dbg() macro?
Yes, we need this check.
Otherwise all debug messages will be printed even without any debug mask se=
t in case of tracing enabled.=20
>=20
> Thanks,
> Ben
>=20
>=20
> --
> Ben Greear <greearb@candelatech.com>
> Candela Technologies Inc  http://www.candelatech.com
>=20
>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
