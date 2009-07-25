Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f228.google.com ([209.85.218.228]:46078 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbZGYJSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 05:18:08 -0400
Received: by bwz28 with SMTP id 28so1797870bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 02:18:06 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: wireless-testing regression: iwl3945 scan fails
References: <87k521s2wa.fsf@litku.valot.fi> <87fxcosron.fsf@litku.valot.fi>
	<1248278121.17896.2728.camel@rc-desk> <874ot2sa51.fsf@litku.valot.fi>
	<87skglqpb0.fsf@litku.valot.fi>
	<1248510692.32151.46.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 25 Jul 2009 12:18:02 +0300
In-Reply-To: <1248510692.32151.46.camel@johannes.local> (Johannes Berg's message of "Sat\, 25 Jul 2009 10\:31\:32 +0200")
Message-ID: <87ocr9qfxx.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> This is getting very odd, I cannot reproduce the problem anymore with
>> rc4-wl. Just to be safe, I rebooted back to rc3-wl and I was immediately
>> able to reproduce it. To summarise, rc2-wl and rc4-wl were ok and only
>> rc3-wl is broken. So something fixed this, I just don't know what.
>
> That makes sense though, I posted a fix for at least a similar problem
> that only happened right after bootup ;)

The patch in question:

  commit 8b0fd0af6b36b2123af7da4eabe228d1fc101e38
  Author: Johannes Berg <johannes@sipsolutions.net>
  Date:   Thu Jul 23 16:50:16 2009 +0200

    mac80211: fix mlme timeouts

I tried reverting the patch in rc4-wl and I again was able to reproduce
the problem. This confirms that the patch fixed it. Thanks.

Tested-by: Kalle Valo <kalle.valo@iki.fi>

-- 
Kalle Valo
