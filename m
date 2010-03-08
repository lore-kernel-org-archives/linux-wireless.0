Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:43452 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753071Ab0CHJ1H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 04:27:07 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1NoZEo-0003F4-33
	for linux-wireless@vger.kernel.org; Mon, 08 Mar 2010 10:27:00 +0100
Received: from 56-9.dial.nortenet.pt ([212.13.56.9])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 10:26:58 +0100
Received: from subscriptions by 56-9.dial.nortenet.pt with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 10:26:58 +0100
To: linux-wireless@vger.kernel.org
From: doddel <subscriptions@stroomer.com>
Subject: Re: ath9k: ar9220 does rx but no tx on antenna B
Date: Mon, 8 Mar 2010 09:26:41 +0000 (UTC)
Message-ID: <loom.20100308T101424-116@post.gmane.org>
References: <loom.20100308T002346-575@post.gmane.org> <69e28c911003071558v75cfe8aeq77644796a990434a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The R52n miniPCI is documented to have
"Support for up to 2x2 MIMO with spatial multiplexing".
Indeed the board layout contains two identical RF stages with filters and tx
amplifiers / rx pre-amplifiers (SiGE SE9523) and antenna connectors. 
Having scanned through all present ath9k code for things related to antenna
choice i saw in several places (beacon.c, rcvc.c) some code that determines an
antenna. But the resulting values do not get applied. Aso the tx descriptor
structures do not contain antenna information, unlike in ath5k and madwifi.
Hope that somebody can shed some light on what these chipsets that ath9k is
meant for can or cannot do in terms of antenna choice.
And how to control it and switch between full 2x2 mimo 80211n and bgn style with
single or sectored antennas.

