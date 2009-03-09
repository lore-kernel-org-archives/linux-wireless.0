Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41013 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751575AbZCIULq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2009 16:11:46 -0400
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Kevin Wilson <wkevils@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 9 Mar 2009 13:11:43 -0700
Subject: RE: Packet aggregation in iwlwifi drivers
Message-ID: <E9954878DD1FB34FAE5187FB88C58A353F74F532@orsmsx506.amr.corp.intel.com> (sfid-20090309_211149_962841_B474D774)
References: <55c333c0903090134o4c6c65b7v4bf0674971f9156c@mail.gmail.com>
In-Reply-To: <55c333c0903090134o4c6c65b7v4bf0674971f9156c@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You are correct, iwlwifi driver will handle enable the h/w aggregation queue and based on the ampdu_action() and other condition such as sequence# to decide which queue the pkt shall belong to. All the real aggregation works are performed in the firmware.

Wey-Yi Guy
Intel Corporation
2111 N.E. 25th Avenue  M/S JF3-308                 
Hillsboro OR 97124-5961
USA
Work Phone: 503-264-6023 (OR)
Cell Phone: 503-329-8410
Email: wey-yi.w.guy@intel.com
 

-----Original Message-----
From: linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-owner@vger.kernel.org] On Behalf Of Kevin Wilson
Sent: Monday, March 09, 2009 1:35 AM
To: linux-wireless@vger.kernel.org
Subject: Packet aggregation in iwlwifi drivers

Hello,
- I have a short question about packet aggregation in iwlwifi drivers which
support 802.11n:
Is packet aggregation in these drivers performed by the firmware ?

I noticed that the ampdu_action() function is implemented by
iwl_mac_ampdu_action()
in these drivers; but as far as I can find, only the operations of
start/stop tx and rx aggregation
are implemented in the driver, so I guess that the aggregation of MPDU packets
(concatenating them into a single block, sending BAR - block
acknowledge request,
sending the block containing aggregated MPDUs, and so on) are
implemented in firmware. Is it so ?


Regards,
Kevin
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
