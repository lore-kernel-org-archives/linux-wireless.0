Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:39900 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbeG3BKJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 29 Jul 2018 21:10:09 -0400
Received: by mail-oi0-f45.google.com with SMTP id d189-v6so18071852oib.6
        for <linux-wireless@vger.kernel.org>; Sun, 29 Jul 2018 16:37:54 -0700 (PDT)
MIME-Version: 1.0
From: Tom Psyborg <pozega.tomislav@gmail.com>
Date: Mon, 30 Jul 2018 01:37:53 +0200
Message-ID: <CAKR_QVJHHLGrUG4GjCA_pYJs1vbc6bOPB9+d8P4YeH67R5mJ4w@mail.gmail.com> (sfid-20180730_013815_056923_92E38631)
Subject: ath9k_htc: ANI debug with RX errors output
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: multipart/alternative; boundary="0000000000006f7c7005722bd5a1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--0000000000006f7c7005722bd5a1
Content-Type: text/plain; charset="UTF-8"

Hi

Doing some throughput tests I've noticed there are many CCK errors which
mainly occur while receiving data. OFDM errors counted are far less in
numbers than CCK ones, also appearing more often while receiving data. When
transmitting data, the amount of these errors is almost insignificant.

debug output:

ANI: ENABLED
ANI RESET: 82
OFDM LEVEL: 0
CCK LEVEL: 0
SPUR UP: 0
SPUR DOWN: 0
OFDM WS-DET ON: 0
OFDM WS-DET OFF: 0
MRC-CCK ON: 0
MRC-CCK OFF: 0
FIR-STEP UP: 485
FIR-STEP DOWN: 487
INV LISTENTIME: 0
OFDM ERRORS: 83944
CCK ERRORS: 1119852

While receiving data at 16Mbps CCK LEVEL was 0, receiving data at
24Mbps CCK LEVEL was 8! Transmitting data at 24Mbps CCK LEVEL was 0, but
receiving at 16Mbps and transmitting at 8Mbps CCK LEVEL was again 8! Does
that mean the remote AP is creating a lot of CCK noise for some reason? It
does run in g-only mode and OFDM levels stayed at 0 during whole time of
data transfers.

How efficient it would be to patch htc driver so it runs in OFDM mode only?

--0000000000006f7c7005722bd5a1
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi<br></div><div><br></div><div>Doing some throughput=
 tests I&#39;ve noticed there are many CCK errors which mainly occur while =
receiving data. OFDM errors counted are far less in numbers than CCK ones, =
also appearing more often while receiving data. When transmitting data, the=
 amount of these errors is almost insignificant.</div><div><br></div><div>d=
ebug output:</div><div><br></div><div>            ANI: ENABLED<br>      ANI=
 RESET: 82<br>     OFDM LEVEL: 0<br>      CCK LEVEL: 0<br>        SPUR UP: =
0<br>      SPUR DOWN: 0<br> OFDM WS-DET ON: 0<br>OFDM WS-DET OFF: 0<br>    =
 MRC-CCK ON: 0<br>    MRC-CCK OFF: 0<br>    FIR-STEP UP: 485<br>  FIR-STEP =
DOWN: 487<br> INV LISTENTIME: 0<br>    OFDM ERRORS: 83944<br>     CCK ERROR=
S: 1119852<br></div><div><span class=3D"sewxkd0lznc22m1"><br></span></div><=
div><span class=3D"sewxkd0lznc22m1">While receiving data at 16Mbps=C2=A0</s=
pan>CCK LEVEL was 0, receiving data at 24Mbps=C2=A0CCK LEVEL was 8! Transmi=
tting data at 24Mbps=C2=A0CCK LEVEL was 0, but receiving at 16Mbps and tran=
smitting at 8Mbps=C2=A0CCK LEVEL was again 8! Does that mean the remote AP =
is creating a lot of CCK noise for some reason? It does run in g-only mode =
and OFDM levels stayed at 0 during whole time of data transfers<span class=
=3D"sewxkd0lznc22m1">.<br></span></div><div><span class=3D"sewxkd0lznc22m1"=
><br></span></div><div><span class=3D"sewxkd0lznc22m1">How efficient it wou=
ld be to patch htc driver so it runs in OFDM mode only?<br></span></div></d=
iv>

--0000000000006f7c7005722bd5a1--
