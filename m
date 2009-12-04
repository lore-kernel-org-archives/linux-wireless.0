Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:42453 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756338AbZLDOCO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 09:02:14 -0500
Received: by bwz27 with SMTP id 27so1962162bwz.21
        for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2009 06:02:19 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: patrik.flykt@nokia.com
Subject: WMM classification guideline for applications?
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 04 Dec 2009 16:02:14 +0200
Message-ID: <87d42u6dnd.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

me and Patrik have been pondering what's the proper way for user space
applications to do packet classification to get the benefits from WMM.
VoIP application is a good example here.

For the time being we have identified three different methods:

1. SO_PRIORITY with values 0-7 (we used this in nokia n810)
2. SO_PRIORITY with values 256-263 (used by mac80211)
3. IPv4 DSCP field with values 0-7 (used by mac80211)

Method 1 is easy, applications need to just use setsockopt() and be
done with it. I don't know how widely supported values 0-7 are, but at
least they make sense. The problem is that priority is used only in
the first link, rest of the route is not able to benefit from the
classification.

Method 2 (priorities 256-263) doesn't sound very portable. I doubt if
any other stack or driver (even non-wifi ones) use these values.
Otherwise this is similar with Method 1.

Method 3 (IPv4 DSCP field) feels most portable to us, at least most,
if not all, wifi drivers should use it. And, in theory, the receiver
should also benefit from the classification, unless ISPs modify it of
course. But the standardisation for IPv4 QoS bits is a mess and I
don't really understand where the use of DSCP bits (as used in WMM
implementations) is specified. Also I was told that root privileges
are needed to set this and that's somewhat cumbersome from application
developer's point of view.

So what's the proper long term solution for this? All ideas are more
than welcome.

-- 
Kalle Valo
