Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f193.google.com ([209.85.221.193]:39087 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbZGASYj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 14:24:39 -0400
MIME-Version: 1.0
In-Reply-To: <20090701002838.GA7100@kroah.com>
References: <20090701002838.GA7100@kroah.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 1 Jul 2009 11:24:21 -0700
Message-ID: <43e72e890907011124o50fc6932k98bc2605a07947a0@mail.gmail.com>
Subject: Re: [Stable-review] [patch 000/108] 2.6.30-stable review
To: Greg KH <gregkh@suse.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
	akpm@linux-foundation.org, torvalds@linux-foundation.org,
	stable-review@kernel.org, alan@lxorguk.ukuu.org.uk,
	ath9k-devel@lists.ath9k.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2009 at 5:28 PM, Greg KH<gregkh@suse.de> wrote:
> This is the start of the stable review cycle for the 2.6.30.1 release.

> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let us know.  If anyone is a maintainer of the proper subsystem, and
> wants to add a Signed-off-by: line to the patch, please respond with it.

>  drivers/net/wireless/ath5k/base.c         |    7 ++
>  drivers/net/wireless/ath9k/calib.c        |   67 ++++++----------
>  drivers/net/wireless/ath9k/main.c         |   28 +++++---
>  drivers/net/wireless/ath9k/pci.c          |   18 +++++
>  drivers/net/wireless/ath9k/regd.c         |    2 +-
>  drivers/net/wireless/ath9k/xmit.c         |    5 +-

>  net/mac80211/rc80211_minstrel.c           |    2 +-
>  net/wireless/nl80211.c                    |   26 +++++--
>  net/wireless/reg.c                        |   10 ++-

Cc'ing linux-wireless.

14 of the 108 patches for 2.6.30.1 are for wireless. Here they are [1]:

[patch 062/108] mac80211: fix minstrel single-rate memory corruption

[patch 063/108] cfg80211: fix for duplicate userspace replies
[patch 064/108] cfg80211: cleanup return calls on nl80211_set_reg()
[patch 065/108] cfg80211: return immediately if num reg rules >
NL80211_MAX_SUPP_REG_RULES
[patch 066/108] cfg80211: fix in nl80211_set_reg()

[patch 067/108] ath9k: Fix bug when using a card with a busted EEPROM
[patch 068/108] ath9k: Fix bug in calibration initialization
[patch 069/108] ath9k: Fix bug in determining calibration support
[patch 070/108] ath9k: Fix bug in checking HT flag
[patch 071/108] ath9k: Fix bug in scan termination
[patch 072/108] ath9k: Fix memleak on TX DMA failure
[patch 073/108] ath9k: Initialize ANI timers
[patch 074/108] ath9k: Fix PCI FATAL interrupts by restoring
RETRY_TIMEOUT disabling

[patch 088/108] ath5k: avoid PCI FATAL interrupts by restoring
RETRY_TIMEOUT disabling

All these look good. I can think of one fix which didn't make it, the
wext netlink fix for event sending which leaks 4 bytes of
uninitialized data. It didn't make it to stable as Johannes noted its
been broken for ages. I actually don't agree that's a good argument to
not fix it in stable as it can be fixed with a one-liner but whatever,
for details see the tread [2].

Only funny thing I did notice was that the revert for the PCI fatal
stuff for ath5k was for PCI resume, whereas ath9k had it for both
probe and resume. I did check and reason for this was that the
original ath5k patch only removed the 0x41 0 write on resume.

If there are any other patches missed for 2.6.31.1 please send to
stable@kernel.org by following the guidelines on
Documentation/stable_kernel_rules.txt for them to be queued up for
review for 2.6.31.2.

[1] http://linux.kernel.org/mailman/private/stable-review/2009-July/thread.html
[2] http://thread.gmane.org/gmane.linux.kernel.wireless.general/34960

  Luis
