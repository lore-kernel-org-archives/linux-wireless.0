Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36805 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbbHTTzd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Aug 2015 15:55:33 -0400
Message-ID: <1440100531.6610.63.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150820_215544_212775_C9C57BE9)
Subject: Re: [RFC v2 3/3] iwlwifi: mvm: transfer the truesize to the last
 TSO segment
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ido@wizery.com" <ido@wizery.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"Sharon, Sara" <sara.sharon@intel.com>
Date: Thu, 20 Aug 2015 12:55:31 -0700
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8266E6@hasmsx107.ger.corp.intel.com>
References: <1439989181-4444-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1439989181-4444-4-git-send-email-emmanuel.grumbach@intel.com>
	 <1439994266.6610.14.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E8253CF@hasmsx107.ger.corp.intel.com>
	 <1440016762.6610.33.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E8257BD@hasmsx107.ger.corp.intel.com>
	 <1440076269.6610.39.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E82654B@hasmsx107.ger.corp.intel.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E8266E6@hasmsx107.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-08-20 at 19:34 +0000, Grumbach, Emmanuel wrote:

> 
> Err... no :( It won't work for me because the MSS impacts the number of
> segments which in turns impact the number of time the headers have to be
> copied which impacts... the A-MSDU maximal size which must be bigger
> than gso_max_size. So basically, a connection parameter (MSS) impacts a
> device parameter (gso_max_size). Now, of course, I could give up on
> small MSS connections and skb_gso_segment() skbs whose MSS is smaller
> than the default. This means that I give up on LSO in certain cases...
> 

We also have dev->gso_max_segs for this kind of problems.

Really, you should take closer look.

And _if_ some LSO packets must be segmented using skb_gso_segment()
in some rare cases, who cares ?

> I will get back to the drawing board and check what I can do to use /
> enhance the core infra... But it will be hard to lose functionality /
> efficiency just to use the core infra...

Please take your time. Pushing hard some local hacks is not sustainable.


