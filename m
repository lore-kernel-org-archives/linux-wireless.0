Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:43132 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755016AbXGHSqj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2007 14:46:39 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id DD37A8CAD8
	for <linux-wireless@vger.kernel.org>; Sun,  8 Jul 2007 20:46:32 +0200 (CEST)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id 5199110584
	for <linux-wireless@vger.kernel.org>; Sun,  8 Jul 2007 18:47:49 +0000 (UTC)
Received: from meerkat.home.warmcat.com (localhost [127.0.0.1])
	by meerkat.home.warmcat.com (Postfix) with ESMTP id 4F26818D1DA2
	for <linux-wireless@vger.kernel.org>; Sun,  8 Jul 2007 19:46:38 +0100 (BST)
Message-ID: <4691310E.8070406@warmcat.com>
Date: Sun, 08 Jul 2007 19:46:38 +0100
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: iwlwifi 3945: secondary interface disallows association
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

I have pretty decent functionality on the 3945abg laptop with the Fedora
development kernel version of iwlwifi and WPA via wpa_supplicant.
Connections can stay up over a couple of days or more when I am staying
close to the AP.

However if I perform this action:

echo -n mon0 > /sys/class/ieee80211/phy0/add_iface

I immediately lose association and cannot reacquire it until I remove
the iwl3945 module and insert again.  I don't have to do anything with
the new interface, just create it.  I tried setting the channel and mode
of it, but that didn't help with reacquiring an association.

In contrast I can bring up other virtual interfaces okay on, eg, zd1211
without losing an existing association to the same WPA network.

-Andy
