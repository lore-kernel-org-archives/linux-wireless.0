Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45061 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751632AbaJ0L37 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2014 07:29:59 -0400
Message-ID: <1414409397.2705.198.camel@jrissane-mobl.ger.corp.intel.com> (sfid-20141027_123003_044236_3EA76848)
Subject: Re: [PATCH 0/3] Add mcast event when hwsim radios are created and
 removed
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 27 Oct 2014 13:29:57 +0200
In-Reply-To: <1414408856.3836.3.camel@jlt4.sipsolutions.net>
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141027_114536_599448_FF2C1C5E) <1414408856.3836.3.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On ma, 2014-10-27 at 12:20 +0100, Johannes Berg wrote:
> On Mon, 2014-10-27 at 12:44 +0200, Jukka Rissanen wrote:
> > Hi,
> > 
> > patch 1 renames HWSIM_CMD_CREATE_RADIO to HWSIM_CMD_NEW_RADIO and
> > HWSIM_CMD_DESTROY_RADIO to HWSIM_CMD_DEL_RADIO. They are more
> > fitting on how other pieces of the wireless system work. A define
> > to old name is provided for backward compatibility.
> 
> That seems reasonable, if a little gratuitous.
> 
> > Patches 2 and 3 use the newly named enums and provide a way to inform
> > the listeners on the multicast group "config" when new radio is created
> > and existing radio is deleted.
> 
> Why bother? There are nl80211 events for this already, no?

Yes, but from generic nl80211 event you cannot know if event is from
hwsim radio or not. With this patch, the listener can know that the
radio new/del event is specifically related to hwsim radio.


Cheers,
Jukka


