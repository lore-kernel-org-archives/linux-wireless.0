Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f188.google.com ([209.85.210.188]:55090 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab0ASEoA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jan 2010 23:44:00 -0500
Received: by yxe26 with SMTP id 26so2999361yxe.4
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jan 2010 20:43:59 -0800 (PST)
Subject: eapol_version=1 required for OS X clients?
From: Eric Volker <evolker@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 18 Jan 2010 22:43:56 -0600
Message-ID: <1263876237.2619.1.camel@fwdell4550>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am in the process of setting up a AP using Ubuntu 9.10, a Broadcom
BCM4318 and hostapd. I've run into an issue getting OS X clients to
associate with the access point. Once I had configured hostapd.conf
correctly, Windows and Linux clients were able to associate with the AP
and use it as a router. OS X clients, however, would not associate and
I'd see messages in the log that said "Deassociated due to inactivity."
After wrestling with that for a few days, I found a reference to someone
setting the EAP version to 1 to allow his iBook to connect. Sure enough,
setting eapol_version=1 in hostapd.conf resolved the issue and allowed
all OS X clients to connect (including a Leopard laptop, a Snow Leopard
iMac and an iPhone 3G.) However, this brings up several questions:

Is EAP version 1 secure?

In light of this issue, why is version 2 default? Is there any way to
negotiate the version level? Which version do off-the-shelf consumer
routers use?

Based on the comments in hostapd.conf, EAP only seems to be used for
802.1X authentication. I'm using WPA/WPA2 (wpa=3) Personal
authentication, so why does the EAP version matter?

Why is an OS as recent as Snow Leopard (10.6) using a protocol version
that the hostapd.conf comments imply is outdated?

Thanks,

Eric Volker

