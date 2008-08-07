Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbYHGUu3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 16:50:29 -0400
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
From: Dan Williams <dcbw@redhat.com>
To: Dave <kilroyd@googlemail.com>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net
In-Reply-To: <489B5868.2010400@gmail.com>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
	 <1217825304.10989.20.camel@dv>
	 <1217864060.3139.10.camel@localhost.localdomain>
	 <1217970944.2908.11.camel@dv>
	 <1217973349.30531.1.camel@localhost.localdomain>
	 <1217976491.2908.36.camel@dv>
	 <1218028414.16977.5.camel@localhost.localdomain>
	 <4899FB91.8070501@gmail.com>
	 <1218056165.12240.0.camel@localhost.localdomain>
	 <489A12E2.8060909@gmail.com>
	 <1218077300.30724.10.camel@localhost.localdomain>
	 <489B425F.5060704@gmail.com>
	 <1218138129.32083.14.camel@localhost.localdomain>
	 <489B5868.2010400@gmail.com>
Content-Type: text/plain
Date: Thu, 07 Aug 2008 16:46:44 -0400
Message-Id: <1218142004.3481.1.camel@localhost.localdomain> (sfid-20080807_225032_686990_F0D906C1)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-08-07 at 21:17 +0100, Dave wrote:
> Dan Williams wrote:
> > On Thu, 2008-08-07 at 19:43 +0100, Dave wrote:
> >> That said, what's wrong with the ap_scan=2 mode? You've stated it's
> >> not great (and I'm prepared to believe it), but what is the actual problem?
> 
> <snip explanation>
> 
> Thanks for that.
> 
> >> I had a reread of <http://hostap.epitest.fi/wpa_supplicant/devel/driver_wrapper.html>. 
> >>
> >> As a FullMAC driver without support for selecting the BSSID to associate
> >> with (or frequency in Managed mode), the only way I can see to make the
> >> driver work with ap_scan=1 is to silently ignore the SIOCSIWFREQ and
> >> SIOCSIWAP. I don't think this is an approach I would want to pursue.
> > 
> > Well, the current orinoco driver returns "success" (0) for SIOCSIWAP on
> > Agere firmware.
> 
> borken dkilroy # dmesg | grep eth1
> eth1: Hardware identity 0001:0001:0004:0002
> eth1: Station identity  001f:0001:0008:0048
> eth1: Firmware determined as Lucent/Agere 8.72
> eth1: Attempting to download firmware agere_sta_fw.bin
>   <snip fw download>
> eth1: Hardware identity 0001:0001:0004:0002
> eth1: Station identity  001f:0002:0009:0030
> eth1: Firmware determined as Lucent/Agere 9.48
>   <snip capabilities>
> eth1: ready
> eth1: orinoco_cs at 0.0, irq 11, io 0x0100-0x013f
> eth1: New link status: Connected (0001)
> 
> borken dkilroy # iwlist eth1 scan essid MONTY
> eth1      Scan completed :
>           Cell 01 - Address: 00:18:4D:06:45:76
>                     ESSID:"MONTY"
>                     Mode:Master
>                     Channel:5
>          <snip detail>
> 
> borken dkilroy # iwconfig eth1 ap 00:18:4d:06:45:76
> Error for wireless request "Set AP Address" (8B14) :
>     SET failed on device eth1 ; Operation not supported.
> 
> borken dkilroy # iwconfig eth1 ap off              
> borken dkilroy #
> 
> 
> The above is running with my patchset, but I haven't touched the SIOCSIWAP handler. Honest.

No, you're right.  I was looking at __orinoco_hw_set_wap() instead.
Thought required on my part about how to handle this then.

Dan

