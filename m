Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:40811 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754755AbYALTdg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Jan 2008 14:33:36 -0500
Date: Sat, 12 Jan 2008 20:28:54 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-kernel@vger.kernel.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: rtl8187 rate control doesn't work
Message-ID: <20080112202854.2c24ba19@morte> (sfid-20080112_193343_297057_27A1905C)
In-Reply-To: <478905B9.3080004@hauke-m.de>
References: <477F9890.5050107@hauke-m.de>
	<43e72e890801051354v280c0ceeo78790bb5f1f45314@mail.gmail.com>
	<47824D25.5090005@hauke-m.de>
	<43e72e890801070942y5abcc8acs31ac446d67414483@mail.gmail.com>
	<4787F03E.6080605@hauke-m.de>
	<4788D24E.30805@hauke-m.de>
	<20080112162121.2fc2f507@morte>
	<478905B9.3080004@hauke-m.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 12 Jan 2008 19:23:53 +0100
Hauke Mehrtens <hauke@hauke-m.de> wrote:

> I have tried wireless-2.6 and I have the same problem. If the rate goes
> over 11M no TCP/IP traffic goes through the wireless connecting. If rate
> is set to auto and the rate control algorithm changes it to something
> less than 11M TCP/IP traffic goes through, but if it is more than 11M no
> TCP/IP traffic goes through the wireless link.

And this is a problem if the rate control algorithm often sets the rate to
more than 11M even if connection is unreliable at that rate. Does this
actually happen? Are you currently using 'pid'?

Also, it would be fine to have a dump of the PID events. In order to get
this, you need to:
- build a kernel with debugfs enabled;
- mount debugfs (mount -t debugfs foo /mnt/debug)

Then, before testing:
cat /mnt/debug/ieee80211/phy0/stations/*/rc_pid_events > events_dump

You can even make a graph out of that, with a python script which Mattias
posted on this list some time ago, but a dump would be just fine.


--
Ciao
Stefano
