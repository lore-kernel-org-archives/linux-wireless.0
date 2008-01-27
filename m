Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0910.google.com ([209.85.198.191]:51029 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbYA0Ld4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2008 06:33:56 -0500
Received: by rv-out-0910.google.com with SMTP id k20so1353488rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Jan 2008 03:33:55 -0800 (PST)
Message-ID: <c85cb4470801270333r618e53a1yf1fdf118d48b93a8@mail.gmail.com> (sfid-20080127_113403_141479_3B03D89F)
Date: Sun, 27 Jan 2008 13:33:55 +0200
From: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
To: "John Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Subject: RFC: unified BSS configuration approach
Cc: "Winkler, Tomas" <tomas.winkler@intel.com>,
	"Ivo van Doorn" <ivdoorn@gmail.com>, mb@bu3sch.de, dsd@gentoo.org,
	linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone

few weeks ago Johannes published a patch based on my RFC "mac80211:
add unified BSS configuration", introducing a new op from mac80211 to
low-level driver "bss_info_changed", that delivers BSS IE changes and
assoc status information.
What we had originally in mind was that this op should eventually
replace previous ops calls for erp (uses "erp_ie_changed") ,wmm (uses
"conf_tx") and ht (uses "conf_ht"), all of them doing the same -
inform low-level driver about configuration of the BSS, based on the
IE in beacon or in assoc response. This approach is reflected in the
comment inside mac80211.h:

* @bss_info_changed: Handler for configuration requests related to BSS
* parameters that may vary during BSS's lifespan, and may affect low
* level driver (e.g. assoc/disassoc status, erp parameters).
* This function should not be used if no BSS has been set, unless
* for association indication. The @changed parameter indicates which
* of the bss parameters has changed when a call is made. This callback
* has to be atomic.

Now, there are several issues that I want to address regarding current status:

A)  erp_ie_changed and conf_tx were used not only to inform about BSS
changes, but in init flows as well, in order to config low-level
driver for an initial configuration, for instance in
"ieee80211_reset_erp_info", that is called both in
"ieee80211_set_associated" (assoc flow), and in "ieee80211_open" (init
flow)
B) If we decide to skip this initial sync problems may occur, as
initial status of mac80211 and low-level driver may be different.
C) yet, there is no need to make changes from beacons when we are not
associated, as our association may influence the beacons.
D) also, configuration should not be applied to low-level driver while
scanning as well, even though beacons/probe responses are inspected.
E) support to user space configuration is needed, e.g. AP mode
(although here we may use the fact that AP mode is always in a kind of
"associated" mode)

So, your comments are needed to what is the preferred approach:

1 - change the original intention of bss_info_changed so mac80211 will
be able to set low-level driver in the "init" or "configure" flows as
well, not only as BSS is formed or changes
2 - maintain original intention, use "bss_info_changed" only when we
want to deliver BSS configuration when we get associate or during
association state,  and deliver all initial configuration info through
different ops

I am not stating any of my own pro/cons yet, as I would like to hear
your opinion first, but once we get to a decision we should stick to
it, so low-level drivers will not suffer in the future...
Thanks
Ron
