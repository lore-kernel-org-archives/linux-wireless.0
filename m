Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:60889 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbZGYSeR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Jul 2009 14:34:17 -0400
Received: by fxm18 with SMTP id 18so1948650fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2009 11:34:16 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Pavel Roskin <proski@gnu.org>
Subject: Re: [PATCH] mac80211: fix oops in ieee80211_scan_state_set_channel()
Date: Sat, 25 Jul 2009 20:34:20 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <20090725051801.2965.76768.stgit@ct.roinet.com> <1248541636.2554.12.camel@ct> <200907252015.07010.helmut.schaa@googlemail.com>
In-Reply-To: <200907252015.07010.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907252034.21003.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Samstag, 25. Juli 2009 schrieb Helmut Schaa:
> Am Samstag, 25. Juli 2009 schrieb Pavel Roskin:
> > Lack of SCAN_DONE in mac80211_scan_state.  We exit scanning through the
> > "entry point".
> 
> I also thought of a separate state SCAN_DONE or something similar but
> dropped that idea as the only thing this state would have to do is the
> call to ieee80211_scan_completed. So, once the scan is finished we
> just stay in SCAN_DECISION as long as the scan state machine gets poked
> again by a start_scan call.

Maybe we should add a state SCAN_IDLE which is entered after the scan
finished just for consistency?

Helmut
