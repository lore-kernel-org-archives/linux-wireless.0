Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:33144 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbbHTONW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 10:13:22 -0400
Message-ID: <1440079999.6610.48.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150820_161330_808162_39FEBC18)
Subject: Re: [RFC v2 3/3] iwlwifi: mvm: transfer the truesize to the last
 TSO segment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ido@wizery.com" <ido@wizery.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Sharon, Sara" <sara.sharon@intel.com>
Date: Thu, 20 Aug 2015 07:13:19 -0700
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E82654B@hasmsx107.ger.corp.intel.com>
References: <1439989181-4444-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1439989181-4444-4-git-send-email-emmanuel.grumbach@intel.com>
	 <1439994266.6610.14.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E8253CF@hasmsx107.ger.corp.intel.com>
	 <1440016762.6610.33.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E8257BD@hasmsx107.ger.corp.intel.com>
	 <1440076269.6610.39.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E82654B@hasmsx107.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-08-20 at 13:53 +0000, Grumbach, Emmanuel wrote:

> I do keep the original skb: it becomes the first 802.11 packet generated
> from that LSO skb. Thing is that it will be freed first and I wanted the
> *last packet* to release the pressure on the socket.

Just change this to free it last. It is that simple.

> So I guess that skb_still_in_host_queue will still find it and avoid
> retransmissions at least until the first skb of the LSO is freed.
> But unless you are fine with releasing the pressing on the socket as
> soon as the *first* 802.11 skb is freed, I need that code.
> 
> I'll try to look at dev->gso_max_size that you mentioned below. This can
> really be a game changer for me.

Honestly, if your TSO patches do not use existing infra, I will NACK
them.

If existing infra is not good enough, you have the power to change it.

Fully re-implementing TSO (or GRO) in a device driver is a non starter.


