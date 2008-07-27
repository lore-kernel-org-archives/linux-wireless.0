Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from usul.saidi.cx ([204.11.33.34]:49217 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757490AbYG0TFk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jul 2008 15:05:40 -0400
Message-ID: <488CBBA0.2050106@overt.org> (sfid-20080727_210547_126803_E1AA11B6)
Date: Sun, 27 Jul 2008 11:17:04 -0700
From: Philip Langdale <philipl@overt.org>
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, toshiba_acpi@memebeam.org,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/1] toshiba_acpi: Add support for bluetooth toggling through
 rfkill
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As requested by Henrique, I have reworked this patch against wireless-testing
and it uses the new-style rfkill API and to report the input device as a switch.

I did some digging to try and find a usable gpe event but had only limited
success. From another look through the AML, it uses GPE08 for almost everything
- inspecting a bunch of state for each event and then sending notifications on
different objects. I couldn't find one for the hardware kill switch itself but I
did manage to find one that's emitted when the bluetooth device enters the
equivalent of the SOFT_BLOCKED state. This is useful for noticing that the
hardware switch has been released, but it also fires on transitions from UNBLOCKED
to SOFT_BLOCKED - so I had to try and avoid turning around and unblocking the
device! I'm not particularly happy with how I did it (ignore-the-next-event)
but I can't think of a better way.

--phil
