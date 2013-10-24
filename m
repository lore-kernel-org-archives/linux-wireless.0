Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout3.freenet.de ([195.4.92.93]:41672 "EHLO mout3.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab3JXRHZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Oct 2013 13:07:25 -0400
Received: from [195.4.92.141] (helo=mjail1.freenet.de)
	by mout3.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.80.1 #4)
	id 1VZO01-0007fa-E9
	for linux-wireless@vger.kernel.org; Thu, 24 Oct 2013 18:43:05 +0200
Received: from localhost ([::1]:50479 helo=mjail1.freenet.de)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.80.1 #4)
	id 1VZO01-0007Pa-8u
	for linux-wireless@vger.kernel.org; Thu, 24 Oct 2013 18:43:05 +0200
Received: from mx8.freenet.de ([195.4.92.18]:59050)
	by mjail1.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.80.1 #4)
	id 1VZNxx-0005eJ-DV
	for linux-wireless@vger.kernel.org; Thu, 24 Oct 2013 18:40:57 +0200
Received: from p4fde085b.dip0.t-ipconnect.de ([79.222.8.91]:60448 helo=mail.maya.org)
	by mx8.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256) (port 25) (Exim 4.80.1 #4)
	id 1VZNxx-0002y2-4Y
	for linux-wireless@vger.kernel.org; Thu, 24 Oct 2013 18:40:57 +0200
Message-ID: <52694D8B.1030308@01019freenet.de> (sfid-20131024_190729_209695_6D00864A)
Date: Thu, 24 Oct 2013 18:40:43 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Kevin Lo <kevlo@kevlo.org>, John Linville <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] [PATCH] rt2x00: rt2800lib: update RF registers
 for RT5390
References: <20131024052408.GA7828@ns.kevlo.org>
In-Reply-To: <20131024052408.GA7828@ns.kevlo.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kevin,

Kevin Lo wrote:
> Mirror the latest MediaTek/Ralink driver with respect to RT5390 RF register
> programming.  The PCI and USB devices use different init values.

If you (and others here) really want to improve anything for rt2800usb,
change your development system and use a raspberry pi (PI).

Why PI? Because the PI doesn't cover any broken code / concept / driver
architecture with hardware resources.

You want to have an example?

This device[1] achieves 140 MBit/s (data receiving) on the PI, measured
with netperf and rt5572sta compared to rt2800usb, which achieves very
very very poor 30 MBit/s(! - even w/ best radio conditions can't be
achieved any more) but an extremely high CPU load at the same time!

If you compare the basic behaviour of rt5572sta and rt2800usb, you will
see, that rt5572sta uses a completely different usb handling, which
doesn't need that much CPU resources as the one used by rt2800usb.

Therefore: If you really want to improve rt2800usb, at first take a
serious look at how usb is handled by rt5572sta and how to save CPU
resources.

In a nutshell: Use a few, but big USB packets instead of a lot of small
ones, which needs a lot of interrupts / s and therefore needs a lot of
CPU resources - which aren't available on the PI at all.


Kind regards,
Andreas



[1] http://wikidevi.com/wiki/Linksys_AE3000
