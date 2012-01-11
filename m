Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:38543 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab2AKOpe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 09:45:34 -0500
From: "Elias, Ilan" <ilane@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "samuel@sortiz.org" <samuel@sortiz.org>,
	"lauro.venancio@openbossa.org" <lauro.venancio@openbossa.org>,
	"aloisio.almeida@openbossa.org" <aloisio.almeida@openbossa.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] NFC: Download TI NFC init script
Date: Wed, 11 Jan 2012 14:45:17 +0000
Message-ID: <B30D1FD582D6484ABF57420512E580350F5D1C88@DLEE74.ent.ti.com> (sfid-20120111_154538_325813_24C0BCB8)
References: <1326285768-3073-1-git-send-email-ilane@ti.com>
 <CAK=WgbanHKn3r9VYocmFpoCu9YKOf-hL20GKOgm=qmU1S6A_-A@mail.gmail.com>
In-Reply-To: <CAK=WgbanHKn3r9VYocmFpoCu9YKOf-hL20GKOgm=qmU1S6A_-A@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 Hi Ohad,

> > Download TI NFC init script during nfcwilink open operation,
> > after the NFC channel is registered with TI shared transport.
> > TI NFC init script is written in BTS format.
> > First, read the chip version via a special vendor specific command.
> > Second, we request the relevant BTS file from the user space, and
> > then send the BTS commands to the chip.
> 
> nfcwilink_open() begins by calling the shared transport's
> st_register() function, which also seem to be loading, parsing and
> sending a BTS firmware to the device.
> 
> Does it mean that two firmwares are needed for these NFC devices ?
Yes, TI NFC chip requires 2 different init scripts:
1) General init script for all cores (HCI commands), which comes first
2) NFC init script only for the NFC core (NCI commands), which comes second
 
> From a quick look it seems that much of the boilerplate code for the
> BTS handling is quite similar; any way to avoid some of the code
> duplication (something the shared transport code doesn't try very hard
> to do ;) ?
There are several major differences between the two:
1) The vesion read in st_kim is the BT chip version, using the standard HCI_Read_Local_Version_Information command. This version is regarded as the general chip version.
The version read in the nfcwilink is a different version using a special vendor specific NCI command. This version is regarded as the NFC chip version.
2) The NFC init script is in NCI commands, while the general init script is in HCI commands.
3) In NFC, we want a simplified BTS init script, e.g. with only ACTION_SEND_COMMAND. No waiting, sleeping or other actions...

To summarize, it's a new core with different commands (NCI and not HCI).
We chose BTS to make it simple and familiar, but it's a simplified BTS, and we handle the actions differently.

Thanks & BR,
Ilan
