Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:33400 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753208AbXCRJAZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Mar 2007 05:00:25 -0400
Message-ID: <45FCFFA5.5070801@warmcat.com>
Date: Sun, 18 Mar 2007 09:00:21 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: linux-wireless@vger.kernel.org, Jiri Benc <jbenc@suse.cz>
Subject: Re: [PATCH 2/2] mac80211: Monitor mode radiotap-based packet injection
References: <20070317105800.659633351@warmcat.com> <200703171751.50898.flamingice@sourmilk.net> <45FC6727.3090008@warmcat.com> <200703171920.37469.flamingice@sourmilk.net> <45FC7924.8050501@warmcat.com>
In-Reply-To: <45FC7924.8050501@warmcat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Andy Green wrote:
> Michael Wu wrote:
>> On Saturday 17 March 2007 18:09, Andy Green wrote:
>>> Yeah naturally it was my first move to use what was there, but the
>>> result was a panic that went away when I moved the skb to belong to the
>>> "master" interface's index and separately persistently tagged the packet
>>> as being injected.
>>>
>> I don't see anything that would prevent this from working.. if you 
>> have a patch which does this and crashes, I'll take a look at it.
> 
> Okay I will try to regenerate this situation tomorrow afternoon, which 
> will be my next chance.

Well the panic did not return, I guess whatever I was doing that 
provoked it I am not doing any more.  So I changed it back to the 
sdata->dev->ifindex that the normal code path uses and confirmed that 
continued to worked okay.

However when I went on to look at leveraging that to find out if the 
originating interface was in Monitor mode, it seems that it might be a 
little bit more expensive to do that -- and it would have to be done for 
every tx packet in order to find out if it was injected.  By contrast 
with the currently proposed staged system at each level the information 
is always available without processing, and the overhead for the common 
case where the packet was not injected is just testing if the if type 
was monitor, and then later testing a bit in flags that are already 
available.

 From looking around the existing code, it seems something like this is 
called for to use the ifindex instead:

__ieee80211_tx_prepare(...)
{
	struct ieee80211_tx_packet_data *pkt_data;

	/* skb->cb is still valid by this time? */

	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;

	/* dev_get_by_index holds a read lock and iterates
	 * a hlist, done for every tx packet */

	originating_dev = dev_get_by_index(pkt_data->ifindex);
	if(!originating_dev) goto skipped;
	if (unlikely(!is_ieee80211_device(originating_dev, dev))) {
		goto give_up_dev;
	}

	originating__sdata = IEEE80211_DEV_TO_SUB_IF(dev);
	if(!originating__sdata) goto give_up_dev;

	if (unlikely(originating__sdata->type==IEEE80211_IF_TYPE_MNTR)){
...
	}
	give_up_dev:
	dev_put(originating_dev);
	skipped:
...
}

Given this, if it is actually the leanest implementation of using 
ifindex, is it still preferred?

-Andy
