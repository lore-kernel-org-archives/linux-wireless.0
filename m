Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37705 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbaE1NRc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 09:17:32 -0400
Message-ID: <1401283040.8146.15.camel@jlt4.sipsolutions.net> (sfid-20140528_151735_954151_AD208064)
Subject: Re: [RFC Patch v2] Unify mpp/mesh_path handling for Mac 802.11s
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>,
	Thomas Pedersen <thomas@noack.us>
Date: Wed, 28 May 2014 15:17:20 +0200
In-Reply-To: <2083629.VLZzpqGjAs@desktop.local> (sfid-20140528_123454_081662_DB061595)
References: <2083629.VLZzpqGjAs@desktop.local>
	 (sfid-20140528_123454_081662_DB061595)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-05-28 at 12:34 +0200, Henning Rogge wrote:
> Hi,
> 
> I looked a little bit more into the 802.11s mesh code to see if there is still
> a chance for unifying some code without forcing the issue as the last patch
> did.
> 
> The result was the attached patch, which still needs one "if (mpp) ... else"
> block but unifies most of the code for mpp_path_add() and mesh_path_add().
> 
> If this is still too much I would suggest leaving the mesh_pathtbl code as it is.
> 
> While looking through the code I noticed that there seems to be no code-path
> that removes stall mpp_path entries (except for the removal of the mesh
> interface) ! Unless I overlooked something this would be a way to use up all
> existing memory of the kernel by sending it 802.11s packets with changing
> proxied addresses.
> 
> I have added an atomic counter to restrict the number of proxied paths
> (similar to the restriction of the mesh paths), but I am not convinced that
> this would be enough. There needs to be some timeout mechanism, but resetting
> the timeout of a MPP every times we receive an unicast from it sounds
> expensive.

Can you not do everything in one patch? :)

Also - I think reporting the MPPs to userspace like the mesh paths is
probably not a good idea? And I think that happens now since you didn't
touch the code in cfg?

johannes

johannes

