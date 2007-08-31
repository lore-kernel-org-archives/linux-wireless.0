Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2574 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761450AbXHaVP3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Aug 2007 17:15:29 -0400
Date: Fri, 31 Aug 2007 16:55:24 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org, Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH V2] Add iwlwifi wireless drivers
Message-ID: <20070831205524.GA11128@tuxdriver.com>
References: <1188192012.13078.177.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1188192012.13078.177.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 27, 2007 at 01:20:12PM +0800, Zhu Yi wrote:

> This is the second version of the patch (still against 2.6.23-rc3) adds
> the mac80211 based wireless drivers for the Intel PRO/Wireless
> 3945ABG/BG Network Connection and Intel Wireless WiFi Link AGN (4965)
> adapters. You can find it from:
> http://intellinuxwireless.org/iwlwifi/v5-Add-iwlwifi-wireless-drivers.patch

A few comments below -- many of them are nits or somewhat minor.
I think the ieee80211_rate.h one needs to be resolved for sure.  Also,
splitting iwl-base.c is definitely worth considering -- building two
object from one source is a bit ugly.

Please respond to the questions/comments, and indicate if/when you
will split iwl-base.c.  Also, let's figure-out what really needs to
be exportd to drivers from ieee80211_rate.h and get that done.

Thanks for the post!

John

--------------------------------------------------------------------------------

Big plus: both drivers work fairly well, and have received a lot of
testing in Fedora (F7 and rawhide).

--------------------------------------------------------------------------------

As others have pointed-out, building two drivers from a single source
is a bit ugly.  I hacked-up a couple of awk scripts to separate this
into two files (btw, let me know if you want them).  It seems the two
files differ by 5-10% (depending on how you score it).  I'm not sure
what the cut-off should be for requiring a split...?

$ wc iwl-base.c
  9565  29226 265696 iwl-base.c

$ wc iwl3945-base.c
  8701  26834 242294 iwl3945-base.c

$ wc iwl4965-base.c
  9197  28016 256601 iwl4965-base.c

FWIW, it looks like some of the header files also use the IWL defintion
for "two objects from one source" compilation.

--------------------------------------------------------------------------------

Nit: does iwl_hw_valid_rtc_data_addr need to be inline?

--------------------------------------------------------------------------------

IWL_DEBUG_RATE("enter\n")
IWL_DEBUG_RATE("leave\n")
IWL_DEBUG_RATE("NOP\n");

Multiples of each of these, particularly in the rate scaling algorithms.
Are these necessary?  Some seem to like them, others don't...

--------------------------------------------------------------------------------

iwl-4965-rs.c:

#include "../net/mac80211/ieee80211_rate.h"

I think this is unacceptable.  Let's figure-out what needs to be
exported to drivers and get it moved to an appopriate header, rather
than just pulling a header from a random location out of the tree.

--------------------------------------------------------------------------------

Same file line 586:

#define IWL_LEGACY_SWITCH_ANTENNA      0
#define IWL_LECACY_SWITCH_SISO         1
#define IWL_LEGACY_SWITCH_MIMO         2

#define IWL_RS_GOOD_RATIO              12800

#define IWL_ACTION_LIMIT               3
#define IWL_LEGACY_FAILURE_LIMIT       160
#define IWL_LEGACY_SUCCESS_LIMIT       480
#define IWL_LEGACY_TABLE_COUNT         160

#define IWL_NONE_LEGACY_FAILURE_LIMIT  400
#define IWL_NONE_LEGACY_SUCCESS_LIMIT  4500
#define IWL_NONE_LEGACY_TABLE_COUNT    1500

#define IWL_RATE_SCALE_SWITCH          (10880)

Shouldn't these be in a header file, or at least at the top of this
file?

--------------------------------------------------------------------------------

Same file line 1115:

#define IWL_SISO_SWITCH_ANTENNA  0
#define IWL_SISO_SWITCH_MIMO     1
#define IWL_SISO_SWITCH_GI       2

Ditto?

--------------------------------------------------------------------------------

Same file line 1210:

#define IWL_MIMO_SWITCH_ANTENNA_A      0
#define IWL_MIMO_SWITCH_ANTENNA_B      1
#define IWL_MIMO_SWITCH_GI             2

Ditto?

--------------------------------------------------------------------------------

Does iwl_rate_index_from_plcp need to be inline?  It seems a bit long,
and called from several places.  (And defined in multiple places...)

--------------------------------------------------------------------------------

iwl-4965.c line 1815:

#define TX_POWER_IWL_ILLEGAL_VDET    -100000
#define TX_POWER_IWL_ILLEGAL_VOLTAGE -10000
#define TX_POWER_IWL_CLOSED_LOOP_MIN_POWER 18
#define TX_POWER_IWL_CLOSED_LOOP_MAX_POWER 34
#define TX_POWER_IWL_VDET_SLOPE_BELOW_NOMINAL 17
#define TX_POWER_IWL_VDET_SLOPE_ABOVE_NOMINAL 20
#define TX_POWER_IWL_NOMINAL_POWER            26
#define TX_POWER_IWL_CLOSED_LOOP_ITERATION_LIMIT 1
#define TX_POWER_IWL_VOLTAGE_CODES_PER_03V       7
#define TX_POWER_IWL_DEGREES_PER_VDET_CODE       11
#define IWL_TX_POWER_MAX_NUM_PA_MEASUREMENTS 1
#define IWL_TX_POWER_CCK_COMPENSATION_B_STEP (9)
#define IWL_TX_POWER_CCK_COMPENSATION_C_STEP (5)

Same as previous "#define in middle of file" comments...

--------------------------------------------------------------------------------

iwl-4965.c line 2800:

#define IWL4965_LEGACY_SWITCH_ANTENNA  0
#define IWL4965_LECACY_SWITCH_SISO             1
#define IWL4965_LEGACY_SWITCH_MIMO             2

#define IWL4965_GOOD_RATIO                     12800

#define IWL_ACTION_LIMIT               3
#define IWL4965_LEGACY_FAILURE_LIMIT   160
#define IWL4965_LEGACY_SUCCESS_LIMIT   480
#define IWL4965_LEGACY_TABLE_COUNT             160

#define IWL4965_NONE_LEGACY_FAILURE_LIMIT      400
#define IWL4965_NONE_LEGACY_SUCCESS_LIMIT      4500
#define IWL4965_NONE_LEGACY_TABLE_COUNT        1500

#define IWL4965_RATE_SCALE_SWITCH  (10880)

Ditto?

--------------------------------------------------------------------------------

There are several more examples like the above -- I'm not going to keep
documenting them...

--------------------------------------------------------------------------------

Otherwise, it mostly seems acceptable.  I think the mac80211 guys
have a few issues -- hopefully they will chime-in here now?

-- 
John W. Linville
linville@tuxdriver.com
