Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42913 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab1INWxj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 18:53:39 -0400
Received: by wwf22 with SMTP id 22so2849909wwf.1
        for <linux-wireless@vger.kernel.org>; Wed, 14 Sep 2011 15:53:38 -0700 (PDT)
From: Miguel =?iso-8859-15?q?Mart=EDnez?= <el.quark@gmail.com>
Reply-To: el.quark@gmail.com
To: "641424@bugs.debian.org" <641424@bugs.debian.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Bug#641424: iwlagn: fails to reconnect to WPA2-enterprise (Reason: 23)
Date: Wed, 14 Sep 2011 23:53:34 +0100
References: <C5A7FB31FD9AEA42B600BDC3C74F8E00147CB207@orsmsx511.amr.corp.intel.com>
In-Reply-To: <C5A7FB31FD9AEA42B600BDC3C74F8E00147CB207@orsmsx511.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201109142353.35030.el.quark@gmail.com> (sfid-20110915_005342_545240_412BB601)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

OK, thanks for the tip. Debian kernel 3.0.0-1 doesn't have these options 
enabled, so I'll get to know how good the debian kernel build tools are.

$ grep CONFIG_IWLWIFI /boot/config-3.0.0-1-amd64 | grep -i debug
# CONFIG_IWLWIFI_DEBUG is not set
# CONFIG_IWLWIFI_LEGACY_DEBUG is not set

$ grep CONFIG_MAC80211 /boot/config-3.0.0-1-amd64 
CONFIG_MAC80211=m
CONFIG_MAC80211_HAS_RC=y
CONFIG_MAC80211_RC_MINSTREL=y
CONFIG_MAC80211_RC_MINSTREL_HT=y
CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
CONFIG_MAC80211_RC_DEFAULT="minstrel_ht"
CONFIG_MAC80211_MESH=y
CONFIG_MAC80211_LEDS=y
# CONFIG_MAC80211_DEBUGFS is not set
# CONFIG_MAC80211_DEBUG_MENU is not set
CONFIG_MAC80211_HWSIM=m

Also, Ubuntu 10.10 has kernel 2.6.35, with some extra sauce and backports. 
I've seen some mentions of 2.6.38 in the changelogs. The iwlagn entries 
mention only some rfkill changes, though.

Regards,

Miguel
