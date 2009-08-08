Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:55244 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165AbZHHUKy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 16:10:54 -0400
Received: by bwz19 with SMTP id 19so1990306bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 13:10:54 -0700 (PDT)
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: reinette chatre <reinette.chatre@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH v4] cfg80211: validate channel settings across interfaces
References: <1249649261.4215.7.camel@johannes.local>
	<1249649433.7194.0.camel@johannes.local>
	<1249652951.7194.2.camel@johannes.local>
	<1249658555.7194.8.camel@johannes.local>
	<1249712383.30019.5561.camel@rc-desk> <4A7DD307.6090209@lwfinger.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Sat, 08 Aug 2009 23:10:51 +0300
In-Reply-To: <4A7DD307.6090209@lwfinger.net> (Larry Finger's message of "Sat\, 08 Aug 2009 14\:33\:27 -0500")
Message-ID: <87r5vmkqwk.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger <Larry.Finger@lwfinger.net> writes:

>> For example, when I run:
>> $ iwconfig wlan0 channel <ch> essid <essid>
>> 
>> then the command prompt never returns and system becomes progressively
>> unresponsive. The logs do not contain any details of the problem.
>
> I have the same problem here as well.

This patch fixes the issue:

commit 21e433f9ea04c319cc12b4094f292a8f1ad709e9
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Sat Aug 8 11:03:58 2009 +0200

    cfg80211: fix locking for SIWFREQ

Johannes sent it to the list this today and it's not in wireless-testing
yet.

-- 
Kalle Valo
