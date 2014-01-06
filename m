Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:7348 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753247AbaAFKz6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 05:55:58 -0500
Message-ID: <52CA8BBC.7070601@broadcom.com> (sfid-20140106_115601_464675_D5440DAA)
Date: Mon, 6 Jan 2014 11:55:56 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: py80211 update on github
References: <51D49027.9010803@broadcom.com> <52CA77B5.5060100@broadcom.com>	 (sfid-20140106_103040_059390_26262C87) <1389004577.5891.6.camel@jlt4.sipsolutions.net>
In-Reply-To: <1389004577.5891.6.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/06/2014 11:36 AM, Johannes Berg wrote:
> On Mon, 2014-01-06 at 10:30 +0100, Arend van Spriel wrote:
> 
>> In the christmas holiday I tinkered a bit more on py80211. It comes with
>> a utility to extract definitions and netlink policies from the nl80211
>> source files. What is currently on github is in prototype state. It can
>> retrieve all wiphy information including band, frequency and rate
>> information. It relies on policy information and it turned out that not
>> all attributes are properly initialized in nl80211_policy. One that I
>> added manually is NL80211_ATTR_SUPPORTED_IFTYPES, which should actually
>> be typed as NLA_NESTED. There are other attributes that are not covered yet.
> 
> This makes sense because the kernel policy only covers things that are
> sent *to* the kernel. In some very rare cases, the stuff sent *to* the
> kernel and *by* the kernel may even differ, so you may have to add some
> special cases.

Yeah, I realized that indeed the policies in the kernel only cover
validation *to* the kernel. In iw the policies are used rarely and most
type information is covered in the code. py80211 relies on policies to
obtain the type information and I was hoping to extract it from the
kernel/iw code. I may end up maintaining it in py80211.

Gr. AvS

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

