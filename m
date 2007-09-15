Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:53072
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbXIOWA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Sep 2007 18:00:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Larry Finger <larry.finger@lwfinger.net>
Subject: Re: [PATCH] b43legacy: Fix machine check errors for PPC architecture with BCM4306/2
Date: Sat, 15 Sep 2007 23:58:08 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
References: <46ec18d6.puwbD1oRuPgUil6/%Larry.Finger@lwfinger.net> <200709152147.57431.mb@bu3sch.de> <46EC4844.1060003@lwfinger.net>
In-Reply-To: <46EC4844.1060003@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709152358.08887.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 15 September 2007 23:01:56 Larry Finger wrote:
> I have generated and tested a patch that changes back to the old 'connected' variable. That will
> avoid the semantics argument and match the V3 specs.

There is no such thing as "connected".
The bit is called "gmode". Why do you change it back to the wrong name?
The V3 specs are simply _wrong_. It has nothing to do with the backplane
or anything else like that. The bit just selects between the A-PHY and
the BG-PHY. Of course, if there is no A-PHY it will obviously machine-check
on access, if it's selected.

V3 specs assume that the meaning is "connected", because it was misinterpreted
to be a "PHY connect" flag. But it really is a "PHY select" flag, to select
between two different PHYs. If it's enabled, the G-PHY will be selected (and
the A-PHY otherwise).

Btw, while we are at it: The V3 specs are wrong regarding the gmode (or connected)
bit in other areas as well, because there was even more confusion with
other PHY flags. The PHY specification is pretty broken in the v3 specs.

-- 
Greetings Michael.
