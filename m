Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f54.google.com ([209.85.215.54]:36139 "EHLO
	mail-lf0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbcACKRI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Jan 2016 05:17:08 -0500
Received: by mail-lf0-f54.google.com with SMTP id z124so257189334lfa.3
        for <linux-wireless@vger.kernel.org>; Sun, 03 Jan 2016 02:17:07 -0800 (PST)
MIME-Version: 1.0
Date: Sun, 3 Jan 2016 12:17:06 +0200
Message-ID: <CANUX_P3Wft5YhvckAzogXy-cV8Ngf8n+Y+6jn1Je3q7r-RDe_g@mail.gmail.com> (sfid-20160103_111712_598386_55F386C9)
Subject: power save settings for WiFi
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

I wanted to debug something with power save control and saw that NM
disables power save by default. This was a complete surprise for me.
This probably is because Ubuntu upgraded my NM version to 1.0.4.
I tried to enabled power save with:

 nmcli c modify <MYSSID> 802-11-wireless.powersave 1

That command returns 0, but power save is still disabled. Note that
the decision to disable power save by default is a bit surprising.
I understand that some device may not behave well with power save
enabled, but then, I'd expect those (bad) devices to disable power
save in the driver level.

Any advice on how can I re-allow power save by default since the
command above didn't help?

thanks.

Emmanuel Grumbach
egrumbach@gmail.com
