Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f176.google.com ([209.85.211.176]:58268 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab0AZC1M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 21:27:12 -0500
Received: by ywh6 with SMTP id 6so3705610ywh.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2010 18:27:11 -0800 (PST)
Subject: b43 driver hang workaround
From: Eric Volker <evolker@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 20:27:00 -0600
Message-ID: <1264472821.2691.0.camel@fwdell4550>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thought I'd post my workaround for the issue I've been experiencing. My
setup is as follows: Ubuntu 9.10 x86 and a BCM4318 in AP mode. Briefly,
I'd see a message in the logs about hardware encryption being disabled,
at which point my NIC would stop beaconing. Apparently turning off QoS
support remedies this problem. Putting this line into /etc/modules made
my wireless usable:


b43 qos=0


Obviously, QoS support is preferable to not, but I don't really need it
for my SOHO needs. Hopefully this will help someone else.


Eric


