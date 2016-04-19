Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:36240 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278AbcDSLaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 07:30:23 -0400
Received: by mail-wm0-f42.google.com with SMTP id v188so157922456wme.1
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2016 04:30:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461063747.2766.22.camel@sipsolutions.net>
References: <1455710131-9967-1-git-send-email-grzegorz.bajorski@tieto.com>
	<56C4A5ED.4060802@openwrt.org>
	<CA+BoTQnf953+s++Wiug=BgEw2Ahu7cN1fbatmgyWi_6iAg_v2Q@mail.gmail.com>
	<1461057103.2766.15.camel@sipsolutions.net>
	<CA+BoTQ=Nw_pW3xk_zkRGw=kTXcfin8Py_xo+WMGsdLcgUiNV4Q@mail.gmail.com>
	<1461063747.2766.22.camel@sipsolutions.net>
Date: Tue, 19 Apr 2016 13:30:21 +0200
Message-ID: <CA+BoTQkwoU=_pHa6s7=SVH=6gsAaQp-1-UmK1xRjshaBJFmY1A@mail.gmail.com> (sfid-20160419_133030_880053_D339EEC4)
Subject: Re: [RFC] mac80211: add extap functionality
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Grzegorz Bajorski <grzegorz.bajorski@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 April 2016 at 13:02, Johannes Berg <johannes@sipsolutions.net> wrote:
>> > How much of that could be done with nftables btw?
>
>> I'm not sure if I follow. Do you mean what I've been able to do with
>> relayd until now? Without link-local ipv6 routing DHCPv6 is broken
>> (could probably addressed with DHCPv6 Relay to a certain degree) and
>> RS/RA may not work (if it propagates fe80:: routes). Also apps that
>> rely on fe80:: socket binding/addressing will fail.
>
> Ok, so that makes sense I guess - but you were speaking of some packet
> mangling etc. and I was wondering if the nftables virtual machine could
> actually do something like that.

By mangling I meant packet payload needs to be modified in various
ways (typically just ether_dest/src, but ARP/NS/NA/DHCP needs extra
care). I don't think you can force a link-local packet to switch
interfaces through nftables anyway (or can you?). Even if you could I
guess you could argue it's a bug?


Michał
