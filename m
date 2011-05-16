Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57288 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737Ab1EPJlJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 05:41:09 -0400
MIME-Version: 1.0
Date: Mon, 16 May 2011 12:41:07 +0300
Message-ID: <BANLkTimkgtQL1A2A3iAP-UYK2KdDvPmY3Q@mail.gmail.com> (sfid-20110516_114126_970394_5B78446A)
Subject: several packets in a single buffer in Rx
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>, guy.cohen@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am trying to enable a HW feature on a wireless NIC that allows the
HW to put several packets in the same Rx buffer coming from the NIC.
This can save interrupts and traffic on the bus.
Today, the driver allocates pages in which the PCI-e device puts its
data. Then we create an skb and add a fragment that points to the
beginning of the page. The offset of the fragment is set to the offset
of the first byte of the mac header within the buffer. There is only
one packet per page / buffer.

I would like to be able to deliver the same page several times to the
stack without having the stack consume it before the last time I
deliver it.
Of course I would like to avoid cloning it.

I tried to look at shinfo->nr_frags but this looks more like a sgl
related variable
GRO doesn't seem to be related either since as far as I understood, it
is relevant for packets after 802.11 to 802.3 translation.


FWIW: I am talking about Intel's wireless device although I don't
think this fact matters

Thanks

Emmanuel Grumbach
egrumbach@gmail.com
