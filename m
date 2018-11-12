Return-Path: <SRS0=J0pC=NX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40E6EC43610
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 09:21:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05E48223AE
	for <linux-wireless@archiver.kernel.org>; Mon, 12 Nov 2018 09:21:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="W+NH7gWR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 05E48223AE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=qti.qualcomm.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729173AbeKLTN1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 12 Nov 2018 14:13:27 -0500
Received: from alexa-out-sd-02.qualcomm.com ([199.106.114.39]:2015 "EHLO
        alexa-out-sd-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726161AbeKLTN1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Nov 2018 14:13:27 -0500
X-Greylist: delayed 368 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Nov 2018 14:13:26 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1542014468; x=1573550468;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=YvhP1UTZyJCpMmB3Q9o2nQGKmbiRi573Q38zLb2Z60w=;
  b=W+NH7gWRE2yNgaO6GNbKzvR6EmJ/yVOOx8HafdU7afE/0xGdjRDfk26A
   0BLX0I6Lc2GPomce6C5xzFYCN4JuRKddIlfqbcPQPU73Jvetqi0DistPS
   norat6buMK7F04HARovYR32Vu/UoSWYSeuhc4xDNnF0IZmYurHsOiVW1y
   8=;
X-IronPort-AV: E=Sophos;i="5.54,494,1534834800"; 
   d="scan'208";a="16660858"
Subject: RE:  [PATCH] ath10k: Add wrapper function to ath10k debug
Thread-Topic: [PATCH] ath10k: Add wrapper function to ath10k debug
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 12 Nov 2018 01:15:00 -0800
Received: from nasanexm03g.na.qualcomm.com ([10.85.0.49])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/AES256-SHA; 12 Nov 2018 01:15:00 -0800
Received: from APSANEXR01A.ap.qualcomm.com (10.85.0.36) by
 nasanexm03g.na.qualcomm.com (10.85.0.49) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 12 Nov 2018 01:14:59 -0800
Received: from APSANEXR01F.ap.qualcomm.com (10.85.0.39) by
 APSANEXR01A.ap.qualcomm.com (10.85.0.36) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 12 Nov 2018 01:14:56 -0800
Received: from APSANEXR01F.ap.qualcomm.com ([10.85.0.39]) by
 APSANEXR01F.ap.qualcomm.com ([10.85.0.39]) with mapi id 15.00.1395.000; Mon,
 12 Nov 2018 01:14:56 -0800
From:   Venkateswara Naralasetty <vnaralas@qti.qualcomm.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Venkateswara Naralasetty <vnaralas@codeaurora.org>
CC:     Kan Yan <kyan@chromium.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Thread-Index: AQHUYkBJYmKYZURaUEqIlDws+T89ZKVMC3Bg
Date:   Mon, 12 Nov 2018 09:14:55 +0000
Message-ID: <e1fdda63de9c4ddf96c5c14958079b3d@APSANEXR01F.ap.qualcomm.com>
References: <1537766878-11238-1-git-send-email-vnaralas@codeaurora.org>
 <87va672nib.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87va672nib.fsf@kamboji.qca.qualcomm.com>
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
> From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Kalle Valo
> Sent: Friday, October 12, 2018 8:58 PM
> To: Venkateswara Naralasetty <vnaralas@codeaurora.org>
> Cc: Kan Yan <kyan@chromium.org>; linux-wireless@vger.kernel.org;
> ath10k@lists.infradead.org
> Subject: [EXTERNAL] Re: [PATCH] ath10k: Add wrapper function to ath10k
> debug
>=20
> Venkateswara Naralasetty <vnaralas@codeaurora.org> writes:
>=20
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
> >                       w/o this patch          with this patch
> >         Traffic       TP      CPU Usage      TP      CPU usage
> >
> >         TCP          840Mbps    76.53%      960Mbps    78.14%
> >         UDP          1030Mbps   74.58%      1132Mbps   74.31%
> >
> > Infra mode:
> >
> >                       w/o this patch          with this patch
> >         Traffic        TP      CPU Usage      TP      CPU usage
> >
> >         TCP Rx       1241Mbps   80.89%      1270Mbps   73.50%
> >         UDP Rx       1433Mbps   81.77%      1472Mbps   72.80%
> >
> > Tested platform	: IPQ8064
> > hardware used	: QCA9984
> > firmware ver	: ver 10.4-3.5.3-00057
> >
> > Signed-off-by: Kan Yan <kyan@chromium.org>
> > Signed-off-by: Venkateswara Naralasetty <vnaralas@codeaurora.org>
>=20
> The first Signed-off-by should be the author's, in this case Venkateswara=
. If
> Kan helped to develop the patch you should also add
> Co-developed-by:
>=20
> https://www.kernel.org/doc/html/latest/process/submitting-
> patches.html#when-to-use-acked-by-cc-and-co-developed-by
>=20
> > +/* Avoid calling __ath10k_dbg() if debug_mask is not set and tracing
> > + * disabled.
> > + */
> > +#define ath10k_dbg(ar, dbg_mask, fmt, ...)				\
> > +do {									\
> > +	if (IS_ENABLED(CONFIG_ATH10K_TRACING) ||			\
> > +	    (ath10k_debug_mask & dbg_mask))				\
> > +		__ath10k_dbg(ar, dbg_mask, fmt, ##__VA_ARGS__);
> 	\
> > +} while (0)
> >  #endif /* _DEBUG_H_ */
>=20
> Johannes had an interesting idea to use trace_ath10k_log_dbg_enabled().
> Could you investigate if that would work? That way we might get the
> performance improvement even when is enabled
> CONFIG_ATH10K_TRACING (but actual trace point is disabled, of course).
>=20
Sure I will check on this and send next version.

> Documentation/trace/tracepoints.rst has more info about the
> trace_*_enabled() function. It does have a special requirement but I'm no=
t
> sure if it matters here as we don't care if we loose a message or two in =
the
> beginning:
>=20
>     "The trace_<tracepoint>() should always be within the block of the
>      if (trace_<tracepoint>_enabled()) to prevent races between the
>      tracepoint being enabled and the check being seen."
>=20
> --
> Kalle Valo
>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
