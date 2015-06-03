Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42935 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752652AbbFCHCy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 03:02:54 -0400
Message-ID: <1433314971.2274.1.camel@sipsolutions.net> (sfid-20150603_090257_231962_76735686)
Subject: Re: [RFC] mac80211: convert HW flags to unsigned long bitmap
From: Johannes Berg <johannes@sipsolutions.net>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	gregory.greenman@intel.com
Date: Wed, 03 Jun 2015 09:02:51 +0200
In-Reply-To: <CAGRGNgV_4axC8Cq5AYkd7RQdJOnrT_9L85qisrrZnKYHyUEczQ@mail.gmail.com> (sfid-20150603_025745_650833_28A1FD99)
References: <1433273994-14430-1-git-send-email-johannes@sipsolutions.net>
	 <CAGRGNgV_4axC8Cq5AYkd7RQdJOnrT_9L85qisrrZnKYHyUEczQ@mail.gmail.com>
	 (sfid-20150603_025745_650833_28A1FD99)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-06-03 at 10:57 +1000, Julian Calaby wrote:

> Why not add a ieee80211_hw_clear() function? Yes, it'd only be used in
> 3 places, but it'd look neater.

Well, this was actually intentional.

Drivers are not *supposed* to be doing this, the hardware flags are
supposed to be constant hardware description flags. The three drivers
clearing this specific but currently work OK due to the way this
particular flag is treated, but that wouldn't necessarily the case for
all of the flags; adding a _clear() function would seem to imply that
it's OK to do this, when it's really not.

johannes

