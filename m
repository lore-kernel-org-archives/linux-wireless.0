Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f224.google.com ([209.85.220.224]:54927 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752802AbZFVQXl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2009 12:23:41 -0400
Received: by fxm24 with SMTP id 24so829985fxm.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jun 2009 09:23:42 -0700 (PDT)
Message-ID: <4A3FB00F.1020104@gmail.com>
Date: Mon, 22 Jun 2009 18:23:43 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: jmalinen@atheros.com, Sujith.Manoharan@atheros.com,
	vasanth@atheros.com, senthilkumar@atheros.com,
	ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
Subject: ath9k: ath9k_ps_restore used after ath9k_hw_detach
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

In ath_detach, there is:
ath9k_hw_detach(sc->sc_ah);
ath9k_exit_debug(sc);
ath9k_ps_restore(sc);
which is obviously wrong. sc->ah is dereferenced in restore, but it's
already freed since detach.

I don't quite understand why you try to set power while it's being
already set to full sleep in ath9k_hw_detach. So I think the fix is to
remove the restore call, but dunno. So please fix it anyhow :).
