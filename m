Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39785 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751588AbYIVRaU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 13:30:20 -0400
Date: Mon, 22 Sep 2008 10:30:10 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Howard Chu <hyc@symas.com>
CC: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k problems
Message-ID: <20080922173010.GD6048@tesla> (sfid-20080922_193024_357587_1E7847AB)
References: <48D5CAD0.1080909@symas.com> <f488382f0809202122v4c77bc96r54edd24bdf365724@mail.gmail.com> <20080922064831.GB19580@tesla> <48D760D8.3050501@symas.com> <43e72e890809220245j77dcf385mb31e505308225ba9@mail.gmail.com> <48D78215.1050403@symas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <48D78215.1050403@symas.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Sep 22, 2008 at 04:31:33AM -0700, Howard Chu wrote:
> Luis R. Rodriguez wrote:
> > On Mon, Sep 22, 2008 at 2:09 AM, Howard Chu<hyc@symas.com>  wrote:
> >> >  For example - I added DPRINTFs to all the places that called ath9_hw_reset()
> >> >  to see why the ForceXPAon message was occurring so often, and got the
> >> >  attached log. I note that ForceXPAon doesn't occur on every call to
> >> >  hw_reset, and sometimes there are repeated identical calls to set the
> >> >  channel (e.g. at 22:06:36 in the log).
> >> >
> >> >  It associates successfully with my AP on channel 8, but shortly thereafter
> >> >  loses the association, scans again, and starts over again, ad nauseam. This
> >> >  behavior was made even worse when I upgraded my freeradius server (was
> >> >  authenticating with WPA EAP/PEAP) and configured TLS session caching - there
> >> >  seems to be a bug in freeradius there so subsequent reassociation attempts
> >> >  would always fail until I turned off session caching. (Haven't had time to
> >> >  chase that down yet.)
> >
> > Howard, did you apply the pending group key patch yet?
> 
> Yes, the patch didn't improve the situation on my wireless-testing build. It
> works fine on my 2.6.27-rc6 build though.

Can you provide a long of your wireless-testing run with the group key
patch applied? Also, please try running wpa_supplicant manually, but
first be sure to disable Network Manager completely by doing:

# Red Hat based systems
sudo /sbin/service NetworkMananger stop
# Debian based systems (Ubuntu is one)
sudo /etc/init.d/NetworkManager stop
sudo killall -TERM wpa_supplicant

Please read:

http://wireless.kernel.org/en/users/Reporting_bugs

  Luis
