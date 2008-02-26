Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:52247 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764505AbYBZV4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 16:56:55 -0500
Date: Tue, 26 Feb 2008 22:44:10 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: "Ivo Van Doorn" <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Chris Clayton" <chris2553@googlemail.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Message-ID: <20080226224410.4b9216e5@morte> (sfid-20080226_215659_669045_F2AE520F)
In-Reply-To: <a32f33a40802261230o1743773dle38684609d702959@mail.gmail.com>
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com>
	<200802252104.32416.chris2553@googlemail.com>
	<a32f33a40802251409ofbdab60w4a95c8aaefaad70a@mail.gmail.com>
	<200802261911.39577.chris2553@googlemail.com>
	<20080226194838.GD3013@tuxdriver.com>
	<a32f33a40802261230o1743773dle38684609d702959@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 26 Feb 2008 21:30:38 +0100
"Ivo Van Doorn" <ivdoorn@gmail.com> wrote:

> rt2x00 is known to be less sensitive then the legacy drivers, scanning
> produces less and more inconsistent results (Not all AP's are reported,
> even when that AP has a high rssi), and the reported RSSI is often
> much lower then expected with the distance to the AP.
> I have compared many register dumps, but have never managed to
> find a real register setting that might cause this. So what might be
> the problem is that rt2x00 is not reporting the RSSI correctly to mac80211.

No, we don't care at all about RSSI in rc80211-pid.

> I have to admit that I haven't looked into the 'pid' algorithm closely,
> but could it be that some fields in the tx status report upon txdone
> are being treated as "very important" while the driver doesn't report it
> (For example ack signal strength)?

The only important thing drivers should report back to mac80211 are ACKed
frames. In rc80211-pid (and it's just the same in rc80211-simple) the only
inputs from mac80211 are succesfully (re)transmitted frames and failed
frames.


-- 
Ciao
Stefano
