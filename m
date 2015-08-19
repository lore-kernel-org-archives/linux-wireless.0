Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f181.google.com ([209.85.192.181]:32934 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbbHSSBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2015 14:01:30 -0400
Message-ID: <1440007287.6610.25.camel@edumazet-glaptop2.roam.corp.google.com> (sfid-20150819_200136_940983_127BE691)
Subject: Re: [RFC v2 0/3] add TSO / A-MSDU TX for iwlwifi
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ido@wizery.com" <ido@wizery.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Date: Wed, 19 Aug 2015 11:01:27 -0700
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E825252@hasmsx107.ger.corp.intel.com>
References: <1439989181-4444-1-git-send-email-emmanuel.grumbach@intel.com>
	 <1439993647.6610.8.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E8250B6@hasmsx107.ger.corp.intel.com>
	 <1440000515.6610.20.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E825167@hasmsx107.ger.corp.intel.com>
	 <1440004777.6610.23.camel@edumazet-glaptop2.roam.corp.google.com>
	 <0BA3FCBA62E2DC44AF3030971E174FB32E825252@hasmsx107.ger.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-08-19 at 17:56 +0000, Grumbach, Emmanuel wrote:
> 

> So I feel that making net/core/tso.c more complicated just because of
> our craziness seems an overkill to me.
> I'll try a bit harder to see how I can use net/core/tso.c, but I have to
> say I am pessimistic.

net/core/tso.c is WIP, feel free to expand it to make it more generic
and meet your needs.

The point is : we want a core infrastructure, not something that each
individual driver implements in ~500 lines of code :(


