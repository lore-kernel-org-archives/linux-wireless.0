Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:17008 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811AbZIRONc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Sep 2009 10:13:32 -0400
Received: from localhost (localhost [127.0.0.1])
	by localhost.mx51.mymxserver.com (Postfix) with ESMTP id 5783C4B004
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 16:13:35 +0200 (CEST)
Received: from mx51.mymxserver.com ([127.0.0.1])
	by localhost (mx51.mymxserver.com [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id J7WxOAwEHEKz for <linux-wireless@vger.kernel.org>;
	Fri, 18 Sep 2009 16:13:35 +0200 (CEST)
Received: from lin01.mn-solutions.de (pD95F87DB.dip0.t-ipconnect.de [217.95.135.219])
	by mx51.mymxserver.com (Postfix) with ESMTP id 00C994B00C
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 16:13:34 +0200 (CEST)
Received: from mnz66.mn-solutions.de (mnz66.mn-solutions.de [192.168.233.66])
	by lin01.mn-solutions.de (Postfix) with ESMTP id E3A091E0036
	for <linux-wireless@vger.kernel.org>; Fri, 18 Sep 2009 16:13:24 +0200 (CEST)
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Life-time of scan-results?
Date: Fri, 18 Sep 2009 16:12:49 +0200
References: <200909181418.30958.hs4233@mail.mn-solutions.de> <200909181507.59420.hs4233@mail.mn-solutions.de>
In-Reply-To: <200909181507.59420.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909181612.49412.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently, before returning scan results, cfg80211_bss_expire() 
get's called. It deletes BSSs that are older than 
IEEE80211_SCAN_RESULT_EXPIRE.



I propose to change cfg80211_bss_expire() so that it doesn't 
hard-code NL80211_CMD_TRIGGER_SCAN anymore, but has a new 
parameter, say "int expire".



Then NL80211_CMD_TRIGGER_SCAN get's a new optional attribute, say 
NL80211_ATTR_SCAN_EXPIRE.

If that attribut exists when calling NL80211_CMD_TRIGGER_SCAN, 
it's value will be used to call cfg80211_bss_expire(). If the 
value is zero, cfg80211_bss_expire() triggers the whole 
rdev->bss_list. That means we do a completely fresh scan.

If it doesn't exists, cfg80211_bss_expire() won't be called at 
scan-trigger time.




NL80211_CMD_GET_SCAN could get this attribute as well. If 
not specified, then the default of NL80211_CMD_TRIGGER_SCAN will 
be used. That is, just right now, the rdev->bss_list will expire 
like now.

However, if a value will be specified, then the bss_list will be 
expired with the specified expiry time.

Specifying zero doesn't make sense here, because that would zap 
the freshly made bss list. So a zero could mean "Don't expire 
anything".


That way user-space could ask for what has scanned the last time, 
even when this has been one hour ago --- with no scans in the 
meantime.


Does this make sense?

-- 
http://www.holgerschurig.de
