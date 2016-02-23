Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:56160 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751059AbcBWOxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 09:53:30 -0500
Subject: Re: [PATCH 2/2] mac80211: add NEED_ALIGNED4_SKBS hw flag
To: Johannes Berg <johannes@sipsolutions.net>,
	Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless@vger.kernel.org
References: <1455876110-12758-1-git-send-email-janusz.dziedzic@tieto.com>
 <1455876110-12758-2-git-send-email-janusz.dziedzic@tieto.com>
 <1456237769.9910.20.camel@sipsolutions.net>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56CC725D.1080209@openwrt.org> (sfid-20160223_155334_207837_3648EC7C)
Date: Tue, 23 Feb 2016 15:53:17 +0100
MIME-Version: 1.0
In-Reply-To: <1456237769.9910.20.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-02-23 15:29, Johannes Berg wrote:
> On Fri, 2016-02-19 at 11:01 +0100, Janusz Dziedzic wrote:
>> HW/driver should set NEED_ALIGNED4_SKBS flag in case
>> require aligned skbs to four-byte boundaries.
>> This affect only TX direction.
>> 
>> Padding is added after ieee80211_hdr, before IV/LLC.
> 
> I'm still not super happy with how invasive these patches are.
> 
> Perhaps we could live with this being done only for the fast-xmit case?
I don't think we should pass padded vs non-padded frames depending on
whether fast-xmit was used. The non-fast-xmit codepath could simply do
the memmove at the end of the tx handlers though.

- Felix
