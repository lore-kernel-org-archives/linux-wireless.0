Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38006 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbbJAS7T (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2015 14:59:19 -0400
Message-ID: <560D8276.6040107@codeaurora.org> (sfid-20151001_205923_122372_8AF70DCD)
Date: Thu, 01 Oct 2015 11:59:02 -0700
From: Peter Oh <poh@codeaurora.org>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Subject: Re: [PATCH] ath10k: only advertise mesh support in raw mode
References: <1443445192-30464-1-git-send-email-me@bobcopeland.com> <56097882.4090004@codeaurora.org> <20151001025432.GA1664@localhost>
In-Reply-To: <20151001025432.GA1664@localhost>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On 09/30/2015 07:54 PM, Bob Copeland wrote:
> On Mon, Sep 28, 2015 at 10:27:30AM -0700, Peter Oh wrote:
>> I prefer the current design to this new approach because drivers already
>> know if it's mesh capable or not at build time, hence adding runtime
>> configuration is redundant.
> I do think the proposed patch is a bit overboard, so I suppose my vote is
> to
> keep it the way it is, even if a little user-unfriendly.
>
>> One more thing we have to think about is enabling mesh in only raw mode.
>> In standard view point, mesh is only available in raw mode on ath10k,
>> however ath10k is also able to run mesh in native WiFi mode in current
>> mac80211 design since mac80211 handles packets per interface. So that
>> mac80211 knows that packets are for mesh without looking at mesh control
>> present bit when they come into mesh interface.
> This is true, it'll work with mac80211, but it violates the standard
> (802.11-2012 8.2.4.7.3).
I agree.
>
> For the benefit of others, as I just retested non-rawmode -- the issue is
> that QoS control in nwifi frames is missing the "Mesh Control Present"
> bit.
> However, it still includes the mesh control field, which is the part
> that has the mesh sequence number and address extension fields.
>
> As a result, a packet parser might misinterpret the mesh control field as
> the LLC header -- the wireshark dissector at least gets confused like
> this.
>
> I would think a small change to ath10k firmware could fix this though,
> vendor willing.
I'm working with firmware guy and there is possibility that firmware 
handles this issue properly.
>
Thanks,
Peter
