Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:22467 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbYAVUEp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 15:04:45 -0500
Received: by fg-out-1718.google.com with SMTP id e21so2028576fga.17
        for <linux-wireless@vger.kernel.org>; Tue, 22 Jan 2008 12:04:41 -0800 (PST)
Message-ID: <f6ca9fed0801221204j71ad2137l19555363e46a7e45@mail.gmail.com> (sfid-20080122_200449_346520_2D09DF41)
Date: Tue, 22 Jan 2008 21:04:40 +0100
From: drago01 <drago01@gmail.com>
To: ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: iwl3945 rfkill regression
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Zhu Yi" <yi.zhu@intel.com>,
	"Cahill, Ben M" <ben.m.cahill@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
Hi recent updates to wireless-2.6 / iwlwifi (1.2.22->1.2.23) broke
rfkill in a weird way for me.
What happens:
When I switch off the card using the hw rfkill switch (while
acciotated) I get this in dmesg:
iwl3945: Radio Frequency Kill Switch is On:
Kill switch must be turned off for wireless networking to work.
wlan0: disassociate(reason=3)
wlan0: disassociate(reason=3)
iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl3945: MAC is in deep sleep!
iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl3945: MAC is in deep sleep!
iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
iwl3945: MAC is in deep sleep!
iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
ACPI: PCI interrupt for device 0000:07:00.0 disabled

Notice the last line (interupt gets disabled). When this happens there
is no way to get the card back up other then reloading the module.
Earlier version (1.2.22) was working fine I could switch the switch
on/off without having an suchs kind of issues.
I have not tryed to find out which patch broke it yet, but I suspect
the suspend / resume rfkill fix mighr be the culprit.

If any more tests / information is needed feel free to ask.
