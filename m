Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:33049 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbZIYIpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 04:45:49 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: 2.6.31-git wireless broken
Date: Fri, 25 Sep 2009 10:45:38 +0200
Cc: linux-wireless@vger.kernel.org
References: <Pine.LNX.4.64.0909241737390.20846@sister.anvils> <1253856038.3868.500.camel@johannes.local> <Pine.LNX.4.64.0909250838420.3783@sister.anvils>
In-Reply-To: <Pine.LNX.4.64.0909250838420.3783@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200909251045.38894.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I wonder, have there been more yet more regdom reworks since 2.6.31?
> Would this be the stage at which regdom problems manifest?  I'm not
> running whatever-it-is daemon for setting regdom, usually just patch
> static char *ieee80211_regdom = "EU";
> into my kernels; but in the past have only needed that when the router
> decides to use channel 13 or something - currently it's on channel 1.

I've install crada and it works great with 2.6.31, althought I had
to override the EEPROM, which reports bugus data:

-       ath_regd_sanitize(reg);
-
-       printk(KERN_DEBUG "ath: EEPROM regdomain: 0x%0x\n", reg->current_rd);
+       reg->current_rd = CTRY_GERMANY | COUNTRY_ERD_FLAG;

-- 
http://www.holgerschurig.de
