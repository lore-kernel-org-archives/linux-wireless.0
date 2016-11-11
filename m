Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:55963 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934778AbcKKRWO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 Nov 2016 12:22:14 -0500
To: <linux-wireless@vger.kernel.org>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Subject: [RFC] change mac80211_hwsim tx_rates to ieee80211_tx_rate
Message-ID: <dcc2ec52-abe0-3182-e7f5-d1df40fd492b@uni-rostock.de> (sfid-20161111_182223_315895_6A05EDD8)
Date: Fri, 11 Nov 2016 18:22:01 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we are working on a sophisticated Wifi simulation framework based on
mac80211_hwsim. This includes the simulation of frame transmissions with
realistic channel access and channel conditions. Therefore we need
several information (e.g. long/short gi, usage of RTS/CTS, ...), which
are available on a per frame/rate basis from struct ieee80211_tx_rate.
But this information is thrown away by the conversation to struct
hwsim_tx_rate (eg. in mac80211_hwsim_tx_frame_nl)

Firstly I think this information is valuable and I don't believe, the 4
Byte per frame greatly influences speed. Moreover the explicit double
copy (firstly from the info->status.rates to tx_attempts, secondly by
nla_put), takes longer than simply put the whole info->status.rates into
the netlink message.

So I would propose to put the whole struct into the netlink messages,
but I think that will break up the communication to e.g. bob copelands
wmediumd and similar simulations. I would like to have our
Implementation working with mainline kernels and therefore ask how we
could achieve this easily.

Obviously, we could define another field in the hwsim messages, but as
bob copeland already stated, significantly more information within the
netlink messages could  intensify the timing overhead of hwsim.

Any suggestions?
