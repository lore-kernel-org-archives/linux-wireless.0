Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:28420 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbZGMS3u (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jul 2009 14:29:50 -0400
Received: by fg-out-1718.google.com with SMTP id e21so725407fga.17
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jul 2009 11:29:48 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: iwlwifi 4965 uCode available
Date: Mon, 13 Jul 2009 20:29:52 +0200
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
References: <1247174482.17896.1304.camel@rc-desk> <200907121445.42289.helmut.schaa@gmail.com> <1247499979.17896.1556.camel@rc-desk>
In-Reply-To: <1247499979.17896.1556.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200907132029.53507.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 13. Juli 2009 schrieb reinette chatre:
> On Sun, 2009-07-12 at 05:45 -0700, Helmut Schaa wrote:
> > Am Donnerstag, 9. Juli 2009 schrieb reinette chatre:
> > > Version 228.61.2.24 of uCode for Intel Wireless WiFi Link 4965AGN is now
> > > available for download from
> > > http://intellinuxwireless.org/?n=Downloads
> > 
> > The new ucode seems to cause fw restarts every now and then (together
> > with wireless-testing).
> 
> oh no ...
> 
> > 
> > iwlagn 0000:10:00.0: Microcode SW error detected.  Restarting 0x82000000.
> 
> What is the status when such an error occurs? Can it recover on its own
> or do you need to take action? What action is needed?

It recovers automatically, no action required. Not sure if it has any
negative impact on the connection. At least I did not notice anything yet.

> > I couldn't figure out how to reproduce this but it happened a few times
> > now since I switched to the new ucode.
> > 
> > Should I load iwlagn with some special debug flags?
> 
> If your driver is compiled with CONFIG_IWLWIFI_DEBUG then you can pass a
> debug flag to the module that will print a ucode event log when it
> encounters a problem like this. As it will only print out the event log
> when this error occurs you can safely turn this debugging on permanently
> without risking a clutter of your logs. Later, if you know how to
> reproduce is you can increase debugging to get more details about what
> the driver is actually doing. The debug flag for _just_ the ucode event
> log is 0x40000 (like "modprobe iwlagn debug=0x40000"). The 0x43fff is a
> more general debug flag that helps with obtaining more information.
> 
> When you have this data - could you please submit a bug at
> intellinuxwireless.org/bugzilla for us to be able to track it?

Will do as soon as I find a way to reproduce it.

Helmut
