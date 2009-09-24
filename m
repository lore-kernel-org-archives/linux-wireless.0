Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:11338 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbZIXIPn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Sep 2009 04:15:43 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Dan Williams <dcbw@redhat.com>
Subject: Re: getting "ath5k phy0: noise floor calibration timeout"
Date: Thu, 24 Sep 2009 10:15:06 +0200
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
References: <200909210902.23723.hs4233@mail.mn-solutions.de> <1253662161.2510.59.camel@localhost.localdomain>
In-Reply-To: <1253662161.2510.59.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909241015.06706.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I get that all the time, and have since 2.6.27 or earlier.  If
> it's a real bug, we should fix it, but if it's just an
> informational message, maybe we should silence it?

On ath5k-devel, there was a mail "[ath5k-devel] [RFC/RFT] ath5k: 
use noise calibration from madwifi hal" from Bob Copeland.

Part of the patch is "- we do not complain if NF calibration 
isn't complete, instead we keep the last read value.".



I now applied this patch, the message is gone and the device 
seems to work quite nicely. Maybe it should still emit a warning 
if there are n consecutive calibration errors, but for now I'm 
happy.

-- 
http://www.holgerschurig.de
