Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.academy.zt.ua ([82.207.120.245]:30555 "EHLO
	mail.academy.zt.ua" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753428Ab1BRMsZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 07:48:25 -0500
Received: from [10.0.2.42] by mail.academy.zt.ua (Cipher SSLv3:RC4-MD5:128) (MDaemon PRO v11.0.3)
	with ESMTP id md50000022391.msg
	for <linux-wireless@vger.kernel.org>; Fri, 18 Feb 2011 14:47:47 +0200
Subject: Re: [RFC] AI support
From: George Kashperko <george@znau.edu.ua>
To: Michael =?ISO-8859-1?Q?B=FCsch?= <mb@bu3sch.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	=?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	driverdevel <devel@driverdev.osuosl.org>,
	Henry Ptasinski <henryp@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>
In-Reply-To: <1298030032.22193.1.camel@maggie>
References: <1297958316.5623.27.camel@dev.znau.edu.ua>
	 <4D5DDCBC.2050501@broadcom.com> <1298014793.28946.39.camel@dev.znau.edu.ua>
	 (sfid-20110218_084826_360002_FFFFFFFF9D44E835)  <1298030032.22193.1.camel@maggie>
Content-Type: text/plain
Date: Fri, 18 Feb 2011 14:39:47 +0200
Message-Id: <1298032787.25739.2.camel@dev.znau.edu.ua>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, 

> There are plenty of examples in the kernel where code was simply forked
> for the development of a new technology. Look at b43/b43legacy or
> ext2/3/4 just for a few examples. The forks were made on purpose
> to avoid maintainability nightmares. Yes, at first sight, some code had
> to be duplicated. But I don't see that as an issue. The two codebases
> will diverge quickly from each other as development is done.
Does this mean RFC subject in its current state is rejected ?

> So I'm supporting Henry in that SSB is legacy and EOL. Let's simply
> start over and don't carry old cruft over.
> 
> Note that this does not mean that we need to duplicate the MIPS,
> common and probably pci core drivers. A hybrid module can be done,
> if that's desired to avoid code duplication.
Well, any plans or even maybe ETA on this ?

> And I also think that you're worrying _way_ too much about a few
> if/else statements in the drivers. (Look at the TMSLOW discussion).
> The SSB/AI->driver interface is trivial and tiny. There will be maybe
> 10 if/else statements. It's really _not_ worth introducing major
> abstraction code in the SSB and AI code to avoid a few if/else
> statements in the drivers.
> The bulk of the SSB->driver interface _is_ already abstracted inside
> of the drivers (b43_read/write...). The rest is negligible.
Well, not like I really worry alot about those if/elses :)
Just in this particular case of SSB in its current design I don't really
see much differences in where bus implementation-specific management
must be abstracted if only AI support over SSB is implemented. If there
will be just b43 relying on such an abstraction then no doubt lets do it
in b43 driver. But its not.

> And if it turns out _afterwards_ that we could avoid a few if/else
> statements by introducing some additional abstraction layer, this
> thing can be introduced _afterwards_.
Almost exactly what I thought working on AI over SSB. 

> PS: Could you please stop stripping the CC list.
> 
Sorry for that.

Have nice day,
George


