Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:14773 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755178AbZJZIsU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 04:48:20 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 60C3C3A012
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 09:48:24 +0100 (CET)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hcruvS-wtmSP for <linux-wireless@vger.kernel.org>;
	Mon, 26 Oct 2009 09:48:24 +0100 (CET)
Received: from lin01.mn-solutions.de (pD95FA967.dip0.t-ipconnect.de [217.95.169.103])
	by mx51.mymxserver.com (Postfix) with ESMTP id D64A53A007
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 09:48:23 +0100 (CET)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id 656011E0036
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2009 09:48:11 +0100 (CET)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Questions about cfg80211's cfg80211_connect_params->crypto settings
Date: Mon, 26 Oct 2009 09:47:48 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910260947.48365.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm a but confused about what fields in "struct 
cfg80211_connect_params" (now abbreviated as sme->)
are relevant for me.


sme->private
------------
Right now, my lbs_cfg_connect() code just tests 
sme->crypto.cipher_group. It doesn't check or use sme->privacy.

 and sme-> crypto.wpa_versions like they are redundant. Is this 
correct?

Empirical it migth be correct, because I can successfully connect 
to APs, but if "privacy" is redundant, should I prepare a patch 
to get rid of it?

What is this?  And how should my driver react to it's settings?



sme->crypto.wpa_versions
------------------------
Again I seems to be ok to ignore this variable and just check 
sme->crypto.cipher_group. In practice this seems to work, but is 
it correct?

What is this, what is the intented use of it?  May I prepare a 
patch to get rid of it?



sme->crypto.n_ciphers_pairwise, sme->crypto.ciphers_pairwise
------------------------------------------------------------
The same for sme->crypto.n_ciphers_pairwise. It is always 0 zero 
for the WEP case and always 1 for the WPA/WPA2 case, so isn't it 
redundant either?  lbs_cfg_connect() ignores this, maybe it's 
not needed at .connect() time anyway?

But what is it really, what is the intended use?



sme->crypto.n_akm_suites, sme->crypto.akm_suites
------------------------------------------------
In cfg80211.h, the kdoc help text for sme->crypo.akm_suites is 
just "AKM suites" or "number of AKM suites", which keeps me as 
confused as before.

What is this?  And how should my driver react to it's settings?


-- 
http://www.holgerschurig.de
