Return-Path: <SRS0=h0Fo=ML=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=FROM_EXCESS_BASE64,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11E29C43143
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 00:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 85C4A2073F
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 00:20:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 85C4A2073F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=friiks.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726989AbeI2GqW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 02:46:22 -0400
Received: from james.theweblords.de ([217.11.55.87]:57088 "EHLO
        james.theweblords.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726804AbeI2GqV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 02:46:21 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Sat, 29 Sep 2018 02:46:21 EDT
Received: (qmail 24862 invoked by uid 210); 29 Sep 2018 00:13:28 -0000
X-Qmail-Scanner-Diagnostics: from wl-r3-2.rz.tu-ilmenau.de (petronios@theweblords.de@wl-r3-2.rz.tu-ilmenau.de) by james (envelope-from <pegro@friiks.de>, uid 201) with qmail-scanner-2.10st 
 (mhr: 1.0. spamassassin: 3.4.1. perlscan: 2.10st.  
 Clear:RC:1(141.24.16.2):. 
 Processed in 0.087777 secs); 29 Sep 2018 00:13:28 -0000
Received: from wl-r3-2.rz.tu-ilmenau.de (HELO localhost) (petronios@theweblords.de@141.24.16.2)
  by james.theweblords.de with ESMTPA; 29 Sep 2018 00:13:28 -0000
Date:   Sat, 29 Sep 2018 02:13:21 +0200
From:   Peter =?UTF-8?B?R3Jvw59l?= <pegro@friiks.de>
To:     linux-wireless@vger.kernel.org
Subject: Handling user regdom hints while having intersected world regdom
Message-ID: <20180929021321.1e1b6c3e@fem-net.de>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/SoubWZjzh_mzOPe3uPzkooF"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

--Sig_/SoubWZjzh_mzOPe3uPzkooF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi.

When a setup has multiple wifi cards anounncing different regdoms, the
regularitory subsystem stores an intersected world regdom using aplha2 "98".

I wonder what the correct result should be, when I call "iw reg set 00" or =
with
any other country code?

Because in my system with multiple cards nothing happened.

I added a lot of debug messages and I found the request is rejected with
REG_REQ_IGNORE in __reg_process_hint_user (in net/wireless/reg.c:2371).

In this check, last_request is considered (the request before my user reque=
st),
which in my case was the driver request for the second card leading to the
intersected regdom. But since "98" doesn't match the regdom provided by the
driver, the check returns true and the request gets rejected.

The comment above the check mentions not yet processed requests, but I doubt
that checking the current regdom against the last_request regdom helps in my
case. But from reading the code I got there is a "processed" flag for each
requst.

So maybe a patch like below is enough? Or are there more things to consider?
Or maybe I'm wrong and the current behavior is intended?!

Regards
Peter

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4fc66a117b7d..ed4543c7b255 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -2428,15 +2428,15 @@ __reg_process_hint_user(struct regulatory_request
*user_request) /*
         * Process user requests only after previous user/driver/core
         * requests have been processed
         */
        if ((lr->initiator =3D=3D NL80211_REGDOM_SET_BY_CORE ||
             lr->initiator =3D=3D NL80211_REGDOM_SET_BY_DRIVER ||
             lr->initiator =3D=3D NL80211_REGDOM_SET_BY_USER) &&
-           regdom_changes(lr->alpha2))
+           !lr->processed)
                return REG_REQ_IGNORE;
=20
        if (!regdom_changes(user_request->alpha2))
                return REG_REQ_ALREADY_SET;
=20
        return REG_REQ_OK;
 }

--Sig_/SoubWZjzh_mzOPe3uPzkooF
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEFBMm5T0HjV/btb+Q2Ws8k4f65hoFAluuw6EACgkQ2Ws8k4f6
5hrPfgf/RczY9mUs3AhyvHGNzrXy4o46QpTbkc+OCcIMesQ1V7bgGfGbVmzcIb+/
JAFY4XNY9MEvj3BRLYMGlNvZcoCYcVCm6uwIwHIfk4s+6Zl0NuAiwOFrXzG9TlDD
dbPpiEcVEjiq88HJp90oEtPWLHs5ofuhcFTWXNMc9BkAC7RGncrTr0lvelJZDhCn
mBDMAtM9yOJ0R7MGNJMIItN8UMjW3oSiZpcdku18es42/qkCs+tLBOpFs8a49Gwz
JYYMBKc7m/goJuZEJelQUwanZ2XZEtLzYLZBLMT24NRPhrTbvVyJLqzdiKHna367
UMpKZ+QOmwMeG42gpzOjm291zOctTw==
=8Anj
-----END PGP SIGNATURE-----

--Sig_/SoubWZjzh_mzOPe3uPzkooF--
