Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41207 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbZGUPpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 11:45:54 -0400
Date: Tue, 21 Jul 2009 11:44:17 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Subject: Re: [PATCH 2.6.31] iwlagn: fix minimum number of queues setting
Message-ID: <20090721154417.GB2721@tuxdriver.com>
References: <1247848476-24185-1-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1247848476-24185-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 17, 2009 at 09:34:36AM -0700, Reinette Chatre wrote:
> From: Reinette Chatre <reinette.chatre@intel.com>
> 
> We need to provide a reasonable minimum that will result in a
> working setup if used. Set minimum to be 10 to provide for
> 4 standard TX queues + 1 command queue + 2 (unused) HCCA queues +
> 4 HT queues (one per AC).
> 
> We allow the user to change the number of queues used via a module
> parameter and use this minimum value to check if it is valid. Without
> this patch a user can select a value for the number of queues that
> will result in a failing setup.
> 
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> Reviewed-by: Tomas Winkler <tomas.winkler@intel.com>
> Acked-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> This patch has already been submitted for wireless-testing, but we would
> like to include this fix into 2.6.31 also if possible.
> 
> This fixes http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2011

When built against 2.6.31, I get this:

  CC [M]  drivers/net/wireless/iwlwifi/iwl3945-base.o
In file included from drivers/net/wireless/iwlwifi/iwl3945-base.c:55:
drivers/net/wireless/iwlwifi/iwl-3945.h:115:1: warning: "IWL_MIN_NUM_QUEUES" redefined
In file included from drivers/net/wireless/iwlwifi/iwl-3945.h:48,
                 from drivers/net/wireless/iwlwifi/iwl3945-base.c:55:
drivers/net/wireless/iwlwifi/iwl-dev.h:264:1: warning: this is the location of the previous definition
  CC [M]  drivers/net/wireless/iwlwifi/iwl-3945.o
In file included from drivers/net/wireless/iwlwifi/iwl-3945.c:45:
drivers/net/wireless/iwlwifi/iwl-3945.h:115:1: warning: "IWL_MIN_NUM_QUEUES" redefined
In file included from drivers/net/wireless/iwlwifi/iwl-3945.h:48,
                 from drivers/net/wireless/iwlwifi/iwl-3945.c:45:
drivers/net/wireless/iwlwifi/iwl-dev.h:264:1: warning: this is the location of the previous definition
  CC [M]  drivers/net/wireless/iwlwifi/iwl-3945-rs.o
In file included from drivers/net/wireless/iwlwifi/iwl-3945-rs.c:40:
drivers/net/wireless/iwlwifi/iwl-3945.h:115:1: warning: "IWL_MIN_NUM_QUEUES" redefined
In file included from drivers/net/wireless/iwlwifi/iwl-3945.h:48,
                 from drivers/net/wireless/iwlwifi/iwl-3945-rs.c:40:
drivers/net/wireless/iwlwifi/iwl-dev.h:264:1: warning: this is the location of the previous definition
  CC [M]  drivers/net/wireless/iwlwifi/iwl-3945-led.o
In file included from drivers/net/wireless/iwlwifi/iwl-3945-led.c:43:
drivers/net/wireless/iwlwifi/iwl-3945.h:115:1: warning: "IWL_MIN_NUM_QUEUES" redefined
In file included from drivers/net/wireless/iwlwifi/iwl-3945.h:48,
                 from drivers/net/wireless/iwlwifi/iwl-3945-led.c:43:
drivers/net/wireless/iwlwifi/iwl-dev.h:264:1: warning: this is the location of the previous definition

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
			¡Viva Honduras Libre!
