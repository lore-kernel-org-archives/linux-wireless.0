Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35002 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722AbcHKMcS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2016 08:32:18 -0400
Date: Thu, 11 Aug 2016 14:29:18 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Problems with mwifiex_pcie firmware activation
Message-ID: <20160811122917.GB27059@redhat.com> (sfid-20160811_143222_092573_F82C5CF5)
References: <20160614135015.GB4962@redhat.com>
 <b881b09bf5384169ba1038af71fd435a@SC-EXCH04.marvell.com>
 <20160616115315.GB21199@redhat.com>
 <20160623120952.GA11157@redhat.com>
 <20160811090113.GA27059@redhat.com>
 <f5b2566be31743809217833e76060d42@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f5b2566be31743809217833e76060d42@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

On Thu, Aug 11, 2016 at 10:21:58AM +0000, Amitkumar Karwar wrote:
> > -----Original Message-----
> > From: Stanislaw Gruszka [mailto:sgruszka@redhat.com]
> > Sent: Thursday, August 11, 2016 2:31 PM
> > To: Amitkumar Karwar
> > Cc: Nishant Sarmukadam; linux-wireless@vger.kernel.org
> > Subject: Re: Problems with mwifiex_pcie firmware activation
> > 
> > On Thu, Jun 23, 2016 at 02:09:52PM +0200, Stanislaw Gruszka wrote:
> > > On Thu, Jun 16, 2016 at 01:53:15PM +0200, Stanislaw Gruszka wrote:
> > > > On Wed, Jun 15, 2016 at 01:47:53PM +0000, Amitkumar Karwar wrote:
> > > > > Could you please share complete dmesg log for failure and
> > successful cases?
> > > >
> > > > Dmesg from failure case is in attachment. I loose access to system
> > > > where device initalize, I'll provide missed dmesg when I get back
> > > > the access.
> > >
> > > Have the access now, dmesg is in attachment.
> > 
> > Any news here ?
> 
> Do you have below patch included? It increases poll count which may help in your case.
> https://patchwork.kernel.org/patch/7973951/

Yes, I have that patch. 

To clarify the issue: reverting above patch seems to helps with the
problem. That what I basically did on first of my systems with mwifiex,
that did not work similarly like second one. However I did not revert
the patch but just comment out check_winner_status: 

@@ -755,7 +755,7 @@ int mwifiex_dnld_fw(struct mwifiex_adapter *adapter,
        }
 
        /* check if we are the winner for downloading FW */
-       if (adapter->if_ops.check_winner_status) {
+       if (false) {
                adapter->winner = 0;
                ret = adapter->if_ops.check_winner_status(adapter);
 
After running modified kernel once, the problem was gone on
unmodified kernel! I suppose that once new firmware was uploaded to
the device it somehow modify it (change it's internal firmware?) and make
check_winner_status() works correctly. This is strange, but I can not
find any other explanation and don't see any other changes in the
first system that makes mwifiex suddenly work.

I could be wrong, but I suppose somebody who use pre 4.6 kernel (without
the above patch committed as: 2fd5c6ed0b4fbf3c2d9314a24c82862ce5254d42
"mwifiex: firmware download enhancements") with new enough mwifiex
firmware, will not see the problem even after kernel update. But if
somebody install 4.6 or newer kernel on pristine hardware, the device
will not work.

Thanks
Stanislaw
