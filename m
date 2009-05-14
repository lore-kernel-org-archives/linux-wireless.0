Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:44686 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbZENWRr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 May 2009 18:17:47 -0400
Received: by wf-out-1314.google.com with SMTP id 26so947531wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 14 May 2009 15:17:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890905141426k479e6707xb4f3d07d7420e7ea@mail.gmail.com>
References: <43e72e890905141052o1f072bc5m4bc5922327617f8b@mail.gmail.com>
	<1242327298.4227.25.camel@localhost.localdomain> <43e72e890905141207m3c27588ex13190b2ed6010e30@mail.gmail.com>
	<1242334636.4227.134.camel@localhost.localdomain> <43e72e890905141426k479e6707xb4f3d07d7420e7ea@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 14 May 2009 15:17:28 -0700
Message-ID: <43e72e890905141517m4f7f6d27i5e89044dfd058e3a@mail.gmail.com>
Subject: Re: Scan while TX/RX'ing a lot of data
To: Dan Williams <dcbw@redhat.com>,
	Jouni Malinen <Jouni.Malinen@atheros.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Aeolus.Yang@atheros.com,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	Gaurav.Jauhar@atheros.com, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 14, 2009 at 2:26 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Thu, May 14, 2009 at 1:57 PM, Dan Williams <dcbw@redhat.com> wrote:

>> Maybe if there was a way to figure out how full mac80211's QoS buckets
>> were, that would help?  Or get a frame counts from each of the 4 QoS
>> buckets individually?  That would allow NM to make more intelligent
>> decisions about stuff.  Maybe a more detailed nl80211 stats interface
>> would do the trick here.
>
> Would help for debugging too anyway, since QOS uses the new device
> queues maybe that might already be available?

I should note the netdevice queues we use are _in_ mac80211 and do not
actually represent each _device_ hardware queue. We use them for
queuing frames for master interface to then send to the driver. Still
-- it seems this may be helpful. This would help with TX, we would
need something else for RX.

  Luis
