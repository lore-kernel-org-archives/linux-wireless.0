Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:53958 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbYE2IHU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:07:20 -0400
Received: by rv-out-0506.google.com with SMTP id l9so3973333rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2008 01:07:20 -0700 (PDT)
Message-ID: <1ba2fa240805290107r2c3b68cbh4bf18e86c9f96335@mail.gmail.com> (sfid-20080529_100724_546703_13450EFE)
Date: Thu, 29 May 2008 11:07:19 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: question about ...: wrong count at exit"
Cc: "Holger Schurig" <hs4233@mail.mn-solutions.de>,
	"Linux Wireless" <linux-wireless@vger.kernel.org>,
	libertas-dev@lists.infradead.org
In-Reply-To: <1212047361.16917.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <200805290937.22146.hs4233@mail.mn-solutions.de>
	 <1212047361.16917.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 29, 2008 at 10:49 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-05-29 at 09:37 +0200, Holger Schurig wrote:
>> After pulling the newest sparse, I got some new sparse warnings
>> which puzzle me. Here's one of them:
>>
>> drivers/net/wireless/libertas/main.c:477:9: warning: context imbalance in 'lbs_eth_stop': wrong count at exit
>> drivers/net/wireless/libertas/main.c:477:9:    context 'lock': wanted 0, got 1
>>
>> However, the function looks quite innocent, and I cannot see
>> any imbalance there. Did I oversee something or is that a
>> problem of sparse?
>
>>         spin_lock_irq(&priv->driver_lock);
>>         priv->infra_open = 0;
>>         netif_stop_queue(dev);
>>         spin_unlock_irq(&priv->driver_lock);
>
> I think it's a sparse problem caused by my patch, I sent further patches
> to fix it but they were never applied (and had a slight remaining
> problem too). If you look at the pre-processed function it should become
> obvious.
>

I got plenty of this in the mac80211 reported with newest sparse, but
they looks false caused by 'goto statements'

Tomas
