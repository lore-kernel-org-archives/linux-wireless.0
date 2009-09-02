Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:18695 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752390AbZIBP4J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2009 11:56:09 -0400
Subject: Re: [PATCH 2.6.31] iwlwifi: Reenable power_level
From: reinette chatre <reinette.chatre@intel.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <cb0375e10909020753o4d314f61k74dd35025f61666a@mail.gmail.com>
References: <cb0375e10909020753o4d314f61k74dd35025f61666a@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 02 Sep 2009 08:56:10 -0700
Message-Id: <1251906970.13180.137.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andy,

On Wed, 2009-09-02 at 07:53 -0700, Andrew Lutomirski wrote:
> Right now, enabling power saving on iwlwifi is impossible, because
> mac80211 won't tell iwlwifi that power saving is on (since
> IEEE80211_HW_SUPPORTS_PS is not set) and iwlwifi will ignore the
> user's power_level setting until mac80211 asks for power saving.
> Setting this flag allows the user to manually enable power saving if
> desired.
> 
> Signed-off-by: Andy Lutomirski <luto@mit.edu>
> 
> ---

nack.

http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2053 and
http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=2051 are two
examples of what happens if power save support is enabled. In addition
to this we are also seeing issues with 4965 that are described in the
commit that disabled powersave in 2.6.31 in the first place
(286d94906587901851906a5e2ddc09bc1a7ba1d9).


> This fixes what looks to me like a regression: power_level used to
> work but now fails silently.  In 2.6.32 I think this code is going
> away, but this patch seems like a safe stopgap measure.

2.6.32 will have power save support disabled also.

Reinette


