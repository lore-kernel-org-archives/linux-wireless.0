Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:42763 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553AbYHGVIs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Aug 2008 17:08:48 -0400
Received: by ik-out-1112.google.com with SMTP id c28so601355ika.5
        for <linux-wireless@vger.kernel.org>; Thu, 07 Aug 2008 14:08:45 -0700 (PDT)
Message-ID: <489B6458.8050206@gmail.com> (sfid-20080807_230851_591316_A14685D8)
Date: Thu, 07 Aug 2008 22:08:40 +0100
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere
 fw
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>	 <1217825304.10989.20.camel@dv>	 <1217864060.3139.10.camel@localhost.localdomain>	 <1217970944.2908.11.camel@dv>	 <1217973349.30531.1.camel@localhost.localdomain>	 <1217976491.2908.36.camel@dv>	 <1218028414.16977.5.camel@localhost.localdomain>	 <4899FB91.8070501@gmail.com>	 <1218056165.12240.0.camel@localhost.localdomain>	 <489A12E2.8060909@gmail.com>	 <1218077300.30724.10.camel@localhost.localdomain>	 <489B425F.5060704@gmail.com> <1218138129.32083.14.camel@localhost.localdomain>
In-Reply-To: <1218138129.32083.14.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Thu, 2008-08-07 at 19:43 +0100, Dave wrote:
>> That said, what's wrong with the ap_scan=2 mode? You've stated it's not
>> great (and I'm prepared to believe it), but what is the actual problem?

> But the problem with ap_scan=2 is really about the failure window.
> ap_scan=2 basically dumps a load of options on the driver, and unless
> the options _exactly_ match the configuration of the AP, you won't
> connect.  The supplicant isn't able to make intelligent choices about
> which networks in its config file match the scan result, thus there's a
> lot more potential for failure unless you know exactly what your network
> is set up to do, and these capabilities aren't always exposed through
> beacons.  So ap_scan=2 just opens up a huge window of failure and stuff
> can't ever Just Work because no intelligence can be applied.

Wouldn't a different mode of operation in wpa_supplicant solve this (see below)? Then get rid of the mode selection via wpa_supplicant.conf by selecting mode based on drivers error responses (and/or reported capabilities).

ap_scan=3:
    * wpa_supplicant requests scan with SIOCSIWSCAN
    * driver reports scan complete with wireless event SIOCGIWSCAN
    * wpa_supplicant reads scan results with SIOCGIWSCAN (multiple call if a larget buffer is needed)
    * wpa_supplicant decides which SSID to use based on scan results
    * wpa_supplicant configures driver to associate with an SSID (SIOCSIWMODE, SIOCSIWGENIE, SIOCSIWAUTH, SIOCSIWESSID)

SIOCSIWSCAN not supported? => ap_scan=2
SIOCSIWFREQ or SIOCSIWAP not supported? => ap_scan=3
else ap_scan=1


Regards,

Dave.
