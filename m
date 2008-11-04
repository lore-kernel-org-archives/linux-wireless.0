Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:53704 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584AbYKDLSg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2008 06:18:36 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: No ProbeResp - assume out of range
Date: Tue, 4 Nov 2008 12:17:50 +0100
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com> <43e72e890811021458h1444d350v33a5e5b984b76495@mail.gmail.com> <20081103002558.GA14153@tesla>
In-Reply-To: <20081103002558.GA14153@tesla>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200811041217.51096.mb@bu3sch.de> (sfid-20081104_121842_158736_92D8E9D7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Well, so it seems this is caused by the driver honoring the filter flag for
beacons. b43 and b43legacy do this, too. So they most likely have the same
misbehaviour.
In the end, I'd still call this a mac80211 bug. Why does mac80211 suppress
beacons (by clearing the flag), if it needs them?

-- 
Greetings Michael.
