Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:34922 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbZLAHBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 02:01:43 -0500
Received: by ewy19 with SMTP id 19so4605380ewy.21
        for <linux-wireless@vger.kernel.org>; Mon, 30 Nov 2009 23:01:48 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] cfg80211: add SM PS hooks
References: <20091130153857.963079149@sipsolutions.net>
	<20091130154300.492667106@sipsolutions.net>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 01 Dec 2009 09:01:46 +0200
In-Reply-To: <20091130154300.492667106@sipsolutions.net> (Johannes Berg's message of "Mon\, 30 Nov 2009 16\:38\:58 +0100")
Message-ID: <87pr6z6uud.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> Add spatial multiplexing power save configuration
> hooks to cfg80211/nl80211.

Is it really necessary to export this to user space, at least via
nl80211? If we add this to nl80211, we have to support this almost
forever.

Also how are planning to use this? What components will use the
interface and how?

My concern here is that we will end up having, yet again, complicated
user space interface for power save. The ideal situation would be that
kernel would configure all this automatically and we would have a
simple interface just to disable power save in cases where it doesn't
work (broken APs etc).

-- 
Kalle Valo
