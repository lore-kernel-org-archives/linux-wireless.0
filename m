Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325Ab1DSLmp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2011 07:42:45 -0400
Date: Tue, 19 Apr 2011 13:41:59 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Daniel Halperin <dhalperi@cs.washington.edu>
Subject: Re: [PATCH wireless-2.6] iwlwifi: fix frame injection for HT channels
Message-ID: <20110419114158.GA3445@redhat.com>
References: <1303141291-902-1-git-send-email-wey-yi.w.guy@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1303141291-902-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 18, 2011 at 08:41:31AM -0700, Wey-Yi Guy wrote:
> From: Daniel Halperin <dhalperi@cs.washington.edu>
> 
> For some reason, sending QoS configuration causes transmission to stop
> after a single frame on HT channels when not associated. Removing the
> extra QoS configuration has no effect on station mode, and fixes
> injection mode.
> 
> Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
> Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> ---
> these patches are also available from wireless-2.6 branch on
>  git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git

This is basically revert of:

commit 35a6eb36520b938742d8680fd8d821df20982ced
Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Date:   Wed Nov 10 09:56:43 2010 -0800

    iwlwifi: resending QoS command when HT changes
    
    "mac80211: Fix WMM driver queue configuration"
    inadvertedly broke iwlwifi, because now mac80211
    configures the QoS settings before assoc, and
    therefore before HT. Thus, iwlwifi no longer told
    the device about the HT setting, which it needs
    to -- and thus throughput went down a lot. Fix
    this by resending the QoS command to the device
    not only when QoS/WMM settings change, but also
    when HT changes.

Does problem that 35a6eb36520b938742d8680fd8d821df20982ced fixed
gone now? How?

Stanislaw
