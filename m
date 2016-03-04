Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:60930 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751431AbcCDTpg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2016 14:45:36 -0500
Message-ID: <1457120732.28365.166.camel@coelho.fi> (sfid-20160304_204540_682129_2AB773BE)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: linux-wireless@vger.kernel.org,
	Matti Gottlieb <matti.gottlieb@intel.com>
Date: Fri, 04 Mar 2016 21:45:32 +0200
In-Reply-To: <87povaw7jc.fsf@kamboji.qca.qualcomm.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32EA41983@hasmsx107.ger.corp.intel.com>
	 <1456433829-20285-2-git-send-email-emmanuel.grumbach@intel.com>
	 <87povaw7jc.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 2/2] iwlwifi: mvm: Fix paging memory leak
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On Fri, 2016-03-04 at 18:07 +0200, Kalle Valo wrote:
> Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:
> 
> > From: Matti Gottlieb <matti.gottlieb@intel.com>
> > 
> > If the opmode is stopped and started again we did not free
> > the paging buffers. Fix that.
> > In addition when freeing the firmware's paging download
> > buffer, set the pointer to NULL.
> > 
> > Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
> > Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> 
> Nitpicking while writing the pull request for Dave:
> 
> What does "opmode is stopped" mean? Important bug fixes should have a
> clear bug description from user's point of view. Using driver internal
> jargon is gibberish to most people.

I agree that there could be a bit more high-level description here, but
I also think it's good to keep a bit more details about what is
happening internally, so that developers understand too. ;)

Do you think it would be acceptable to keep the commit log most as it
is, but start with something like "Some paging buffers were not freed
when the driver is restarted."? I don't mean to change this commit
itself, but just so that we know how to please you (and users) while
still keeping the details as part of the commit logs... ;)


> I investigated this myself and apparently "opmode" is stopped when the
> module is unloaded or the PCI device is removed. So just say that in the
> commit log and everyone understand much better.

Our driver is divided roughly into two layers: the bus layer (called
transport) and the protocol layer (called opmode).  The name comes from
the difference between the two opmodes that we currently have.  One
supports only a single operating channel (dvm) and the other supports
multiple operating channels (mvm).

Hope this clarifies a bit. :)

--
Cheers,
Luca.
