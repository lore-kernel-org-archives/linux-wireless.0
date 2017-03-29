Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:56276 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755445AbdC2LyF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 29 Mar 2017 07:54:05 -0400
To: <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Subject: Get Number of Pending Wifi Frames in Mesh ALM calc
Message-ID: <d3ba693c-796f-88c7-b56e-52a54d228389@uni-rostock.de> (sfid-20170329_135445_884570_5A5ED250)
Date: Wed, 29 Mar 2017 13:54:02 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

we investigate a possibility to enrich the ALM with information about a
possible delay caused by buffering in all nodes along a mesh path. This
could better reflect the idea of an real "airtime" of a new send frame.
Therefore I'm searching for a general way to get the number of
outstanding frames of an mac80211 based wifi-driver.

I think it could be possible to count the number of one of the
skb_queues in struct ieee80211_local. Maybe there is also a possibility
to use the new codel infrastructure in mac80211 to get a impression
about buffered frames of a wiphy, but I think this would only work on
flow end-points, but we need a metric estimation on every node. Do
anybody know whether I'm right at this point ?

We will test our implementation on ath9k cards as well as on
mac80211_hwsim simulation, therefore it should work at least on this
both :-)

The nice thing could be, to combine end point regulation methods with
regulating parameters on nodes on the forwarding path to get better
throughput in mesh networks.


kind regards

-- 
M.Sc. Benjamin Beichler

Universität Rostock, Fakultät für Informatik und Elektrotechnik
Institut für Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Straße 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/
