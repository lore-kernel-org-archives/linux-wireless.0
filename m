Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:43564 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751858AbZH0SGa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 14:06:30 -0400
Message-ID: <20090827210630.87827jbyof3xw17s@naisho.dyndns.info>
Date: Thu, 27 Aug 2009 21:06:30 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Dan Williams" <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rndis_wlan: increase scan timer delay
References: <20090827073854.27662.68095.stgit@fate.lan>
	<20090827134340.190465b7qixz4wao@naisho.dyndns.info>
	<1251382153.11788.3.camel@localhost.localdomain>
In-Reply-To: <1251382153.11788.3.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Dan Williams" <dcbw@redhat.com>:

> On Thu, 2009-08-27 at 13:43 +0300, Jussi Kivilinna wrote:
>> Please, don't merge this after all. Blocks scan too long and breaks
>> NetworkManager/wpa_supplicant.
>
> Hmm, it shouldn't.  I've seen other cards (ath5k a/b/g) take 5 to 8
> seconds to scan when they scan all the bands.  iwlwifi sometimes takes 5
> seconds to scan as well.  That should all be valid.
>

You're right, increasing delay exposed bug that caused reconnects.  
With short delay (re)scans didn't block so long and connection was  
established faster. With 6 sec connection was established eventually.

I'll send bug fix (workaround really, hw sometimes sends extra media  
connect events when setting WPA keys, which needs to be ignored) and  
resend this patch in two patch set after more testing.

-Jussi

