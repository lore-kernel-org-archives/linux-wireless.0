Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:64283 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbaLWTFj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 14:05:39 -0500
Message-ID: <5499BD01.9010709@broadcom.com> (sfid-20141223_200543_396478_2DCEF075)
Date: Tue, 23 Dec 2014 20:05:37 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Gautam Kumar Shukla <gautams@broadcom.com>,
	Avinash Patil <patila@marvell.com>
Subject: Re: [PATCH] cfg80211: add extensible feature flag attribute
References: <1419350119-29166-1-git-send-email-arend@broadcom.com>	 <1419350316.6091.9.camel@sipsolutions.net> <549992C0.4080708@broadcom.com> <1419350836.6091.10.camel@sipsolutions.net>
In-Reply-To: <1419350836.6091.10.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/23/14 17:07, Johannes Berg wrote:
> On Tue, 2014-12-23 at 17:05 +0100, Arend van Spriel wrote:
>
>> It compiles, but I guess nla_put() will fail for u8[0+8-1/8] field.
>
> I think it should work - the array is 0 bytes long, so sizeof() would
> return 0, and that turns out to be equivalent to nla_put_flag().

Another day, another lesson ;-) Wondered how netlink flags were 
transported in the message, but never bothered to look. Thanks.

Arend

> johannes
>

