Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49794 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbcBDUp6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 15:45:58 -0500
Subject: Re: [RFC v2] iwlwifi: pcie: transmit queue auto-sizing
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	linux-wireless@vger.kernel.org
References: <1454616764-19841-1-git-send-email-emmanuel.grumbach@intel.com>
 <1454616988-21901-1-git-send-email-emmanuel.grumbach@intel.com>
Cc: netdev@vger.kernel.org,
	Stephen Hemminger <stephen@networkplumber.org>,
	Dave Taht <dave.taht@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>
From: Ben Greear <greearb@candelatech.com>
Message-ID: <56B3B885.1050409@candelatech.com> (sfid-20160204_214606_462899_6868E11A)
Date: Thu, 4 Feb 2016 12:45:57 -0800
MIME-Version: 1.0
In-Reply-To: <1454616988-21901-1-git-send-email-emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/04/2016 12:16 PM, Emmanuel Grumbach wrote:
> As many (all?) WiFi devices, Intel WiFi devices have
> transmit queues which have 256 transmit descriptors
> each and each descriptor corresponds to an MPDU.
> This means that when it is full, the queue contains
> 256 * ~1500 bytes to be transmitted (if we don't have
> A-MSDUs). The purpose of those queues is to have enough
> packets to be ready for transmission so that when the device
> gets an opportunity to transmit (TxOP), it can take as many
> packets as the spec allows and aggregate them into one
> A-MPDU or even several A-MPDUs if we are using bursts.

I guess this is only really usable if you have exactly one
peer connected (ie, in station mode)?

Otherwise, you could have one slow peer and one fast one,
and then I suspect this would not work so well?

For reference, ath10k has around 1400 tx descriptors, though
in practice not all are usable, and in stock firmware, I'm guessing
the NIC will never be able to actually fill up it's tx descriptors
and stop traffic.  Instead, it just allows the stack to try to
TX, then drops the frame...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

