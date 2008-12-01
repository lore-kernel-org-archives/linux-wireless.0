Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:24040 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320AbYLAVvF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Dec 2008 16:51:05 -0500
Received: by ey-out-2122.google.com with SMTP id 6so1139492eyi.37
        for <linux-wireless@vger.kernel.org>; Mon, 01 Dec 2008 13:51:03 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: iwlwifi - rfkill only works if the interface is up
Date: Mon, 1 Dec 2008 22:50:36 +0100
Cc: Marcel Holtmann <holtmann@linux.intel.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	linux-wireless@vger.kernel.org, yi.zhu@intel.com,
	Dan Williams <dcbw@redhat.com>
References: <200812011311.17346.helmut.schaa@gmail.com> <1228147151.31158.142.camel@violet.holtmann.net> <20081201211231.GC3479@tuxdriver.com>
In-Reply-To: <20081201211231.GC3479@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812012250.37587.helmut.schaa@gmail.com> (sfid-20081201_225112_827210_4ED5B3DA)
From: Helmut Schaa <helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Montag, 1. Dezember 2008 schrieb John W. Linville:
> FWIW, I'm not sure what the point of checking rfkill state would be if the
> adapter is down anyway.  Hmmm...maybe management of the rfkill LED?

The main intention was that user space programs might want to listen to rfkill
events in order to bring the interface up once the killswitch is disabled.

AFAIK NetworkManager takes an interface down once it recognises that the
device is disabled through a killswitch. If the device is not able to notify
a rfkill state change if it is down NM cannot recognise when the device can
be brought up again.

Dan, is that correct?

Regards,
Helmut
