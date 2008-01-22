Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15977 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054AbYAVUHt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jan 2008 15:07:49 -0500
MIME-Version: 1.0
Subject: RE: [ipw3945-devel] iwl3945 rfkill regression
Date: Tue, 22 Jan 2008 22:07:30 +0200
Message-ID: <C07C4589BE74A34981C3C3525EE1F8010338CB35@hasmsx412.ger.corp.intel.com> (sfid-20080122_200756_587706_BBC9588F)
In-Reply-To: <f6ca9fed0801221204j71ad2137l19555363e46a7e45@mail.gmail.com>
References: <f6ca9fed0801221204j71ad2137l19555363e46a7e45@mail.gmail.com>
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: "drago01" <drago01@gmail.com>,
	"ipw3945-devel" <ipw3945-devel@lists.sourceforge.net>
Cc: "Cahill, Ben M" <ben.m.cahill@intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



>-----Original Message-----
>From: ipw3945-devel-bounces@lists.sourceforge.net
[mailto:ipw3945-devel-
>bounces@lists.sourceforge.net] On Behalf Of drago01
>Sent: Tuesday, January 22, 2008 10:05 PM
>To: ipw3945-devel
>Cc: Cahill, Ben M; Zhu, Yi; linux-wireless
>Subject: [ipw3945-devel] iwl3945 rfkill regression
>
>Hi,
>Hi recent updates to wireless-2.6 / iwlwifi (1.2.22->1.2.23) broke
>rfkill in a weird way for me.
>What happens:
>When I switch off the card using the hw rfkill switch (while
>acciotated) I get this in dmesg:
>iwl3945: Radio Frequency Kill Switch is On:
>Kill switch must be turned off for wireless networking to work.
>wlan0: disassociate(reason=3)
>wlan0: disassociate(reason=3)
>iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
>iwl3945: MAC is in deep sleep!
>iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
>iwl3945: MAC is in deep sleep!
>iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
>iwl3945: MAC is in deep sleep!
>iwl3945: WARNING: Requesting MAC access during RFKILL wakes up NIC
>ACPI: PCI interrupt for device 0000:07:00.0 disabled
>
>Notice the last line (interupt gets disabled). When this happens there
>is no way to get the card back up other then reloading the module.
>Earlier version (1.2.22) was working fine I could switch the switch
>on/off without having an suchs kind of issues.
>I have not tryed to find out which patch broke it yet, but I suspect
>the suspend / resume rfkill fix mighr be the culprit.
>
>If any more tests / information is needed feel free to ask.
>
I believe it's delaying uCode load to mac_start - still need to be
polished. 

Tomas


---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

