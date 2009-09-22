Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:62072 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754599AbZIVJY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Sep 2009 05:24:27 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: hostap@lists.shmoo.com
Subject: Re: BUG: can bring wpa_supplicant/mac80211 into a stuck state at will
Date: Tue, 22 Sep 2009 11:23:36 +0200
Cc: linux-wireless@vger.kernel.org
References: <200909211259.45431.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909211259.45431.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909221123.36953.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Another thing that might be related:


Start with freshly loaded modules (ath5k, mac80211, ath, cfg80211).

script -c "./wpa_supplicant -i eth1 -D wext -t -c mnfunk.conf -d" 1

Wait till "ping" works

script -c "./wpa_supplicant -i eth1 -D wext -t -c mnfunk.conf -d" 2


On the second try, it takes 15 seconds till
I'm connected and ping works again.

Maybe some state isn't clear at the implicit "ifdown XXX down"
that wpa_supplicant does when terminating?

-- 
http://www.holgerschurig.de
