Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:35301 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab0K3VXt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 16:23:49 -0500
Received: by gwj20 with SMTP id 20so3010465gwj.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 13:23:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4CF55231.5000205@ti.com>
References: <1290079951-16793-1-git-send-email-arik@wizery.com>
 <1290079951-16793-18-git-send-email-arik@wizery.com> <4CF51CE8.9090809@ti.com>
 <AANLkTimtk2qXYOVPo+WRyV1Jhe-Fk-7hvoctuAF35ik7@mail.gmail.com>
 <4CF54A03.2090104@ti.com> <AANLkTinbFBXi9J5up65tV2Hp-5-0jDbbLuuCEn6ts2nJ@mail.gmail.com>
 <4CF55231.5000205@ti.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 30 Nov 2010 23:23:32 +0200
Message-ID: <AANLkTi=72kjeJ5L9dUHmYuS1T8E-kKiGzB3t68gs7hWy@mail.gmail.com>
Subject: Re: [PATCH 17/18] wl1271: Read MAC address from NVS file on HW startup
To: Gery Kahn <geryk@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luciano Coelho <luciano.coelho@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Fully agree. Just set vif where u set wl and the solution would be synced
> for your flow.

There is no way to set the vif addr from wl1271_register_hw() since no
vif has been created yet. The hardware was only just initialized..

The vif addr is set from the perm address before add_interface is
called (see ieee80211_if_add()). This means the last to write the MAC
address effectively sets the vif addr.

Regards,
Arik
