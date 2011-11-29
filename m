Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qmta12.westchester.pa.mail.comcast.net ([76.96.59.227]:53985
	"EHLO qmta12.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479Ab1K2M7u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Nov 2011 07:59:50 -0500
Received: from www.jots.org (unknown [192.168.22.1])
	by elanor.jots.org (Postfix) with ESMTP id 98B644000A
	for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2011 07:53:32 -0500 (EST)
To: <linux-wireless@vger.kernel.org>
From: "Ken D'Ambrosio" <ken@jots.org>
Subject: Bug report: can't maintain WiFi connectivity in recent kernels.
Date: Tue, 29 Nov 2011 07:53:32 -0500
Content-Type: text/plain; charset=UTF-8; format=fixed
MIME-Version: 1.0
Message-id: <cccaa07e4d4d42fa6f0f88758ca0c46a@www.jots.org> (sfid-20111129_135954_181403_8B093451)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.  For reasons pertaining to btrfs, I'm running 3.1+  kernels, and the wifi
on my system now flakes out sporadically, but reliably.  It can sometimes run
for a couple days, but other days (like, say, yesterday) it'll fail upwards of
30 times. Simply attempting to re-acquire a connection via Network Manager
fails 100%.  I need to rmmod and modprobe the iwlwifi module, and then am able
to immediately connect, 100% of the time -- albeit, briefly.  Rebooting under
these circumstances seems to have as much affect as reloading the module.  (I
wonder if there's something that changes on the WAP side that triggers this? 
That would explain the occasional doses of extended uptime, followed by days of
misery, regardless of reboots and module playing.)

While the behavior, sadly, *is* sporadic, when

- it's not a problem on older (distribution-supplied) kernels, and
- reloading -- and only reloading -- the module fixes it, however briefly,

it seems to me it's probably a problem with the module.


Here's some additional information:

* Happens on multiple WAPs (home, hotel, work, etc.)

* 02:00.0 Network controller: Intel Corporation WiFi Link 1000 Series

* The system *thinks* everything is fine -- NetworkManager happily shows all
the WAPs, etc. -- but I'm unable to re-acquire them until I reload the module.

* kernel 3.1.0+, untainted  (Chris Mason's btrfs git pull from three weeks ago;
also experienced with slightly older, post 3.x kernels)

* Seems to fail most quickly under load (e.g., streaming); can push an hour if
doing relatively little

* I'm unsure which kernel rev. was the tipping point, but Ubuntu 10.04
generally "just worked," and is what I'm booted to now off of USB -- 2.6.32.

I'd give you dmesg messages, but I'm -- catch-22 -- Ubuntu 10.04 won't mount my
btrfs partition, but runs WiFi flawlessly.  If you need those messages, just
let me know, and I'll pull them off.

If there's anything else I can help out with, please don't hesitate to let me
know.

Thanks!

-Ken





