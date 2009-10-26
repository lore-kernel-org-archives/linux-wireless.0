Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:48420 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818AbZJZMMS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 08:12:18 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: Questions about cfg80211's cfg80211_connect_params->crypto settings
Date: Mon, 26 Oct 2009 13:11:47 +0100
Cc: linux-wireless@vger.kernel.org
References: <200910260947.48365.hs4233@mail.mn-solutions.de> <1256548953.28230.19.camel@johannes.local>
In-Reply-To: <1256548953.28230.19.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200910261311.47164.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > sme->crypto.wpa_versions
> 
> > sme->crypto.n_ciphers_pairwise, sme->crypto.ciphers_pairwise
> 
> > sme->crypto.n_akm_suites, sme->crypto.akm_suites
> 
> All these pretty much exist for hw that doesn't want to use the
> IE(s) contained in the connect parameters. If you send an assoc
> request with those IEs, you can safely ignore the parameters
> here. It's just there so one doesn't have to parse the IEs.

Okay, then I conclude that it's save to ignore

  sme->privacy
  sme->crypto.wpa_versions
  sme->crypto.n_ciphers_pairwise
  sme->crypto.ciphers_pairwise
  sme->crypto.n_akm_suites
  sme->crypto.akm_suites

inside .connect() if I check sme->crypto.cipher_suite for

  WLAN_CIPHER_SUITE_WEP40
  WLAN_CIPHER_SUITE_WEP104
  WLAN_CIPHER_SUITE_TKIP
  WLAN_CIPHER_SUITE_CCMP
  0  (meaning no encryption/WEP obfuscation)




lbs_cfg_connect() calls lbs_associate() which hands the complete 
sme->ie to as a TLV to the firmware. However, I don't do any 
parsing of sme->ie by myself.

-- 
http://www.holgerschurig.de
