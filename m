Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:43459 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbYLIBqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 20:46:20 -0500
From: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
To: David Shwatrz <dshwatrz@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 8 Dec 2008 17:45:43 -0800
Subject: RE: Three short questions about iwlwifi
Message-ID: <7C88852EF6F99F4EB538472FCFEBE2220422435C@orsmsx509.amr.corp.intel.com> (sfid-20081209_024625_221703_E7B0E436)
References: <31436f4a0812072238x5d7a2cc8saeec3eb44726b0c7@mail.gmail.com>
In-Reply-To: <31436f4a0812072238x5d7a2cc8saeec3eb44726b0c7@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello David,

  We are currently working on porting the iwl3945 driver to iwlwifi driver.
You can expect few patches in couple of days.


Abhijeet


-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of David Shwatrz
Sent: Sunday, December 07, 2008 10:38 PM
To: linux-wireless@vger.kernel.org
Subject: Three short questions about iwlwifi

Hello,

I tried to delve into the iwlwifi code and I have
3 short questions about iwlwifi; I hope that I can get some advice here.


1) I see that there seems to be common code in 3945 and agn.
Are there intentions to make use of agn in 3945 in the future to avoid
code duplication, or is it a design decision to make a full separation between
3945 and agn (so even when it is possible to use common code, to avoid
it in order
not to cause possible problems in the future).

2)  In some places in iwlwifi we have:
#ifdef IEEE80211_CONF_CHANNEL_SWITCH.

For example, iwl-agn.c or iwl3945-base.c.
What is this define ? is it not (an uneeded) legacy from when the drivers
were not part of the tree?

3) Little question about implementation:

In iwl3945-base.c:
iwl3945_commit_rxon() calls iwl3945_clear_stations_table(priv);
so is it necessary in iwl3945_set_mode() to call also
iwl3945_clear_stations_table() , since we anyhow call iwl3945_commit_rxon()
afterwards ?
the only thing iwl3945_clear_stations_table() does is zeros
priv->num_stations and zeros priv->stations.

David S
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
