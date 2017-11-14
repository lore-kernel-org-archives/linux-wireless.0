Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga07.intel.com ([134.134.136.100]:55213 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751030AbdKNGdH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Nov 2017 01:33:07 -0500
Message-ID: <1510641182.4011.65.camel@intel.com> (sfid-20171114_073323_812283_16DE68CF)
Subject: Re: Fwd: linux v4.14 causes firmware iwlwifi errors on Lenovo
 Thinkpad T440s
From: Luciano Coelho <luciano.coelho@intel.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Date: Tue, 14 Nov 2017 08:33:02 +0200
In-Reply-To: <10da37f3-a018-7568-49a8-3a8ed86ef64c@lwfinger.net>
References: <CAMRc=Mf92X2t8wjmE+xkXrA0QKY06uFeXhMY-97Ka=_UxuQbjw@mail.gmail.com>
         <CAMRc=Mf-4HnRXLxoiPrzZVjeCpfY5+Q2Ydmee0GkViejk8nzaQ@mail.gmail.com>
         <3045d677-8f24-b258-0eaf-ee8dae5ecd4c@lwfinger.net>
         <CAMRc=Mf-sy79yoJiyZC8pOtHTo4P7SpHPsTmuHxEBfbc8xa+Uw@mail.gmail.com>
         <10da37f3-a018-7568-49a8-3a8ed86ef64c@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-11-13 at 16:23 -0600, Larry Finger wrote:
> On 11/13/2017 03:30 PM, Bartosz Golaszewski wrote:
> > 2017-11-13 21:45 GMT+01:00 Larry Finger <Larry.Finger@lwfinger.net>
> > :
> > > On 11/13/2017 02:22 PM, Bartosz Golaszewski wrote:
> > > > 
> > > > Forwarding here too as I messed up the address the last time.
> > > > --
> > > > 
> > > > Hi,
> > > > 
> > > > I noticed my wireless interface can't get up with linux v4.14
> > > > and the
> > > > kernel log is flooded with firmware errors:
> > > > 
> > > > iwlwifi 0000:03:00.0: Firmware error during reconfiguration -
> > > > reprobe!
> > > > iwlwifi 0000:03:00.0: FW error in SYNC CMD DQA_ENABLE_CMD
> > > > 
> > > > and
> > > > 
> > > > ieee80211 phy63: Hardware restart was requested.
> > > > 
> > > > The wireless controller is: Intel Corporation Wireless 7260
> > > > (rev 83)
> > > > Firmware used is: iwlwifi-7260-17
> > > > 
> > > > Everything works fine with v4.13.12.
> > > > 
> > > > I didn't have time today to bisect for the offending commit.
> > > > Full log
> > > > uploaded[1].
> > > > 
> > > > Best regards,
> > > > Bartosz Golaszewski
> > > > 
> > > > [1] https://pastebin.com/jksqxvS6
> > > 
> > > 
> > > Your log shows "iwlwifi 0000:03:00.0: loaded firmware version
> > > 17.228510.0
> > > op_mode iwlmvm"
> > > 
> > > Mine, where the 7260 works, shows "iwlwifi 0000:04:00.0: loaded
> > > firmware
> > > version 17.459231.0 op_mode iwlmvm".
> > > 
> > > It seems as if you need newer firmware. A detailed file listing
> > > shows
> > > "-rw-r--r-- 1 root root 1049340 Oct  9 12:03
> > > /lib/firmware/iwlwifi-7260-17.ucode". That date is likely when I
> > > installed
> > > the updated kernel firmware package from my distro. The md5sum
> > > for the file
> > > is 73a217f55c47d3a70bb5dbbe1d676423.
> > > 
> > > Larry
> > > 
> > 
> > Ok so it seems the version in linux-firmware is outdated. The file
> > you're using is available on github[1] and fixed the issue for me.
> > 
> > Thanks!
> > Bartosz Golaszewski
> > 
> > [1] https://github.com/OpenELEC/iwlwifi-firmware
> 
> Interesting. Using md5sum of the git repo for linux-firmware gets
> 73a217f55c47d3a70bb5dbbe1d676423  iwlwifi-7260-17.ucode.
> 
> That is the file I'm using.

You shouldn't use firmwares from github or anywhere else except from
the two official places where we release it:

Mainline (but slow to get updated):

https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/plain/iwlwifi-7260-17.ucode


Our official public tree:

https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/linux-firmware.git/plain/iwlwifi-7260-17.ucode


And, of course, your distro may distribute these in an official package
as well, but it's good to check the versions to be sure you're running
the latest one we released.

--
Cheers,
Luca.
