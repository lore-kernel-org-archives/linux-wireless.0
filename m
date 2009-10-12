Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49678 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288AbZJLTQs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 15:16:48 -0400
Date: Mon, 12 Oct 2009 15:00:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>
Subject: Re: [PATCH 03/17 v2.6.32 and w-t] iwlwifi: turn off device when
	not used.
Message-ID: <20091012190053.GD2794@tuxdriver.com>
References: <1255119634-3060-1-git-send-email-reinette.chatre@intel.com> <1255119634-3060-5-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1255119634-3060-5-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 09, 2009 at 01:20:20PM -0700, Reinette Chatre wrote:
> From: Ben Cahill <ben.m.cahill@intel.com>
> 
> In some cases (e.g. when mac80211 calls iwl_mac_stop() for suspend or user
> no longer wants device active), device has not been going into low power state
> via __iwl_down().  apm_ops.reset() does not put device into low power state;
> instead it resets the device, then puts it into a powered-up state ready to be
> re-loaded with uCode and re-started.  This has needlessly warmed up user's
> laptops and drained batteries.
> 
> With current architecture in which mac80211 controls device up/down (including
> resetting device after firmware errors), there is no need for apm_ops.reset()
> any more; apm_ops.reset() is basically a combination of apm_ops.stop() and
> apm_ops.init().
> 
> Instead, __iwl_down() now unconditionally places the device into a low-power
> state via apm_ops.stop(). Device may be re-started via __iwl_up() calling
> apm_ops.init() as soon as it may be needed (e.g. quickly for firmware errors),
> but in the meantime, device will stop wasting energy.
> 
> Note that, even in this low power state, if driver re-enables interrupts,
> the device retains the ability to sense the hardware RF-KILL switch, and
> (except for 3945) interrupt the host when it changes.
> 
> Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

It this a regression?  Bug reference?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
