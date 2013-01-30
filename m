Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50920 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689Ab3A3TpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 14:45:24 -0500
Date: Wed, 30 Jan 2013 14:34:19 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	Arend van Spriel <arend@broadcom.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 0/7] Improvements to software scanning
Message-ID: <20130130193419.GG2167@tuxdriver.com> (sfid-20130130_204527_683854_CABCB670)
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 29, 2013 at 05:47:28PM -0600, Seth Forshee wrote:
> This patch series fixes a number of problems observed during software
> scanning, as described in [1].
> 
> The first four patches implement improved queue handling during
> off-channel operation and add some needed flushing of the hardware
> queues, as suggested by Johannes in [2]. This includes adding a new
> queue stop reason of off-channel operation, a transmit path for frames
> which do need to be transmitted when off-channel, and some improvements
> in error handling.
> 
> The last three fix a problem specific to brcmsmac (and likely b43,
> though I don't have hardware for testing b43). Broadcom hardware
> actively clears the PM bit in frame control whenever the hardware is not
> configured correctly, and since wireless drivers have no knowledge of
> off-channel powersave such configuration cannot be done. The patches
> expand the driver powersave configuration with an off-channel state and
> update brcmsmac to make use of it.
> 
> Johannes: I have a couple of comments/questions for you related to these
> patches.
> 
> First, in the patches I've added an offchan_tx_ok argument to the tx
> operations, but this seems a little awkward to me since it has to be
> propogated down through a fairly deep call stack. The alternative idea
> that occurred to me is to use a tx control flag, but that seems to be
> pretty crowded. Any thoughts?
> 
> Second, I attempted to test these patches with iwlwifi (Centrino
> Advanced-N 6235) to verify that I didn't break anything for drivers with
> hw scanning. My standard test for this involves running iperf while
> triggering nearly continuous scans, but I'm seeing lots of problems
> running a tcp iperf test even with unpatched 3.8-rc4. iperf with udp
> does fine in either direction. I haven't had time to do any kind of
> debugging yet, but I thought you'd want to know.
> 
> Thanks,
> Seth
> 
> [1] http://marc.info/?l=linux-wireless&m=135766865110986&w=2
> [2] http://marc.info/?l=linux-wireless&m=135838252227053&w=2
> 
> 
> Seth Forshee (7):
>   mac80211: Return a status for tx operations
>   mac80211: Fix tx queue handling during scans
>   mac80211: Improve error handling for off-channel operation
>   mac80211: Add flushes before going off-channel
>   mac80211: Expand powersave configuration flag to be two bits
>   mac80211: Add off-channel powersave state
>   brcmsmac: Add support for off-channel powersave

Johannes,

Please take the brcsmac patch through your tree if/when you take
the others.

Thanks!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
