Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:56970 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab2IGIIJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 04:08:09 -0400
Message-ID: <5049AB66.1070907@tieto.com> (sfid-20120907_100819_628738_96050E75)
Date: Fri, 7 Sep 2012 10:08:06 +0200
From: Rymarkiewicz Waldemar <waldemar.rymarkiewicz@tieto.com>
MIME-Version: 1.0
To: Eric Lapuyade <eric.lapuyade@linux.intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	"eric.lapuyade@intel.com" <eric.lapuyade@intel.com>
Subject: Re: [linux-nfc] [PATCH 2/2] NFC: Correct outgoing frame before requeueing
References: <1346926937-4968-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <1346926937-4968-2-git-send-email-waldemar.rymarkiewicz@tieto.com> <5048CCA7.4010604@linux.intel.com> <5049964A.6020808@tieto.com> <5049A58F.2060905@linux.intel.com>
In-Reply-To: <5049A58F.2060905@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eric,

>> BTW I see the headroom for pn544 is 2 but it make use of 1 byte (len).
>> Is that correct?
>
> That question made me go back to have a closer look. With shdlc
> currently adding the len and crc, there would be no reason for the
> driver to request any headroom. If you look at the comment above
> PN544_CMDS_HEADROOM, it says "Largest headroom needed for outgoing
> custom commands". The headroom it requests it not for len, it is used by
> the driver to insert special bytes when handling a
> pn544_hci_data_exchange for a reader F gate, which is a special case.

That makes sense. I guess in 1/2 patch PN544_CMDS_HEADROOM should be 3 
() now. Will fix that.

> I didn't remember that when I wrote the previous answer, and this
> defeats my second suggestion. I suggest we go with my first suggestion:
>
> - Specify that the driver xmit MUST NOT modify skb. It shall remove
> anything it inserts or appends before returning from xmit.

It sounds sane.

Thanks,
/Waldek


