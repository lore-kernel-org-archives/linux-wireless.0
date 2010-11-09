Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eos.fwall.u-szeged.hu ([160.114.120.248]:44021 "EHLO
	eos.fwall.u-szeged.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754455Ab0KIVLz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 16:11:55 -0500
Received: from localhost ([127.0.0.1] helo=eos.fwall.u-szeged.hu)
	by eos.fwall.u-szeged.hu with esmtp (Exim 4.67)
	(envelope-from <zherczeg@inf.u-szeged.hu>)
	id 1PFvTt-0006Uk-5u
	for linux-wireless@vger.kernel.org; Tue, 09 Nov 2010 22:11:53 +0100
Received: from mail.inf.u-szeged.hu ([160.114.37.227])
	by eos.fwall.u-szeged.hu with esmtp (Exim 4.67)
	(envelope-from <zherczeg@inf.u-szeged.hu>)
	id 1PFvTf-0006U0-Ez
	for linux-wireless@vger.kernel.org; Tue, 09 Nov 2010 22:11:51 +0100
Received: from webmail.inf.u-szeged.hu (nora3.inf.u-szeged.hu [160.114.37.221])
	by mail.inf.u-szeged.hu (Postfix) with ESMTP id 5BCA616A0852
	for <linux-wireless@vger.kernel.org>; Tue,  9 Nov 2010 22:11:39 +0100 (CET)
Message-ID: <33010.82.131.221.21.1289337099.squirrel@webmail.inf.u-szeged.hu>
Date: Tue, 9 Nov 2010 22:11:39 +0100 (CET)
Subject: [Fwd: connecting ieee80211_hw and net_device]
From: "Zoltan Herczeg" <zherczeg@inf.u-szeged.hu>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am developing a wireless driver for a cycle accurate energy simulator,
and cannot solve the following issue:

I can allocate a "wlan0" and "wlan1" platform device with
ieee80211_alloc_hw, and can initialize it in Ad-Hoc mode. However, I
realized this is not enough to have a wireless interface, since it has no
receive operation, only transfer. Looking at the other drivers, I found
that they allocate a net_device with the common alloc_etherdev.
Unfortunately the register_netdev registers a new eth interface in my
case, and this interface is not connected to the wlan interface. I set
wireless_handlers and ieee80211_ptr for this device, still it is totally
independent from the wlan interface.

Am I missing something? (Sorry if this is a trivial question, I tried
google but no luck so far)

Thanks in advance
Zoltan

