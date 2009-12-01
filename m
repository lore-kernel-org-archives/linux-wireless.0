Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:38999 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752900AbZLAMsI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 07:48:08 -0500
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id C5D734B018
	for <linux-wireless@vger.kernel.org>; Tue,  1 Dec 2009 13:48:13 +0100 (CET)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gfsOprxU+okW for <linux-wireless@vger.kernel.org>;
	Tue,  1 Dec 2009 13:48:13 +0100 (CET)
Received: from lin01.mn-solutions.de (pD95FAAA4.dip0.t-ipconnect.de [217.95.170.164])
	by mx51.mymxserver.com (Postfix) with ESMTP id AF8F14B010
	for <linux-wireless@vger.kernel.org>; Tue,  1 Dec 2009 13:48:09 +0100 (CET)
Received: from schurig.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id D7A761E0010
	for <linux-wireless@vger.kernel.org>; Tue,  1 Dec 2009 13:48:04 +0100 (CET)
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: cfg80211: questions regarding cfg80211_ibss_joined()
Date: Tue, 1 Dec 2009 13:47:38 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200912011347.38068.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi !

I'm currently adding IBSS to libertas+cfg80211. Now I'd like
to get some clarifications:

a) when I create a new IBSS and i get a successful response to
   the CMD_802_11_AD_HOC_START firmware command, I need to tell
   this to cfg80211 somehow.

   cfg80211_ibss_joined() seems appropriate, but "iw event"
   doesn't show anything. Is this a short-coming or an indication
   of an error on my side?  Also, "iw wlan info" or "iw wlan link"
   doesn't show me anything at all.

b) the docs to cfg80211_ibss_joined() says that I need to call
   cfg80211_inform_bss() "with the locally generated beacon". I don't
   have any idea which beacon my firmware generates, so I guess I
   need to fake some beacon data. Correct?  Which IEs should I add?

c) cfg80211_inform_bss() has a field "signal". However, when I
   ask my firmware to start beacon, then I don't really have any
   signal level. If I add "0", then "iw wlan0 scan dump" shows me
   this as a signal:

   BSS 02:24:54:25:0f:24 (on wlan0)
        freq: 2412
        beacon interval: 100
        capability: IBSS (0x0002)
        signal: 0.00 dBm
        last seen: 6184 ms ago

d) And finally, for "u64 timestamp", is it okay to just submit
   a zero here?

-- 
http://www.holgerschurig.de
