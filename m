Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:55071 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab2IGGiK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 02:38:10 -0400
Message-ID: <5049964A.6020808@tieto.com> (sfid-20120907_083814_780722_4EC5851D)
Date: Fri, 7 Sep 2012 08:38:02 +0200
From: Rymarkiewicz Waldemar <waldemar.rymarkiewicz@tieto.com>
MIME-Version: 1.0
To: Eric Lapuyade <eric.lapuyade@linux.intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-nfc@lists.01.org" <linux-nfc@lists.01.org>,
	"sameo@linux.intel.com" <sameo@linux.intel.com>,
	"eric.lapuyade@intel.com" <eric.lapuyade@intel.com>
Subject: Re: [linux-nfc] [PATCH 2/2] NFC: Correct outgoing frame before requeueing
References: <1346926937-4968-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <1346926937-4968-2-git-send-email-waldemar.rymarkiewicz@tieto.com> <5048CCA7.4010604@linux.intel.com>
In-Reply-To: <5048CCA7.4010604@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eric,

> This patch would work for PN544, but it makes the assumption that the
> driver will always insert/append exactly client_headroom/client_tailroom
> bytes when xmit is called. This is not specified nor enforced so it may
> be a little dangerous.

Do you mean that the driver can request client_head/tailroom which is a 
maximum it can use, but it does not mean that all space will be used in 
in each frame e.g. due to optional fields?  That's the only situation I 
can imagine now.

BTW I see the headroom for pn544 is 2 but it make use of 1 byte (len). 
Is that correct?


Thanks,
/Waldek
