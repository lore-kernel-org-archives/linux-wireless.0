Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2641 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751023AbaHIGda (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2014 02:33:30 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>
CC: Arend van Spriel <arend@broadcom.com>,
	Dave Taht <dave.taht@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: Reporting firmware stats to ethtool
References: <53E3F65D.8080102@candelatech.com>
	<87wqajz6yg.fsf@kamboji.qca.qualcomm.com>
	<53E4EFCB.5090501@candelatech.com>
	<CAA93jw429GCjwiD0FQNFudZ0RDEKShZh4iiuOP+g+PpRjFNT7Q@mail.gmail.com>
	<53E4F6B8.50009@candelatech.com> <53E4FEA9.80803@broadcom.com>
	<53E507EB.7030703@candelatech.com>
Date: Sat, 9 Aug 2014 09:32:56 +0300
In-Reply-To: <53E507EB.7030703@candelatech.com> (Ben Greear's message of "Fri,
	8 Aug 2014 10:24:59 -0700")
Message-ID: <87r40quq93.fsf@kamboji.qca.qualcomm.com> (sfid-20140809_083333_293580_B3B94B3D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ben Greear <greearb@candelatech.com> writes:

>> Does ath driver notify mac80211 about firmware restart, ie. through
>> ieee80211_restart_hw(). If only user-space could get that info.
>
> We should soon have a udev event on firmware crash

Who should send the event, the driver or mac80211? I'm not very familiar
with udev stuff, what kind of rules there are for udev events?

> A simple restart (w/out crash) might not be so interesting?

Yeah, we should not report that. ath10k stops the firmware on interface
down and starts it again on interface up which is business as usual.

> Might be nice to have a fw restart and fw crash counter in ethtool
> stats in case something wants to poll that instead of dealing with
> uevents. I will add those counters.

Yeah, those would be great to have.

-- 
Kalle Valo
