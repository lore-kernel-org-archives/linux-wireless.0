Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:51997 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521Ab0CVXxU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Mar 2010 19:53:20 -0400
Received: by qw-out-2122.google.com with SMTP id 8so1368236qwh.37
        for <linux-wireless@vger.kernel.org>; Mon, 22 Mar 2010 16:53:20 -0700 (PDT)
Message-ID: <4BA80118.1070801@lwfinger.net>
Date: Mon, 22 Mar 2010 18:45:28 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: Calvin Walton <calvin.walton@gmail.com>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] ssb: Implement virtual SPROM on disk
References: <4ba6aa45.z5Wso1NMth9eMeFG%Larry.Finger@lwfinger.net> <1269239303.12836.17.camel@ayu> <4BA7E79C.9070100@lwfinger.net> <201003222325.35994.mb@bu3sch.de>
In-Reply-To: <201003222325.35994.mb@bu3sch.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael,

Would the following be sufficient?

(1) The utility /bin/dbus-uuidgen is used to create a file
/lib/firmware/ssb/mac_address. The command to create this file if it does not
exist could be added to the scripts that use fwcutter.

(2) In drivers/ssb/pci.c, the firmware loading process reads the file, then
modifies it using the bus address.

I think this process would create a persistent MAC address that is unique within
the box, with a small probability of being duplicated on another machine.

Larry

