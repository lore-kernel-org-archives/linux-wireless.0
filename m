Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coco.cs.washington.edu ([128.208.3.82]:56603 "EHLO
	coco.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719Ab0CIWFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 17:05:39 -0500
Subject: Re: [ipw3945-devel] iwl4965: 11a channels disabled in current  wireless-testing
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Daniel Halperin <dhalperi@cs.washington.edu>
In-Reply-To: <43e72e891003040931n2dbd3c9cgdfbdcf1091adfe67@mail.gmail.com>
Date: Tue, 9 Mar 2010 14:05:29 -0800
Cc: reinette chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
Message-Id: <33ED094E-EFBC-4BAD-B9F4-4C81BCEE9537@cs.washington.edu>
References: <201002281534.11656.helmut.schaa@googlemail.com>  <201003011927.53208.helmut.schaa@googlemail.com> <43e72e891003011059v564931e2qfe390657b698c277@mail.gmail.com>  <201003022047.10196.helmut.schaa@googlemail.com> <1267640304.15761.121.camel@rchatre-DESK>  <03690D90-3C5E-4E37-8BC6-7EE6FE0B4E1D@cs.washington.edu> <1267651173.15761.155.camel@rchatre-DESK>  <0A6DB552-23FC-46ED-9326-60EB0370C062@cs.washington.edu> <C2DE0F0B-F62A-47BC-A719-E8A598146776@cs.washington.edu> <43e72e891003040931n2dbd3c9cgdfbdcf1091adfe67@mail.gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mar 4, 2010, at 9:31 AM, Luis R. Rodriguez wrote:

> On Thu, Mar 4, 2010 at 2:24 AM, Daniel Halperin
> <dhalperi@cs.washington.edu> wrote:
>> On Mar 3, 2010, at 2:54 PM, Daniel Halperin wrote:
> 
>> My hypothesis as to why this code used to work is that I was using the CONFIG_WIRELESS_OLD_REGULATORY.
> 
> Can you test the same by disabling CONFIG_WIRELESS_OLD_REGULATORY ?

I am no longer using CONFIG_WIRELESS_OLD_REGULATORY; in fact I believe that kernel option has been removed. I don't have any old versions around any more unfortunately to test this hypothesis with.

> There is a way for a driver to claim a custom world regulatory domain,
> this can be done wiphy_apply_custom_regulatory(), ath/regd.c uses
> that. Otherwise indeed the pegged regulatory domain will be used as a
> basis for disabling further channels.

It turns out that disabling WIPHY_FLAG_STRICT_REGULATORY:

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2632,7 +2632,7 @@ static int iwl_mac_setup_register(struct iwl_priv *priv)
                BIT(NL80211_IFTYPE_STATION) |
                BIT(NL80211_IFTYPE_ADHOC);
 
-       hw->wiphy->flags |= WIPHY_FLAG_STRICT_REGULATORY |
+       hw->wiphy->flags |= //WIPHY_FLAG_STRICT_REGULATORY |
                            WIPHY_FLAG_DISABLE_BEACON_HINTS;
 
        /*

also fixes the problem; in reality this is a hack. It does seem to keep the proper driver-set regulatory limits even when I switch modes or channels or CRDA domains. This is because iwl_mac_setup_register() happens after the eeprom is read in iwl-agn.c, and thus the regulatory flags (chan->orig_flags) are pegged and thus stay set properly throughout the run. But it seems like the right approach is actually to do what ath/regd.c does and apply the custom regulatory domain.

Right now, iwlwifi sets WIPHY_FLAG_STRICT_REGULATORY but never sends the custom regulatory domain and so all CRDA requests are ignored by the checks in <base>/net/wireless/reg.c:handle_channel. (Until iwlagn, but not cfg80211, is reloaded).

Dan