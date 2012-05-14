Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.serverraum.org ([78.47.150.89]:51916 "EHLO
	mail.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab2ENTrg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 15:47:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.serverraum.org (Postfix) with ESMTP id 0A3353EFF8
	for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 21:39:11 +0200 (CEST)
Received: from mail.serverraum.org ([127.0.0.1])
	by localhost (web.serverraum.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pXrvoNGEtFp6 for <linux-wireless@vger.kernel.org>;
	Mon, 14 May 2012 21:39:10 +0200 (CEST)
Received: from mail-gg0-f174.google.com (mail-gg0-f174.google.com [209.85.161.174])
	(using TLSv1 with cipher RC4-MD5 (128/128 bits))
	(No client certificate requested)
	by mail.serverraum.org (Postfix) with ESMTPSA id 8A5C83EFF5
	for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 21:39:10 +0200 (CEST)
Received: by gglu4 with SMTP id u4so3486999ggl.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 12:39:09 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 14 May 2012 21:39:09 +0200
Message-ID: <CADYPuQ5U-TeJvaWdLA=kTgLRacMRyEPoi2aoB=PV-cx_YDXotg@mail.gmail.com> (sfid-20120514_214740_072818_62355BDA)
Subject: frequent disconnects with iwlwifi
From: Philipp Dreimann <philipp@dreimann.net>
To: johannes.berg@intel.com, wey-yi.w.guy@intel.com,
	ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

my wifi connection is unstable with the 3.4-rc-kernels. Kernel 3.2 works fine.

The first symptom was: "deauthenticating from 00:1f:3f:d0:65:73 by
local choice (reason=3)"

Then, by using debug=0x43fff as a module parameter, messages like the
following are in the log file before the disconnect:
I iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x09CD,
52 bytes at 205[13]:9
I iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x09CE,
52 bytes at 206[14]:9
I iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x09CF,
52 bytes at 207[15]:9
I iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x09D0,
52 bytes at 208[16]:9
I iwl_enqueue_hcmd Sending command SENSITIVITY_CMD (#a8), seq: 0x09D1,
52 bytes at 209[17]:9

Another thing I noticed is that the disconnects are happening (most of
the time) every 20 minutes and 18 seconds. The connection is
established immediately after the disconnect. This is also not
happening with every access point, but unfortunately with the one at
home. The logfile of the AP states that my client did not respond in
time and ie being disconnected because of that.

The access point settings are wpa2 psk, ccmp, channel 1, 11n enabled.
According to the iwlwifi module, my card is a 6205AGN, REV=0xB0 .
Please let me know if I can help  with more information.

Best,
 Philipp Dreimann
