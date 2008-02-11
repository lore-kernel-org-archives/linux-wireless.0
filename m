Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753171AbYBKWtO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2008 17:49:14 -0500
Subject: Re: madwifi is not fully open source
From: Dan Williams <dcbw@redhat.com>
To: Budhee Jamaich <budheej@gmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <57314e840802111427i7e8d00capbe430727faff78a1@mail.gmail.com>
References: <57314e840802111427i7e8d00capbe430727faff78a1@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 11 Feb 2008 17:48:32 -0500
Message-Id: <1202770112.6824.35.camel@localhost.localdomain> (sfid-20080211_224919_190395_99BF13AA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-02-12 at 00:27 +0200, Budhee Jamaich wrote:
> Hi,
> 
> I read at linuxwireless.org that "madwifi is not fully open source".

Correct.

> If I understand correctly, this is because they put the radio-related code
> in a binary module, to meet regulatory requirements.

To meet _their__interpretation_ of regulatory requirements.  Theirs is
not the only interpretation that exists, and other vendors like Intel
and zydas interpret the requirements differently and have implemented
different approaches to the regulatory issues.

> If so, all the other drivers, which are not marked as "not fully open source",
> did release their RF code as open source ? How could that be ?
> Wouldn't they have regulatory problems ?

Not opening the RF regulatory code is the solution that Atheros took.  I
can't (off the top of my head) think of any other vendor who has done
this.  Other vendors are much more open-source friendly while still
following what they believe is a sufficient interpretation of the
regulations.

> What should a new vendor, planning to write a driver, do ? Open Source
> everything, and expect legal issues, or release RF code as binary-only ?

Talk to your lawyers.  You do not necessarily have legal issues if you
open the RF regulatory code, but you must talk to your own lawyers to
find out what's best for your company.  You have a few options (not
limited to the following):

1) Make the RF regulatory code a closed, binary module like Atheros has
done that is linked directly into the kernel module.  Your module is
probably illegal (again, consult your lawyer on linking non-GPL code to
GPL code), and your driver _certainly_ will not be accepted by the
upstream kernel.  Your hardware will have to be reverse-engineered by
the open source community to produce a free driver and people will
dislike you and your company :)

2) Keep your RF regulatory code open and hook it into the mac80211
regulatory framework like most other open drivers are doing.  Again,
consult your lawyers on whether or not they feel this is an acceptable
solution.  Your driver can be accepted into the upstream kernel, hordes
of developers will improve your driver for you, and everyone is happy.

3) Put your RF regulatory code into the _firmware_ of your device (this
is what Intel has done with 3945 and 4965 parts).  This is very
acceptable, but still be sure to consult your lawyers.  Your driver can
be accepted into the upstream kernel, hordes of developers will improve
your driver for you, and everyone is happy.

The problem is only when the closed code is running on the _host_ CPU
and linked to GPL kernel code, like Atheros has done with madwifi.  This
has caused the current ath5k effort, which uses a reverse-engineered
open HAL which has just been accepted into the upstream 2.6.25 kernel.
Whatever code is in firmware is not subject to the GPL-related linkage
legal issues like madwifi is.

If you do have firmware for your device, _please_ consider using a
license like Intel has for their 2100, 2200, 2915, 3945, and 4965
devices that permits redistribution of the microcode.  You can
_certainly_ still protect your company's intellectual property and also
allow unlimited redistribution of the microcode.  This means that users
will not have to search out your firmware or run "cutter" tools on it,
but can have it installed by default and have your hardware work out of
the box!  Many happy users.

If you want to see the license, download and uncompress this:

http://intellinuxwireless.org/iwlwifi/downloads/iwlwifi-4965-ucode-4.44.1.20.tgz

Hope this helps, feel free to ask further questions if some things
aren't clear enough.

Dan

