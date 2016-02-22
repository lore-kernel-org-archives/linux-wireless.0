Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbcBVRAW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 12:00:22 -0500
Message-ID: <1456160420.16083.3.camel@redhat.com> (sfid-20160222_180042_877820_ADA2B17E)
Subject: Re: [PATCHv2 00/10] RFKill airplane-mode indicator
From: Dan Williams <dcbw@redhat.com>
To: =?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: "David S. Miller" <davem@davemloft.net>,
	Darren Hart <dvhart@infradead.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	platform-driver-x86@vger.kernel.org, linux-api@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux@endlessm.com,
	=?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita
	<jprvita@endlessm.com>
Date: Mon, 22 Feb 2016 11:00:20 -0600
In-Reply-To: <1456159001-20307-1-git-send-email-jprvita@endlessm.com>
References: <1456159001-20307-1-git-send-email-jprvita@endlessm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-02-22 at 11:36 -0500, João Paulo Rechi Vita wrote:
> This series implements an airplane-mode indicator LED trigger, which
> can be
> used by platform drivers. The default policy have have airplane-mode
> set when
> all the radios known by RFKill are OFF, and unset otherwise. This
> policy can be
> overwritten by one single userspace application at a time using the
> operations
> _AIRPLANE_MODE_INDICATOR_ACQUIRE and _AIRPLANE_MODE_INDICATOR_CHANGE.
> 
Double-check your commit messages on some of these patches; they didn't
get updated to add INDICATOR.

Dan

> When the
> airplane-mode indicator state changes, userspace gets notifications
> through the
> RFKill control misc device (/dev/rfkill).
> 
> The series also contains a few general fixes and improvements to the
> subsystem.
> 
> Additionally, I have a couple of patches to have this feature
> supported by the
> userspace tool 'rfkill' [1]. Should I use a different subject prefix
> to help
> separate those from kernel patches in linux-wireless?
> 
> [1] https://wireless.wiki.kernel.org/en/users/documentation/rfkill
> 
> João Paulo Rechi Vita (10):
>   rfkill: Improve documentation language
>   rfkill: Remove extra blank line
>   rfkill: Point to the correct deprecated doc location
>   rfkill: Move "state" sysfs file back to stable
>   rfkill: Factor rfkill_global_states[].cur assignments
>   rfkill: Add documentation about LED triggers
>   rfkill: Create "rfkill-airplane-mode" LED trigger
>   rfkill: Use switch to demux userspace operations
>   rfkill: Userspace control for airplane mode
>   rfkill: Notify userspace of airplane-mode state changes
> 
>  Documentation/ABI/obsolete/sysfs-class-rfkill |  20 ----
>  Documentation/ABI/stable/sysfs-class-rfkill   |  27 ++++-
>  Documentation/rfkill.txt                      |  17 +++
>  include/uapi/linux/rfkill.h                   |   6 +
>  net/rfkill/core.c                             | 162
> ++++++++++++++++++++------
>  5 files changed, 173 insertions(+), 59 deletions(-)
>  delete mode 100644 Documentation/ABI/obsolete/sysfs-class-rfkill
> 
