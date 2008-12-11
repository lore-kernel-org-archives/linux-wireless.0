Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:22506 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520AbYLKN3y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 08:29:54 -0500
To: "Michael Buesch" <mb@bu3sch.de>
Cc: "Julian Calaby" <julian.calaby@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Matthew Garrett" <mjg59@srcf.ucam.org>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	hmh@hmh.eng.br
Subject: Re: [RFC] b43: rework rfkill code
References: <20081210150935.GA10927@srcf.ucam.org>
	<1228922997.15837.6.camel@johannes.berg>
	<646765f40812101632u76847935l2405482aabe1c1f8@mail.gmail.com>
	<200812110227.26909.mb@bu3sch.de>
From: Kalle Valo <kalle.valo@nokia.com>
Date: Thu, 11 Dec 2008 15:28:38 +0200
In-Reply-To: <200812110227.26909.mb@bu3sch.de> (ext Michael Buesch's message of "Thu\, 11 Dec 2008 02\:27\:25 +0100")
Message-ID: <87y6ymkfi1.fsf@nokia.com> (sfid-20081211_143002_579284_316037B6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Buesch <mb@bu3sch.de> writes:

> On Thursday 11 December 2008 01:32:37 Julian Calaby wrote:
>
>> What strikes me, watching this from the outside - is that rfkill and
>> power saving seem to be doing essentially the same thing: temporarily
>> powering down the radio / card.
>
> I think it's essentially a different thing. rfkill means -> turn off
> the radio; no matter what. PS means -> turn off the radio for
> whatever amount of microseconds and periodically wake up to see
> what's up. PS-core also takes place in the firmware of the device,
> where rfkill is a much higher layer thing.

I agree, they shouldn't be intermixed at all.

-- 
Kalle Valo
