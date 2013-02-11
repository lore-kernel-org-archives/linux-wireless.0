Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:29590 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758459Ab3BKSCF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 13:02:05 -0500
Date: Mon, 11 Feb 2013 19:01:59 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] [3.9] NFC pull request
Message-ID: <20130211180159.GY20996@sortiz-mobl> (sfid-20130211_190209_491543_322F4045)
References: <20130208132335.GB20996@sortiz-mobl>
 <20130208194324.GI2116@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130208194324.GI2116@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

On Fri, Feb 08, 2013 at 02:43:25PM -0500, John W. Linville wrote:
> On Fri, Feb 08, 2013 at 02:23:35PM +0100, Samuel Ortiz wrote:
> > Hi John,
> > 
> > This is the second NFC pull request for 3.9.
> > 
> > We have:
> > 
> > - A few pn533 fixes on top of Waldemar refactorization of the driver, one of
> >   them fixes target mode.
> > 
> > - A new driver for Inside Secure microread chipset. It supports two
> >   physical layers: i2c and MEI. The MEI one depends on a patchset that's
> >   been sent to Greg Kroah-Hartman for inclusion into the 3.9 kernel [1]. The
> >   dependency is a KConfig one which means this code is not buildable as long
> >   as the MEI API is not usptream.
> > 
> > Thanks in advance for pulling them in.
> > 
> > [1] https://lkml.org/lkml/2013/2/8/165
> > 
> > 
> > The following changes since commit 9ebea3829fac7505e0cd2642fbd13cfa9c038831:
> > 
> >   Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless (2013-01-28 13:54:03 -0500)
> > 
> > are available in the git repository at:
> > 
> > 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.9-2
> > 
> > for you to fetch changes up to 52f2eaeec11c16c219f0e99b8496fbba86889830:
> > 
> >   NFC: pn533: Fix target polling mode (2013-02-08 12:18:48 +0100)
> 
> Pulling now...
The MEI bus API got some more comments from Greg Kroah-Hartman and got
slightly changed. I fixed it up in my tree, and below is a pull request for
getting this single patch. Please let me know if you want me to send the patch
through email instead.


The following changes since commit 8708aac79e4572ba673d7a21e94ddca9f3abb7fc:

  rtlwifi: rtl8192cu: Add new USB ID (2013-02-08 14:51:43 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.9-3

for you to fetch changes up to cd48d8ba149484c4723a2b75159deeb83f3d2273:

  NFC: microread: Fix mei physical layer (2013-02-11 18:35:36 +0100)

----------------------------------------------------------------
This 3rd NFC pull request for 3.9 contains a fix for the microread MEI
physical layer support, as the MEI bus API changed.

>From the MEI code, we now pass the MEI id back to the driver probe routine,
and we also pass a name and a MEI id table through the mei_bus_driver
structure. A few renames as well like e.g. mei_bus_driver to mei_driver or
mei_bus_client to mei_device in order to be closer to the driver model
practices.

----------------------------------------------------------------
Samuel Ortiz (1):
      NFC: microread: Fix mei physical layer

 drivers/nfc/microread/mei.c |   43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
