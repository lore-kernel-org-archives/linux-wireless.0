Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62170 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465Ab3FAVbe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Jun 2013 17:31:34 -0400
Received: by mail-ie0-f182.google.com with SMTP id 9so1691153iec.41
        for <linux-wireless@vger.kernel.org>; Sat, 01 Jun 2013 14:31:34 -0700 (PDT)
Date: Sat, 1 Jun 2013 17:30:37 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open11s <devel@lists.open80211s.org>
Subject: Re: [PATCH] cfg80211: fix deadlock in cfg80211_leave_mesh()
Message-ID: <20130601213037.GE1030@localhost> (sfid-20130601_233137_857581_74EB2DCE)
References: <20130601131916.GA2484@localhost>
 <CAG6hwVNZ4oDGsZTLO0gqQ2eWV-C7rxQZ2F=PiR9-URc44FxgKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAG6hwVNZ4oDGsZTLO0gqQ2eWV-C7rxQZ2F=PiR9-URc44FxgKw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 01, 2013 at 01:53:35PM -0700, Thomas Pedersen wrote:
> wdev->mtx is already held). But it does look weird for cfg80211 to
> drop a lock on behalf of the driver.

This did cross my mind, but I thought maybe it made sense to do
it there to make it easier to reason about the code -- if dropped
in mac80211, someone reading the code would have no idea.

-- 
Bob Copeland %% www.bobcopeland.com
