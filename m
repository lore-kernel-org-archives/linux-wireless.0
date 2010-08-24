Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.redfish-solutions.com ([66.232.79.143]:43357 "EHLO
	mail.redfish-solutions.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755970Ab0HXVaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Aug 2010 17:30:08 -0400
Message-ID: <4C7439CB.6040208@redfish-solutions.com>
Date: Tue, 24 Aug 2010 14:29:47 -0700
From: Philip Prindeville <philipp_subx@redfish-solutions.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: Re: [PATCH 3/3] nl80211: New command for setting TX rate mask for
 rate control
References: <20091229105945.GD18493@jm.kir.nu>	 <4C6DA19B.7010606@redfish-solutions.com>	 <1282296004.3785.25.camel@jlt3.sipsolutions.net>	 <4C6EAE6C.50001@redfish-solutions.com>	 <4C6F07AA.3080606@redfish-solutions.com> <1282644994.3695.8.camel@jlt3.sipsolutions.net>
In-Reply-To: <1282644994.3695.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  On 8/24/10 3:16 AM, Johannes Berg wrote:
> On Fri, 2010-08-20 at 15:54 -0700, Philip Prindeville wrote:
>
>> What I'm trying to say is that even though the driver handles the
>> condition of nla_type == 0 when it generates the message, the
>> condition isn't handled correct when the message finally gets passed
>> up into user-space, because the above sequence in the netlink library
>> gets hit both for "iw" and "hostapd".
>>
>> So it's not enough to handle it correctly in the driver: it needs to
>> be handled in libnl as well.
>>
>> There are 3 potential solutions:
>>
>> (1) go with a 1-based enum for the band, instead of 0-based;
>> (2) remove the test for nla_type == 0 in nla_parse() in libnl;
>> (3) use a way to convey the band that doesn't involve overloading
>> nla_type;
>>
>> What's the correct fix?
> You managed to totally throw me off course ... The problem is completely
> unrelated to this, see the patch I just sent :-)
>
> johannes
>

Confirmed your fix.  http://pastebin.ca/1924624

Thanks!

