Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:47722 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbYFMVIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2008 17:08:09 -0400
Subject: Re: iwl3945 and WPA
From: Pavel Roskin <proski@gnu.org>
To: Maciek Kaliszewski <mkalkal@interia.pl>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4852D6EB.3020304@interia.pl>
References: <4852658A.4040402@interia.pl>
	 <20080613132317.GB5333@tuxdriver.com>
	 <1ba2fa240806130637u1f4b485dked28ce04ff52a9b5@mail.gmail.com>
	 <48527D72.4070509@interia.pl> <1213375014.29669.36.camel@dv>
	 <4852D6EB.3020304@interia.pl>
Content-Type: text/plain
Date: Fri, 13 Jun 2008 17:08:07 -0400
Message-Id: <1213391287.22425.31.camel@dv> (sfid-20080613_230813_891207_B4CEF0F2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-06-13 at 22:22 +0200, Maciek Kaliszewski wrote:

> I've checked and 0.6.3 is latest development version of wpa_supplicant.
> > Try removing "scan_ssid=1".   Also try ESSID scanning in iwlist:
> > iwlist wlan0_rename scanning essid APTEKA
> >   
>  Removing scan_ssid doesn't help .
> 
> iwlist wlan0_rename scanning essid APTEKA
> 
> gives the same results like
> 
> iwlist wlan0_rename scanning
> and
> iwlist wlan0_rename scanning essid AAAA
> so driver ignores essid parameter

Well, if iwlist doesn't confuse the driver by "essid", neither should
wpa_supplicant.

> It looks like driver issue (driver is returning bogus data)

But why does iwlist display the same data correctly?  If iwlist can
parse it, wpa_supplicant should be able to parse it as well.

Google search for "Invalid freq in scan results" finds another such case
back in year 2004:
http://lists.shmoo.com/pipermail/hostap/2004-March/thread.html#6134

> there is no AP with BSSID 00:00:01:00:00:1d and hidden SSID in vicinity 
> . There is only one (my) AP in the range .

Of course.  It looks like the initial "00:00:01:00" is bogus and the
final "00:1d" is the beginning of the correct BSSID.

> Moreover p54pci.ko driver  (from the  same family  )  works  just fine 
> with  this  version  of  wpa_supplicant .
> Command line and config file I run wpa_supplicant with  is the same.

It may be an alignment issue.  Different drivers may include different
data, in different order.

I suggest that you debug wpa_supplicant, specifically
wpa_driver_wext_get_scan_results() in src/drivers/driver_wext.c.  Try
printing iwe->cmd and iwe->len before the switch.  And please move it to
the hostap list.  If there is anything definitely wrong with the driver,
then please let us know.

-- 
Regards,
Pavel Roskin
