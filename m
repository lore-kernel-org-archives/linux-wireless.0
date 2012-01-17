Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:38665 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab2AQM4s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Jan 2012 07:56:48 -0500
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id D6BB1DECCA
	for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2012 12:29:36 +0000 (GMT)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new, port 10024)
	with ESMTP id jzEyYJ2yVzp3 for <linux-wireless@vger.kernel.org>;
	Tue, 17 Jan 2012 12:58:05 +0000 (GMT)
Received: from stargate.localnet (unknown [84.45.236.142])
	by mail.ukfsn.org (Postfix) with ESMTP id 30A1BDECC1
	for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2012 12:29:36 +0000 (GMT)
From: David Goodenough <david.goodenough@btconnect.com>
To: linux-wireless@vger.kernel.org
Subject: why can the distance only be set on a phy not a dev
Date: Tue, 17 Jan 2012 12:29:33 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201201171229.33901.david.goodenough@btconnect.com> (sfid-20120117_135652_146253_52D9EF91)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using the iw command, most things can either be directed to a dev or
a phy, but a distance can only be set on a phy.

This leads to problems as I do not know which phy is connected to a 
dev (or at least I do not know how to find out which phy is connected
to a dev), and so in my Debian /etc/network/interfaces file I have:-

iface wlan0 inet manual
	pre-up iw dev wlan0 interface add mesh0 type mp

iface mesh0 inet static
    address 10.101.11.254
    netmask 255.255.255.0
    pre-up iw dev mesh0 set channel 153
    post-up iw phy phy0 set distance 3500
    up iw dev mesh0 mesh join MeshId

so in the mesh0 stanza I have a reference to phy0 which is hard
coded and if it changes subject to error.

So either I need to be able to set distance to dev mesh0, or have
some means or working out which phy corresponds to dev mesh0.

Any ideas?

David
