Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36812 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab0K3QEl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 11:04:41 -0500
Received: by gyb11 with SMTP id 11so2785780gyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 08:04:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CF51CE8.9090809@ti.com>
References: <1290079951-16793-1-git-send-email-arik@wizery.com>
 <1290079951-16793-18-git-send-email-arik@wizery.com> <4CF51CE8.9090809@ti.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 30 Nov 2010 18:04:25 +0200
Message-ID: <AANLkTimtk2qXYOVPo+WRyV1Jhe-Fk-7hvoctuAF35ik7@mail.gmail.com>
Subject: Re: [PATCH 17/18] wl1271: Read MAC address from NVS file on HW startup
To: geryk@ti.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>
> The code flow of the add if (wl1271_op_add_interface) overwrites it from
> vif.

Thats the point of the patch. The MAC can be overwritten at any point
between HW initialization and add_interface(). Either by a TESTMODE
cmd or even by "ifconfig wlan0 hw ether xx:xx:xx:xx:xx:xx". The patch
makes sure the MAC address is set (the default value is in the NVS)
when the hardware is initialized.

This allows the creation of monitor interfaces for instance. These are
created without calling the driver's add_interface() and require a
valid MAC address to be set. Such a monitor interface is added by
hostapd when creating an AP (which explains why this patch is included
in the AP-support patch-set).

When this patch is applied one should be careful to not set the mac
twice with different MAC addresses, as this might cause problems for
the upper layers.

Regards,
Arik
