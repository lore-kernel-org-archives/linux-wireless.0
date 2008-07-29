Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:40493 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbYG2V0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 17:26:40 -0400
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: Tomas Winkler <tomasw@gmail.com>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	Hin-Tak Leung <hintak.leung@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net>
	<48874F09.7060400@lwfinger.net>
	<3ace41890807281939y462c9b91n5fa952e167b6ff8c@mail.gmail.com>
	<200807290021.45400.herton@mandriva.com.br>
	<1217314430.15381.11.camel@johannes.berg>
	<1ba2fa240807290123n7673dbb9m7121c1e76fe57e94@mail.gmail.com>
	<1217320089.15381.25.camel@johannes.berg>
From: Kalle Valo <kalle.valo@nokia.com>
In-Reply-To: <1217320089.15381.25.camel@johannes.berg> (ext Johannes Berg's message of "Tue\, 29 Jul 2008 10\:28\:09 +0200")
Date: Wed, 30 Jul 2008 00:26:00 +0300
Message-ID: <87y73kjsbb.fsf@nokia.com> (sfid-20080729_232643_706316_A1163E93)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Tue, 2008-07-29 at 11:23 +0300, Tomas Winkler wrote:
>> On Tue, Jul 29, 2008 at 9:53 AM, Johannes Berg
>> <johannes@sipsolutions.net> wrote:
>> > On Tue, 2008-07-29 at 00:21 -0300, Herton Ronaldo Krzesinski wrote:
>> >
>> >> [3] /sbin/iwconfig wlan0 power on
>> >
>> > I don't think turning on power management (yes, this command is
>> > completely misnamed, it turns on power _management_ not the power, you
>> > may want "txpower auto") does anything on this chip, does it?
>> >
>> iwconfig power on is not implemented by mac80211 yet. There was one
>> patch posted that implements it.
>> I wanted to expand it but  wireless_tools 29 has a bug in parsing this
>> command. It is fixed only in 30.pre6 which is usually not in distros.
>
> Heh, fun. Time for putting that into cfg80211 instead if nobody can use
> it with wext anyway?

Wireless Extensions needs to be supported as well, we simply cannot
yet rely only on cfg80211 interface. The reason being that it's not
widely supported yet.

-- 
Kalle Valo
