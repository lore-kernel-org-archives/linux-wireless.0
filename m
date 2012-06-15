Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:44253 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750954Ab2FOEkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jun 2012 00:40:35 -0400
Received: by laai10 with SMTP id i10so3036184laa.27
        for <linux-wireless@vger.kernel.org>; Thu, 14 Jun 2012 21:40:33 -0700 (PDT)
Message-ID: <1339735230.4502.10.camel@cumari.coelho.fi> (sfid-20120615_064039_111525_BF7FB778)
Subject: RE: [PATCH] nl80211: specify RSSI threshold when scanning
From: Luciano Coelho <coelho@ti.com>
To: "Chadd, Adrian" <achadd@qca.qualcomm.com>
Cc: "Singh, Naveen" <navesing@qca.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>,
	"Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	ath6kl-devel <ath6kl-devel@qualcomm.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"victorg@ti.com" <victorg@ti.com>
Date: Fri, 15 Jun 2012 07:40:30 +0300
In-Reply-To: <48EC4E8D43A28947B1AB2639FA97CDB90BECBD6F@nasanexd02a.na.qualcomm.com>
References: <1339533801-32016-1-git-send-email-c_tpeder@qca.qualcomm.com>
	 <1339566003.4519.1.camel@jlt3.sipsolutions.net>
	 <1339587447.3840.272.camel@cumari.coelho.fi>
	 <4FD87FEA.3070208@qca.qualcomm.com> <20120613205007.GB3043@pista>
	 <4FD984C1.8090903@qca.qualcomm.com>
	 <48EC4E8D43A28947B1AB2639FA97CDB90BECBC62@nasanexd02a.na.qualcomm.com>
	 <43ED1A9ABC336248B5D371B7C9CCFB96016F339C@nasanexd02b.na.qualcomm.com>
	 <48EC4E8D43A28947B1AB2639FA97CDB90BECBC90@nasanexd02a.na.qualcomm.com>
	 <43ED1A9ABC336248B5D371B7C9CCFB96016F347E@nasanexd02b.na.qualcomm.com>
	 <48EC4E8D43A28947B1AB2639FA97CDB90BECBD6F@nasanexd02a.na.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-14 at 22:16 +0000, Chadd, Adrian wrote:
> Well, my idea was to keep the host asleep for as long as possible. So maybe only wake up the host when you have either:
> 
> * filled the "scan memory" with scan results - so flush those to the host before continuing;

Couldn't getting the "scan memory" full potentially cause you to lose
some results? You might be getting responses while you're processing it,
I guess.


> * finished the scan, and flushing the remaining scan results out.
> 
> I'm just raising the idea, it may not be worth doing.. :)

One other thing to keep in mind, that is not directly related with this
last discussion, is the "intermediate scan results" that Victor has
proposed some time ago[1].  For long scans (11bg + 11a), we want to tell
the userspace about the results before the scan completes to save some
time, but we don't want to wake it up excessively when the results don't
really matter.

[1] http://comments.gmane.org/gmane.linux.kernel.wireless.general/76708

--
Luca.

