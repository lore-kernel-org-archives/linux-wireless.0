Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from msr1.hinet.net ([168.95.4.101]:47562 "EHLO msr1.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab1F0HZr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 03:25:47 -0400
Date: Mon, 27 Jun 2011 15:23:51 +0800
From: Ali Bahar <ali@internetdog.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: r8712u driver for the rtl8192su chip.
Message-ID: <20110627072351.GA4251@internetdog.org> (sfid-20110627_093601_418744_AA88955C)
Reply-To: ali@internetdog.org
References: <BANLkTinw+jv8zBi29EKs2K2=tAJMYCEdgQ@mail.gmail.com>
 <4DC0669E.4040100@lwfinger.net>
 <BANLkTikxS_2wJEpijmYQy3nPy2-9pykxdA@mail.gmail.com>
 <4DC06BF3.6070208@lwfinger.net>
 <20110621124954.GA8462@internetdog.org>
 <4E011644.3070906@lwfinger.net>
 <20110622010057.GA12123@internetdog.org>
 <4E0154B7.2000204@lwfinger.net>
 <20110622025623.GC12547@internetdog.org>
 <4E015CE8.3000304@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4E015CE8.3000304@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Larry,


On Tue, Jun 21, 2011 at 10:09:28PM -0500, Larry Finger wrote:
> On 06/21/2011 09:56 PM, Ali Bahar wrote:
> >
> >>>>>this is more of a quick FYI, regarding Staging's r8712u driver.
> >>>
> >>>>>root@hashbang Tue Jun 21 18:30:06 ~$ iwconfig wlan2 essid "h55m"
> >>>>>Error for wireless request "Set ESSID" (8B1A) :
> >>>>>     SET failed on device wlan2 ; Operation not permitted.

> I am not rewriting this driver in the immediate future, thus you
> need to find out what is wrong.
 
The cause is that the driver's handler for the Set expects that the
interface is Up. In my case, it was not, and so it returns a -1. This
pops back up the call-chain until it gets misinterpreted as an EPERM. 

I'll use this Set as an example, though the same pattern is seen
elsewhere.
Upon entry into r8711_wx_set_scan(), this check is done:

   1090         if (padapter->bup == false)
   1091                 return -1;


The adapter structure has no comments as to what bup is (nor for
bDriverStopped). Current usage suggests that bup indicates that the
interface is Up (and bDriverStopped indicates that the driver has been
cleanly stopped)


The Fix:
~~~~~~~
1. the -1 return-values must be changed, or translated, so as to not
   conflict with EPERM/errno.
2. The 802.11 cfg SETs ought not check bup, or the definition of bup
   has to be made distinct from the interface's Up status.

I tried to dig into the history of this code, but found none before
2010. The source which came on the product's cdrom (ASUS WL-167G V3)
is very old, and too different. Realtek's website provides recent
code, but is significantly newer than that which you seem to have
based your code on. And, unfortunately, it contains the same usage of
bup!

So, if the above analysis is correct, should the patch be based on the
Staging code?

Additional Info:
~~~~~~~~~~~~~~~
The question did arise as to whether the driver's expectation (of the
interface being Up) is legitimate. But this was dismissed because:
- I did not expect it to be so. There really is no reason why it'd be
  obligatory!
- Other drivers handle Sets of their 802.11 configuration while the
  interface is Down;
- the frequent case is for such Sets to take place before an IP number
  is obtained via DHCP! So the interface will not be Up;
- the 802.11 Standard ought not take a stance with respect to this.
  Indeed, to the extent that I dug into this, it does not seem to
  have. 

regards,
ali
