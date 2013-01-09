Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:50328 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757843Ab3AIOKz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 09:10:55 -0500
Received: by mail-bk0-f44.google.com with SMTP id w11so927843bku.17
        for <linux-wireless@vger.kernel.org>; Wed, 09 Jan 2013 06:10:53 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Subject: Re: [PATCH] nl80211: allow ad-hoc to set WMM parameters from outside
Date: Wed, 9 Jan 2013 15:10:49 +0100
Cc: Adrian Chadd <adrian@freebsd.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de> <CAJ-Vmom91BS5fPas+FWsaqQwm-ZVcZckUXB2vQgoEXtKiOH6mA@mail.gmail.com> <20130109131540.GA22836@pandem0nium>
In-Reply-To: <20130109131540.GA22836@pandem0nium>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201301091510.49723.chunkeey@googlemail.com> (sfid-20130109_151059_114953_0353FAF6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday, January 09, 2013 02:15:40 PM Simon Wunderlich wrote:
> On Tue, Jan 08, 2013 at 09:28:44AM -0800, Adrian Chadd wrote:
> > I still populate the WME fields; I need to "fix" paying attention to
> > them in the adhoc case.
> 
> Applying the EDCA parameters in the hardware and sending "standard" WME IEs
> (without EDCA parameter sets) is understandable, Linux does that too. 

Well, the WFA WMM Specification v1.2 costs $99 (last time I checked, which wasn't
too long ago). However Johannes told me that the WMM IE should not be added
to IBSS beacons.

However, we can still pack some EDCA parameters into beacons, probe/(re-)assoc
resps because there's an alternative IE. The "EDCA Parameter Set IE" is part of
802.11-2012 8.4.2.31 - The Element ID is 12 [Table 8-54].

[Note: It's worth mentioning that the WFA WMM spec was just a stop-gap measure
until 802.11e was ready. Here's an article which explains this weird bit of
history, unfortunately it is in German
<http://www.heise.de/netze/artikel/Parallelnorm-WMM-223736.html>]

Regards,
	Chr
