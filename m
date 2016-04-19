Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:37637 "EHLO
	mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830AbcDSKWL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 06:22:11 -0400
Received: by mail-wm0-f52.google.com with SMTP id n3so21434547wmn.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Apr 2016 03:22:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1461057103.2766.15.camel@sipsolutions.net>
References: <1455710131-9967-1-git-send-email-grzegorz.bajorski@tieto.com>
	<56C4A5ED.4060802@openwrt.org>
	<CA+BoTQnf953+s++Wiug=BgEw2Ahu7cN1fbatmgyWi_6iAg_v2Q@mail.gmail.com>
	<1461057103.2766.15.camel@sipsolutions.net>
Date: Tue, 19 Apr 2016 12:22:08 +0200
Message-ID: <CA+BoTQ=Nw_pW3xk_zkRGw=kTXcfin8Py_xo+WMGsdLcgUiNV4Q@mail.gmail.com> (sfid-20160419_122215_790650_E32D5EBF)
Subject: Re: [RFC] mac80211: add extap functionality
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	Grzegorz Bajorski <grzegorz.bajorski@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 April 2016 at 11:11, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2016-04-18 at 13:23 +0200, Michal Kazior wrote:
>
>> You can't really implement complete IPv6 support in relayd though.
>> Link-local routing is forbidden by the spec explicitly and a patch
>> I've cooked up was rejected[1].
>>
>> I guess this leaves either the kernel's wireless stack to take up the
>> task or a special link device (for which I'm soliciting feedback now
>> [2]).
>
> I think you'll probably have to cook up a simple patch to get that
> question in [2] taken seriously :)

Heh.


> How much of that could be done with nftables btw?

I'm not sure if I follow. Do you mean what I've been able to do with
relayd until now? Without link-local ipv6 routing DHCPv6 is broken
(could probably addressed with DHCPv6 Relay to a certain degree) and
RS/RA may not work (if it propagates fe80:: routes). Also apps that
rely on fe80:: socket binding/addressing will fail.


Michał
