Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:23272 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbZJAH5k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 03:57:40 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH]: nl80211: report age of scan results
Date: Thu, 1 Oct 2009 09:57:31 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
References: <200909241055.51604.hs4233@mail.mn-solutions.de> <200909280914.48847.hs4233@mail.mn-solutions.de> <20090930212123.GA8616@jm.kir.nu>
In-Reply-To: <20090930212123.GA8616@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910010957.31558.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> If anyone gets interested enough in trying to figure out whether
> scan results are from the time after the last scan (more exactly than 
> just guessing based on age), he/she can add that later and probably
> using something like a sequence number for scan requests, etc.

Hmm, what would a scan-sequence help in the case when mac80211 updates
a BSS because of a received beacon?

E.g.:

scan trigger, seq 5:
  find AP 'XXX', signal -50
  find AP 'YYY', signal -60
scan trigger, seq 6:
  find AP 'ZZZ', signal -55
normal operation:
  beacon for 'YYY' comes in, signal -45
scan-dump:
  get 'XXX', signal -50, seq 5
  get 'ZZZ', signal -55, seq 6
  get 'YYY', signal -45, but with which seq?

-- 
http://www.holgerschurig.de
