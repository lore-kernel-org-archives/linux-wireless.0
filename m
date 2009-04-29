Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost06.isp.att.net ([207.115.11.56]:61061 "EHLO
	fmailhost06.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbZD2XXK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2009 19:23:10 -0400
Message-ID: <49F8E145.1050708@lwfinger.net> (sfid-20090430_012316_460274_D053342A)
Date: Wed, 29 Apr 2009 18:22:45 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression since 2.6.30-rc1 - Page allocation failures
References: <49F8C03D.6040909@lwfinger.net>	 (sfid-20090429_230225_847074_E5413886)  <1241039372.4547.3.camel@johannes.local>	 (sfid-20090429_231009_993152_4FF82E4D) <1241040451.5067.0.camel@johannes.local>
In-Reply-To: <1241040451.5067.0.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2009-04-29 at 23:09 +0200, Johannes Berg wrote:
> 
>> 	"%d, %d, need %d, %d", skb->data_len, skb->len, head_need, tail_need
> 
> actually, I think I want
> 
> 	skb_tail_pointer(skb) - skb->head
> 
> instead of skb->data_len.

I get the "failed to reallocate TX buffer" message. Not all are related to the
page allocation failure. I am also getting "b43-phy0 debug: DMA RX:
setup_rx_descbuffer() failed" messages.

So far, the numbers printed by the revised printk are:

kernel: phy0: failed to reallocate TX buffer 0, 404, need 0, 0
kernel: protocol 0008 is buggy, dev eth1

kernel: phy0: failed to reallocate TX buffer 0, 1728, need 0, 18

Device eth1 is the b43 wireless device.

Larry
