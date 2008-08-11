Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from usul.saidi.cx ([204.11.33.34]:57507 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751680AbYHKQlw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 12:41:52 -0400
Message-ID: <48A06BBC.7060007@overt.org> (sfid-20080811_184158_469091_98C0630E)
Date: Mon, 11 Aug 2008 09:41:32 -0700
From: Philip Langdale <philipl@overt.org>
MIME-Version: 1.0
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
CC: LKML <linux-kernel@vger.kernel.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
 through rfkill (v2)
References: <4894B1B4.6050003@overt.org> <20080803042613.GC6053@khazad-dum.debian.net> <48965716.6020508@overt.org> <20080805212416.GB21738@khazad-dum.debian.net> <489A7CCF.1090407@overt.org> <20080807134530.GB17062@khazad-dum.debian.net>
In-Reply-To: <20080807134530.GB17062@khazad-dum.debian.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Henrique de Moraes Holschuh wrote:
> 
> Hmm?  UNBLOCKED means it is not being rfkilled.  Why is not working?  Put
> some debug printks on your toggle_radio callback, that might help fix the
> issue...
> 

Well, what I see is this:

At modprobe, I get an explicit unblock request. When I modify 'state' in sysfs,
I see appropriate requests to soft block and unblock. When I activate the hardware
kill switch, the rfkill state goes to hard_block but no one calls toggle_radio
and when I release the kill switch, the state goes to soft_block and no one
calls toggle_radio.

--phil
