Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa06-03.prod.phx3.secureserver.net ([173.201.192.104]:39921
	"EHLO p3plsmtpa06-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbaAOA5Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jan 2014 19:57:25 -0500
From: "Mark A. Greer" <mgreer@animalcreek.com>
To: Samuel Ortiz <sameo@linux.intel.com>,
	Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Thierry Escande <thierry.escande@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linux-nfc@lists.01.org,
	"Mark A. Greer" <mgreer@animalcreek.com>
Subject: [PATCH 0/3] NFC: iso15693 - Add ISO/IEC 15693 support
Date: Tue, 14 Jan 2014 17:52:08 -0700
Message-Id: <1389747131-2577-1-git-send-email-mgreer@animalcreek.com> (sfid-20140115_015728_325628_9E0812AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series of patches adds support for the ISO/IEC 15693 protocol
and Type V vicinity cards.

This code was tested on an ARM-based BeagleBone (white) with an
RF Cape and a trf7970atb from TI.  So far, only TI tags have been
tested.  I'm still working on the trf7970a driver that was used
for testing and will submit it separately once its ready.

The patches were tested on the current nfc-next/master repo/branch,
bb55dc2ae4367b8f711d43a2f8668a6ed42c4fd3 (NFC: nfcmrvl: Fix possible
memory leak issue).

The corresponding neard patches are ready and will be submitted shortly.

Example session with a TI Tag-it tag (from top-level dir of neard):

	# nfctool -d nfc0 -p
	Start polling on nfc0 as initiator

	Targets found for nfc0
	  Tags: [ tag0 ]
	  Devices: [ ]

	# test/test-tag list
	 [ /org/neard/nfc0/tag0 ]
	    Protocol = ISO-15693
	    ReadOnly = false
	    Type = Type V
	    Adapter = /org/neard/nfc0
	#
	# test/test-tag dump /org/neard/nfc0/tag0
	  [ /org/neard/nfc0/tag0/record0 ]
	      Type = URI
	      URI = https://01.org
	#
	# test/test-tag write /org/neard/nfc0/tag0 URI https://www.kernel.org/
	#
	# test/test-tag dump /org/neard/nfc0/tag0
	  [ /org/neard/nfc0/tag0/record1 ]
	      Type = URI
	      URI = https://www.kernel.org/

Mark A. Greer (3):
  NFC: iso15693 - Add ISO/IEC 15693 header definitions
  NFC: iso15693 - Add Digital Layer support for ISO/IEC 15693
  NFC: iso15693 - Add netlink support for ISO/IEC 15693

 include/net/nfc/digital.h    |   4 ++
 include/net/nfc/nfc.h        |   3 ++
 include/uapi/linux/nfc.h     |   9 +++-
 net/nfc/digital.h            |   1 +
 net/nfc/digital_core.c       |  14 ++++++
 net/nfc/digital_technology.c | 108 +++++++++++++++++++++++++++++++++++++++++++
 net/nfc/netlink.c            |   8 ++++
 7 files changed, 146 insertions(+), 1 deletion(-)

-- 
1.8.3.4

