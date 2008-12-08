Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:15656 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135AbYLHGiM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 01:38:12 -0500
Received: by fg-out-1718.google.com with SMTP id 19so878622fgg.17
        for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 22:38:10 -0800 (PST)
Message-ID: <31436f4a0812072238x5d7a2cc8saeec3eb44726b0c7@mail.gmail.com> (sfid-20081208_073816_486033_D5031F74)
Date: Mon, 8 Dec 2008 08:38:10 +0200
From: "David Shwatrz" <dshwatrz@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Three short questions about iwlwifi
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
