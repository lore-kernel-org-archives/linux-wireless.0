Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:48559 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759245Ab2IGHnE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 03:43:04 -0400
Message-ID: <5049A58F.2060905@linux.intel.com> (sfid-20120907_094321_617872_7125FB09)
Date: Fri, 07 Sep 2012 09:43:11 +0200
From: Eric Lapuyade <eric.lapuyade@linux.intel.com>
MIME-Version: 1.0
To: Rymarkiewicz Waldemar <waldemar.rymarkiewicz@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	"eric.lapuyade@intel.com" <eric.lapuyade@intel.com>
Subject: Re: [linux-nfc] [PATCH 2/2] NFC: Correct outgoing frame before requeueing
References: <1346926937-4968-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <1346926937-4968-2-git-send-email-waldemar.rymarkiewicz@tieto.com> <5048CCA7.4010604@linux.intel.com> <5049964A.6020808@tieto.com>
In-Reply-To: <5049964A.6020808@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Waldek,

On 09/07/2012 08:38 AM, Rymarkiewicz Waldemar wrote:
> Hi Eric,
> 
>> This patch would work for PN544, but it makes the assumption that the
>> driver will always insert/append exactly client_headroom/client_tailroom
>> bytes when xmit is called. This is not specified nor enforced so it may
>> be a little dangerous.
> 
> Do you mean that the driver can request client_head/tailroom which is a
> maximum it can use, but it does not mean that all space will be used in
> in each frame e.g. due to optional fields?  That's the only situation I
> can imagine now.

Yes, this is exactly what I mean.

> BTW I see the headroom for pn544 is 2 but it make use of 1 byte (len).
> Is that correct?

That question made me go back to have a closer look. With shdlc
currently adding the len and crc, there would be no reason for the
driver to request any headroom. If you look at the comment above
PN544_CMDS_HEADROOM, it says "Largest headroom needed for outgoing
custom commands". The headroom it requests it not for len, it is used by
the driver to insert special bytes when handling a
pn544_hci_data_exchange for a reader F gate, which is a special case.

I didn't remember that when I wrote the previous answer, and this
defeats my second suggestion. I suggest we go with my first suggestion:

- Specify that the driver xmit MUST NOT modify skb. It shall remove
anything it inserts or appends before returning from xmit.

Eric
