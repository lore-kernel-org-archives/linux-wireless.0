Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:32895 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935882AbdCJMC2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Mar 2017 07:02:28 -0500
Message-ID: <1489147283.22435.14.camel@coelho.fi> (sfid-20170310_130326_451362_D4A039B0)
From: Luca Coelho <luca@coelho.fi>
To: Jens Axboe <axboe@kernel.dk>
Cc: sara.sharon@intel.com, liad.kaufman@intel.com,
        linux-wireless@vger.kernel.org,
        "Coelho, Luciano" <luciano.coelho@intel.com>
Date: Fri, 10 Mar 2017 14:01:23 +0200
In-Reply-To: <fdfbfffa-31c9-7646-82b5-b6a759b73d21@kernel.dk>
References: <f2bedfee-e74f-47d6-9088-94171f0e5538@email.android.com>
         <05fff778-8703-f429-f555-aa533c2df25f@kernel.dk>
         <fdfbfffa-31c9-7646-82b5-b6a759b73d21@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: WARNING: CPU: 1 PID: 23668 at
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c:1539 iwl_mvm_rm_sta+0x3ce/0x450
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jens,

On Thu, 2017-03-09 at 21:41 -0700, Jens Axboe wrote:
> On 03/01/2017 09:10 PM, Jens Axboe wrote:
> > On 03/01/2017 08:33 PM, Luca Coelho wrote:
> > > Hi Jens,
> > > 
> > > On Mar 1, 2017 20:25, Jens Axboe <axboe@kernel.dk> wrote:
> > > 
> > >     Not that folks have been jumping all over this, but in case someone is
> > >     curious, it triggered twice here today. For those two times, the value
> > >     of mvm->pending_frames[sta_id] was 80 and 39, respectively.
> > > 
> > > Sorry for the delay, I'm on vacation now with limited internet access.
> > > But we'll take a look into this early next week at the latest.
> > > 
> > > Thanks a lot for the detailed report!
> > 
> > No worries, thanks for responding. I just wanted to ensure this wasn't
> > dropped on the floor.
> > 
> > BTW, a few more values of ->pending_frames[sta_id]:
> > 
> > $ dmesg | grep "ret="
> > [ 2334.308254] ret=39
> > [ 7915.311828] ret=80
> > [31602.317204] ret=41
> > [32139.510993] ret=54
> > [33292.917759] ret=96
> > 
> > it seems to often happen around resume.
> 
> This is still happening all the time in current -git.

Could you collect traces with trace-cmd, as explained in our wiki[1]?
This will probably help point out the problem.  I know it's a bit
difficult because it appears to happen randomly for you, but it's worth
trying.

--
Cheers,
Luca.
