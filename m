Return-Path: <SRS0=9IVB=TJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC24C04AB1
	for <linux-wireless@archiver.kernel.org>; Thu,  9 May 2019 12:48:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 00B1F21479
	for <linux-wireless@archiver.kernel.org>; Thu,  9 May 2019 12:48:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qti.qualcomm.com header.i=@qti.qualcomm.com header.b="JPGYPryd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726449AbfEIMsW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 9 May 2019 08:48:22 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:61468 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726054AbfEIMsW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 May 2019 08:48:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qti.qualcomm.com; i=@qti.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1557406102; x=1588942102;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=SKID5TCyxAGDDUGYeYZBi3xY0FA8rMIto6YleasEpqQ=;
  b=JPGYPrydtapHjJIAh1C4pcgJHnzZm63hjY8DNOJ/jKsu6f6q1v8i+PHq
   cQVId/uyY6kFKag3MKoS2nRkhiP1WnTz9BuJpkT4EXbrZHkMCD9nAiBb3
   NOxFHYGH/U4+d1V9zqmjEgImPOW5VfoRMN225z/yDpa6ZtBeU/41T92bb
   s=;
Subject: RE: [PATCHv2] ath10k: Add wrapper function to ath10k debug
Thread-Topic: [PATCHv2] ath10k: Add wrapper function to ath10k debug
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 09 May 2019 05:48:21 -0700
X-IronPort-AV: E=McAfee;i="5900,7806,9251"; a="249705051"
Received: from nasanexm01g.na.qualcomm.com ([10.85.0.33])
  by ironmsg05-sd.qualcomm.com with ESMTP/TLS/AES256-SHA; 09 May 2019 05:48:14 -0700
Received: from APSANEXR01F.ap.qualcomm.com (10.85.0.39) by
 NASANEXM01G.na.qualcomm.com (10.85.0.33) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 9 May 2019 05:48:14 -0700
Received: from APSANEXR01F.ap.qualcomm.com (10.85.0.39) by
 APSANEXR01F.ap.qualcomm.com (10.85.0.39) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Thu, 9 May 2019 05:48:11 -0700
Received: from APSANEXR01F.ap.qualcomm.com ([10.85.0.39]) by
 APSANEXR01F.ap.qualcomm.com ([10.85.0.39]) with mapi id 15.00.1395.000; Thu,
 9 May 2019 05:48:11 -0700
From:   Venkateswara Naralasetty <vnaralas@qti.qualcomm.com>
To:     =?iso-8859-2?Q?Micha=B3_Kazior?= <kazikcz@gmail.com>,
        "Venkateswara Naralasetty" <vnaralas@codeaurora.org>
CC:     Kan Yan <kyan@chromium.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Thread-Index: AQHU/DZRZsxSuuAgfEynIothPCgWB6Zixe8A
Date:   Thu, 9 May 2019 12:48:10 +0000
Message-ID: <f9e3446266064ef09f53cc54562013e2@APSANEXR01F.ap.qualcomm.com>
References: <1556283505-29539-1-git-send-email-vnaralas@codeaurora.org>
 <CABvG-CVxmnm=JsSsgYQqEzHHYU8RJDxqCZJn4Rzy=zPLtKY1hA@mail.gmail.com>
In-Reply-To: <CABvG-CVxmnm=JsSsgYQqEzHHYU8RJDxqCZJn4Rzy=zPLtKY1hA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.80.80.8]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org



> -----Original Message-----
> From: ath10k <ath10k-bounces@lists.infradead.org> On Behalf Of Michal
> Kazior
> Sent: Friday, April 26, 2019 7:15 PM
> To: Venkateswara Naralasetty <vnaralas@codeaurora.org>
> Cc: Kan Yan <kyan@chromium.org>; linux-wireless <linux-
> wireless@vger.kernel.org>; ath10k@lists.infradead.org
> Subject: [EXT] Re: [PATCHv2] ath10k: Add wrapper function to ath10k debug
>=20
> On Fri, 26 Apr 2019 at 14:58, Venkateswara Naralasetty
> <vnaralas@codeaurora.org> wrote:
> >
> > ath10k_dbg() is called in ath10k_process_rx() with huge set of
> > arguments which is causing CPU overhead even when debug_mask is not
> set.
> > Good improvement was observed in the receive side performance when
> > call to ath10k_dbg() is avoided in the RX path.
> [...]
>=20
> > +/* Avoid calling __ath10k_dbg() if debug_mask is not set and tracing
> > + * disabled.
> > + */
> > +#define ath10k_dbg(ar, dbg_mask, fmt, ...)                     \
> > +do {                                                           \
> > +       if ((ath10k_debug_mask & dbg_mask) ||                   \
> > +           trace_ath10k_log_dbg_enabled())                     \
> > +               __ath10k_dbg(ar, dbg_mask, fmt, ##__VA_ARGS__); \ }
> > +while (0)
>=20
> Did you consider using jump labels (see include/linux/jump_label.h)?
> It's what tracing uses under the hood. I wonder if you could squeeze out =
a bit
> more performance with that? I guess you'd need to add `struct static_key
> ath10k_dbg_mask_keys[ATH10K_DBG_MAX]` and re-do
> ath10k_debug_mask enum a bit.
>=20
I could not observe any significant Throughput/CPU improvement after using =
jump labels. For now shall we go with my patch?

Thanks,
Venkatesh.
>=20
> Michal
>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
