Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4085 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755212AbZICPTv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 11:19:51 -0400
Subject: Re: [PATCH 2/2] ath9k: Fix channelFlags for 2GHZ
From: Pavel Roskin <proski@gnu.org>
To: Sujith <Sujith.Manoharan@atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <19103.25725.707217.596352@gargle.gargle.HOWL>
References: <19103.25725.707217.596352@gargle.gargle.HOWL>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 11:19:47 -0400
Message-Id: <1251991187.6521.22.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-09-03 at 12:08 +0530, Sujith wrote:
> CHANNEL_G has to be set for 2GHZ channels since
> IS_CHAN_G() checks for this in channelFlags and not in
> chanmode. To make things messier, ath9k_hw_process_ini()
> checks for CHANNEL_G in chanmode and not in channelFlags.
> The supreme, brain-searing fix is to set the
> flag in both cases.

My impression is that's a workaround for a bug that lies elsewhere.  I
don't think we should apply such patches.

chanmode and channelFlags seem to duplicate each other.  I would use an
enum for distinctive allowed modes and macros to query if the particular
mode has a specific feature (band, modulation, bandwidth etc).

The enum could use ORed constants for optimization, but such constants
should be used only through the macros.

-- 
Regards,
Pavel Roskin
