Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.jelmoni.net ([78.47.55.82]:41258 "EHLO mail.jelmoni.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbbAPWfM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Jan 2015 17:35:12 -0500
Received: from localhost (localhost [127.0.0.1])
	by mail.jelmoni.net (Postfix) with ESMTP id 391F3618FF
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 23:29:21 +0100 (CET)
Received: from mail.jelmoni.net ([78.47.55.82])
	by localhost (mail.jelmoni.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wPgwgO3DmrlN for <linux-wireless@vger.kernel.org>;
	Fri, 16 Jan 2015 23:29:21 +0100 (CET)
Received: from laptop-bmeier.swiss-wireless (host133.190-137-223.telecom.net.ar [190.137.223.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: genauth@swiss-wireless.com.ar)
	by mail.jelmoni.net (Postfix) with ESMTPSA id 51D22618AA
	for <linux-wireless@vger.kernel.org>; Fri, 16 Jan 2015 23:29:19 +0100 (CET)
Message-ID: <54B990BC.1060604@swiss-wireless.com.ar> (sfid-20150116_233517_806044_139B6A33)
Date: Fri, 16 Jan 2015 19:29:16 -0300
From: Beat Meier <mbe_ml@swiss-wireless.com.ar>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org >> Linux Wireless List"
	<linux-wireless@vger.kernel.org>
Subject: Cannot use ap and sta mode on same interface with ath9k and kernel
 3.8.13 :-(
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

I'm using an WLM200NX card in master mode ath1 and want to do scanning
on the same interface.
I'm using ath9k on 3.8.13 kernel (voyage-linux)

So I setup an additional  interface in sta mode with
  iw phy phy1 interface add ath2 type managed
This works but the interface is not coming up.
I tried several things like
auto ath2
iface ath2 inet static
        address 10.58.1.1
        netmask 255.255.255.0
        wireless-mode Managed
        wpa-conf /etc/wpa_supplicant.conf.WPA-PSK

But wpa_spplicant comes with error:
  wpa_supplicant: /sbin/wpa_supplicant daemon failed to start
  run-parts: /etc/network/if-pre-up.d/wpasupplicant exited with return
code 1
  RTNETLINK answers: Name not unique on network
  Failed to bring up ath2.

I can setup monitor mode but I want to scan to see what other equipment
is on which channel ...

What's the problem? With ath9k I cannot use ap and sta mode together???

Thanks

Beat
