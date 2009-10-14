Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:35828 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756083AbZJNJhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2009 05:37:25 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id AF72D4B00F
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 11:36:17 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QvWQBGdWjv9i for <linux-wireless@vger.kernel.org>;
	Wed, 14 Oct 2009 11:36:17 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95FA374.dip0.t-ipconnect.de [217.95.163.116])
	by mx51.mymxserver.com (Postfix) with ESMTP id EFD514B00B
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 11:36:16 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 448DE1E0010
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 11:36:07 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: cfg80211 question: impedance mismatch of .connect versus .assoc
Date: Wed, 14 Oct 2009 11:36:03 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910141136.03288.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While playing with .auth/.deauth/.assoc/.disassoc 
versus .connect/.disconnect in libertas, I notices two things 
that makes things a bit hard for me.


BSS list driven vs. not
-----------------------
.auth/.assoc provides the BSSID to connect to. If cfg80211's BSS 
list is empty, it even will do a scan before 
calling .auth/.assoc.

However, for the .connect method this isn't true. .connect just 
get's the SSID.

My problem here is that the CMD_802_11_ASSOCIATE command for the 
libertas' firmware wants the AP's BSSID to connect to. For now, 
I do this:

	if (sme->bssid) {
		bss = cfg80211_get_bss(wiphy, sme->channel, sme->bssid,
			sme->ssid, sme->ssid_len,
			WLAN_CAPABILITY_ESS, WLAN_CAPABILITY_ESS);
	} else {
		ret = -ENOTSUPP;
		goto done;
	}

This makes the "iw connect" command only work if an "iw scan" did 
just take place and I provide an BSS on the command line. 

So maybe net/wireless/sme.c should be generalized ?



BSSID for .deauth/.disassoc vs. .disconnect
-------------------------------------------
Both the .deauth and .disassoc get the cfg80211_bss entry to 
deauth / disassociate against.

.disconnect doesn't get this.

But I need the BSSID for the CMD_802_11_DISASSOCIATE command, so 
I need to store the BSSID locally in priv->XXX. But I'm quite 
sure that cfg80211 already knows to which bssid I'm connected 
(see "iw xxx link"), so it's not nice that I need to store this 
twice.

-- 
http://www.holgerschurig.de
