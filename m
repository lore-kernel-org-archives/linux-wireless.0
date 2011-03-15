Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46851 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab1COV3A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 17:29:00 -0400
Message-ID: <4D7FDA14.7000904@gmail.com>
Date: Tue, 15 Mar 2011 14:28:52 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Bob Copeland <me@bobcopeland.com>,
	Christoph Lameter <cl@linux.com>,
	David Rientjes <rientjes@google.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Nick Piggin <npiggin@kernel.dk>,
	Dave Chinner <dchinner@redhat.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Pekka Enberg <penberg@cs.helsinki.fi>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: <IRQ> [<ffffffff810c9204>] ? __alloc_pages_nodemask+0x622/0x696
References: <AANLkTikaLb_xan2ePfo9JCZ1w7RZ76wF8NUT2tYr0ZD=@mail.gmail.com> <alpine.DEB.2.00.1103051847100.8779@chino.kir.corp.google.com> <4D770178.9070908@gmail.com> <alpine.DEB.2.00.1103091254540.13353@chino.kir.corp.google.com> <4D77EEB4.9090404@gmail.com> <alpine.DEB.2.00.1103091549020.16989@router.home> <20110310000502.GA13763@hash.localnet> <20110315205946.GL11878@tux>
In-Reply-To: <20110315205946.GL11878@tux>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/15/2011 01:59 PM, Luis R. Rodriguez wrote:
> On Wed, Mar 09, 2011 at 04:05:02PM -0800, Bob Copeland wrote:
>> On Wed, Mar 09, 2011 at 03:54:24PM -0600, Christoph Lameter wrote:
>>> [ 7419.322770] wlan0: associated
>>> [ 7427.161366] ath: Failed to stop TX DMA in 100 msec after killing last frame
>>> [ 7427.161432] ath: Failed to stop TX DMA!
>>> [ 7434.492398] ath: Failed to stop TX DMA in 100 msec after killing last frame
>>> [ 7434.492462] ath: Failed to stop TX DMA!
>>> [ 7603.339047]
>>> =============================================================================
>>> [ 7603.339053] BUG radix_tree_node: Padding overwritten. 0xffff88000008fe00-0xffff88000008fe32
>>
>>> Could the ath driver corrupt memory if the TX DMA cannot be stopped?
>
> Yes, this is why we have had a series of patches to address this upstream,
> the latest one was for RX DMA failing to stop but Felix found a fix for that.
> Apart from that I am not aware of more issues. Can you please try with
> wireless-testing.git ?
>
>    Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
sure..

as for seeing this issue. nothing really now on the current. only 
message I see is:

[   69.551295] ath: Failed to stop TX DMA in 100 msec after killing last 
frame
[   69.551336] ath: Failed to stop TX DMA!

which I saw earlier today.. keep in mind I am at the book store so the 
internet is constantly connecting/disconnecting

Justin P. Mattock
