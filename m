Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge01.uni-rostock.de ([139.30.8.12]:7356 "EHLO
        edge01.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755900AbdIHO2D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Sep 2017 10:28:03 -0400
Content-Type: text/plain; charset="UTF-8"
From: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
To: <linux-wireless@vger.kernel.org>
CC: Johannes Berg <johannes@sipsolutions.net>,
        Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Subject: [RFC 0/4] mac80211_hwsim: improvements for wmediumd-like simulations and config enhancements 
Date: Fri, 8 Sep 2017 16:28:11 +0200
MIME-Version: 1.0
Message-ID: <43d57aa3-ee13-4bea-89b0-9d3bc063f595@MAIL1.uni-rostock.de> (sfid-20170908_162853_386061_1946FF93)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series includes our efforts for more sophisticated simulations for 
wifi-networks.
 
Especially Patch 2 and 4 add missing functionality. 

The patch 1 adds an obvious performance improvement for many radios, since for 
every received frame a linear search through all radios is done. Currently the
simple hashlist implementation without dynamic buckets is used, maybe the hash
size is discussable further, but I put no great effort into finding some 
special value. Moreover, I didn't measured the utilization of the buckets, but
the worst case would be the same performance as before, if we don't count the
hashing.

Patch 2 adds the rate flags, as already discussed some time ago, to be able to
interpret the right Rate from the tx rates array (e.g. whether it is a MCS and
so on). Maybe some of the generated warnings are discussable, but I don't 
know, what the aimed behavior is. Tx-info is a big union, where the rates stay
at the same memory position, therefore the corresponding flags may/should not
change in the driver, but what happens if they did? A short search showed, that
many drivers handle it different ways and the currently only user of 
tx-attempts is minstrel_ht, which ignores the flags of a rate.

Patch 3 is only for clarification, but implications are, that currently the 
locking of hwsim radios is not needed at all, since after creation of radios 
only netlink messages may change the state and netlink callbacks are not 
concurrently called, therefore we could reduce locking. On the other hand, we
could enable parallel execution, which may improve environments with multiple
wmediumd instances in different namespaces, since currently they are blocked
against each other.

Patch 4 helps to create conveniently new radios with specific IDs (with their
corresponding MAC-Addresses) since it is crucial in a setup with many mobile
nodes, to create the nodes when they are in the focus of the simulation and
remove them, if they leave and maybe recreate them if they re-arrive.

Signed-off-by: Benjamin Beichler <benjamin.beichler@uni-rostock.de>

--

drivers/net/wireless/mac80211_hwsim.c | 290 ++++++++++++++++++++++++++------
 drivers/net/wireless/mac80211_hwsim.h |  67 ++++++++
 2 files changed, 305 insertions(+), 52 deletions(-)
