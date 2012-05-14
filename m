Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40104 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab2ENH5L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 03:57:11 -0400
Received: by obbtb18 with SMTP id tb18so7086336obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 00:57:10 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 14 May 2012 09:57:10 +0200
Message-ID: <CAOpc7mEZGZMCCBnnLo-v6ooz4qgKXOeF7kJeb3yzeeV8L-g5bA@mail.gmail.com> (sfid-20120514_095731_639680_F973C52A)
Subject: ath9k: write-only variable rx.rxotherant ?!?!?
From: Holger Schurig <holgerschurig@googlemail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I looks like sc->rx.rxotherant is an almost write-only variable: "grep
-r rxotherant *":

./ath9k/recv.c:	sc->rx.rxotherant = 0;
./ath9k/recv.c:				if (++sc->rx.rxotherant >= 3)
./ath9k/recv.c:				sc->rx.rxotherant = 0;
./ath9k/ath9k.h:	u8 rxotherant;


-- 
http://www.holgerschurig.de
