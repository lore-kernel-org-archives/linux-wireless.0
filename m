Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:35529 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbYKCHTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 02:19:48 -0500
To: "Tomas Winkler" <tomasw@gmail.com>
Cc: "Michael Buesch" <mb@bu3sch.de>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: No ProbeResp - assume out of range
References: <43e72e890811021305k19e9a314i6400cd1a759b3d00@mail.gmail.com>
	<200811022303.54476.mb@bu3sch.de>
	<1ba2fa240811021442o178c98a1pa920b863b60d9293@mail.gmail.com>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Mon, 03 Nov 2008 09:19:32 +0200
In-Reply-To: <1ba2fa240811021442o178c98a1pa920b863b60d9293@mail.gmail.com> (ext Tomas Winkler's message of "Mon\, 3 Nov 2008 00\:42\:48 +0200")
Message-ID: <87prldb7jv.fsf@nokia.com> (sfid-20081103_081951_298161_55D0DD52)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomas Winkler <tomasw@gmail.com> writes:

>> mac80211 immediately assumes the connection is broken, if one probe-resp
>> to a keekalife-proberequest is lost.
>> So if you scan just after the request got sent, you'll never receive the response
>> and mac80211 will terminate the connection.
>> It should try a few times, instead, before blowing up things.
>
> I've seen this happening  in high traffic with some APs but it can be
> also NIC issue. It needs to really investigate the sniffer capture I
> wouldn't assume its only mac80211 issue.  Probe is issued only when RX
> is not received for some time so there is some problem, nevertheless
> monitoring beacons is a better approach from my experience.

I agree, monitoring received beacons and the number of failed
transmissions would be better. But on the other hand some broken APs
might work better if we periodically send frames to them.

-- 
Kalle Valo
