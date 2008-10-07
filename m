Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ewhac.best.vwh.net ([192.220.66.121]:2901 "EHLO
	ewhac.best.vwh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756204AbYJGVhJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2008 17:37:09 -0400
Received: from unknown (HELO ewhac.best.vwh.net) ([127.0.0.1])
          (envelope-sender <ewhac@ewhac.org>)
          by 127.0.0.1 (qmail-ldap-1.03) with SMTP
          for <linux-wireless@vger.kernel.org>; 7 Oct 2008 21:30:28 -0000
Received: from ewhac by walkies.ewhac.org with local (Exim 4.67)
	(envelope-from <ewhac@ewhac.org>)
	id 1KnK8L-0003gL-Tn
	for linux-wireless@vger.kernel.org; Tue, 07 Oct 2008 14:30:21 -0700
Date: Tue, 7 Oct 2008 14:30:21 -0700
From: "Leo L. Schwab" <ewhac@ewhac.org>
To: linux-wireless@vger.kernel.org
Subject: compat-wireless-2.6-old: Can't Load Modules
Message-ID: <20081007213021.GA13525@best.com> (sfid-20081007_233714_240284_C9452545)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	When I tried the latest (last night's) version of
compat-wireless-2.6-old on my 2.6.26 Debian laptop, I got the following
error messages when I tried to 'modprobe iwl3945":

Oct  7 02:20:14 walkies kernel: cfg80211: exports duplicate symbol rfkill_force_state (owned by rfkill)

	Once that happened, there were a series of cascading failures:

Oct  7 02:20:14 walkies kernel: mac80211: Unknown symbol wiphy_register
Oct  7 02:20:14 walkies kernel: mac80211: Unknown symbol wiphy_new
Oct  7 02:20:14 walkies kernel: mac80211: Unknown symbol wiphy_unregister
Oct  7 02:20:14 walkies kernel: mac80211: Unknown symbol ieee80211_radiotap_iterator_init
Oct  7 02:20:14 walkies kernel: mac80211: Unknown symbol __ieee80211_get_channel
Oct  7 02:20:14 walkies kernel: mac80211: Unknown symbol ieee80211_radiotap_iterator_next
Oct  7 02:20:14 walkies kernel: mac80211: Unknown symbol ieee80211_channel_to_frequency
Oct  7 02:20:14 walkies kernel: mac80211: Unknown symbol ieee80211_frequency_to_channel
Oct  7 02:20:14 walkies kernel: mac80211: Unknown symbol wiphy_free
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_free_hw
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_alloc_hw
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_notify_mac
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_register_hw
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_rate_control_unregister
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol __ieee80211_get_radio_led_name
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_wake_queue
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol __ieee80211_get_tx_led_name
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_tx_status_irqsafe
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol __ieee80211_get_rx_led_name
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_wake_queues
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_rate_control_register
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol sta_info_get
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_stop_queue
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_stop_queues
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol __ieee80211_get_assoc_led_name
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_scan_completed
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_channel_to_frequency
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_unregister_hw
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_hdrlen
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_beacon_get
Oct  7 02:20:14 walkies kernel: iwl3945: Unknown symbol ieee80211_rx_irqsafe

	It seems this isn't a new problem, and was pointed out nearly two
months ago:

	http://article.gmane.org/gmane.linux.kernel.wireless.general/19530/

	I have CONFIG_RFKILL=m in my .config, and the module is loaded.
This potential conflict is not mentioned in the README.  Should I alter my
kernel .config to avoid the collision, unload rfkill, or is there a magic
incantation in compat-wireless to avoid the problem?

					Thanks,
					Schwab
