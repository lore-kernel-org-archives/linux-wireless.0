Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:44307 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756183Ab1FDMoz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 08:44:55 -0400
Date: Sat, 4 Jun 2011 13:44:48 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Marco Chiappero <marco@absence.it>
Cc: Mattia Dongili <malattia@linux.it>,
	platform-driver-x86@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 12/25] sony-laptop: input core improvements improvements
Message-ID: <20110604124448.GB14809@srcf.ucam.org> (sfid-20110604_144504_175329_1B1C0AD6)
References: <4DE8FC4A.9010401@absence.it>
 <4DE9012E.5040207@absence.it>
 <20110604080717.GC7194@kamineko.org>
 <4DEA0C27.1000508@absence.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DEA0C27.1000508@absence.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 04, 2011 at 12:42:47PM +0200, Marco Chiappero wrote:

> As far as I know this event should be forwarded and the rfkill-input
> code removed as soon as there is enough userspace support. Another
> platform driver (thinkpad_acpi) is using it.
> What is right and what is wrong? Should it be removed from
> thinkpad_acpi too?

This event should be sent if hitting the switch is a request to 
userspace. If pressing it causes the hardware to perform the change and 
this is merely a notification that the change has been made, it 
shouldn't be sent. Just update the rfkill state and let userspace notice 
the uevents from rfkill.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
