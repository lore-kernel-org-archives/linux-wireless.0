Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:56600 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751010Ab1BITGw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 14:06:52 -0500
To: Vivek Natarajan <vivek.natraj@gmail.com>
Cc: Sujith <m.sujith@gmail.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] ath9k: Drain txq before sending a nullfunc frame.
References: <1296800640-6381-1-git-send-email-vnatarajan@atheros.com>
	<19787.47298.50879.401166@gargle.gargle.HOWL>
	<AANLkTim_7Xup048eGxz2HWj0AqRS_+jvC1LqgCdU9ZOh@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 09 Feb 2011 21:06:50 +0200
In-Reply-To: <AANLkTim_7Xup048eGxz2HWj0AqRS_+jvC1LqgCdU9ZOh@mail.gmail.com> (Vivek Natarajan's message of "Fri\, 4 Feb 2011 14\:47\:27 +0530")
Message-ID: <87lj1p6n91.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan <vivek.natraj@gmail.com> writes:

> We were considering yet another approach too:
> In this case, if a nullfunc frame for PS comes to the driver when
> there are pending frames in the hw queue(the frames queued before
> 100ms and still pending because of highly noisy environment), silently
> drop the frame so that mac80211 will try once again after 100ms to go
> to PS. The issue that I face here is, ath9k does not know whether this
> frame is actually for PS or for fake sleep before scanning.

There's also a third option. Keep sending the data frames after the
nullfunc frame but make sure that pm bit is set. But that would need
hardware support and someway to notify the driver about the pm state.

-- 
Kalle Valo
