Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:33898 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761597AbZE1GfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 02:35:21 -0400
MIME-Version: 1.0
Reply-To: maxim@mox.ru
In-Reply-To: <1243480131.16597.174.camel@deadeye>
References: <20090526112157.GA19976@doriath.ww600.siemens.net>
	 <1243336988-20109-1-git-send-email-dbaryshkov@gmail.com>
	 <1243336988-20109-2-git-send-email-dbaryshkov@gmail.com>
	 <1243480131.16597.174.camel@deadeye>
Date: Thu, 28 May 2009 10:35:20 +0400
Message-ID: <6097c490905272335t55d96240j904c6f72438bd7fd@mail.gmail.com>
Subject: Re: [PATCH 2/5] net: add IEEE 802.15.4 partial implementation
From: Maxim Osipov <maxim.osipov@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
	netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
	slapin@ossfans.org, maxim.osipov@siemens.com,
	dmitry.baryshkov@siemens.com, oliver.fendt@siemens.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> [...]
>> --- /dev/null
>> +++ b/include/net/ieee802154/nl.h
> [...]
>> +/* commands */
>> +/* REQ should be responded with CONF
>> + * and INDIC with RESP
>> + */
>> +enum {
>> +     __IEEE802154_COMMAND_INVALID,
>> +
>> +     IEEE802154_ASSOCIATE_REQ,
>> +     IEEE802154_ASSOCIATE_CONF,
>> +     IEEE802154_DISASSOCIATE_REQ,
>> +     IEEE802154_DISASSOCIATE_CONF,
>> +     IEEE802154_GET_REQ,
>> +     IEEE802154_GET_CONF,
>> +/*   IEEE802154_GTS_REQ, */
>> +/*   IEEE802154_GTS_CONF, */
>
> Why are some of these commented out?  Since they're apparently exposed
> to user-space you can't insert them later.
>

We are working to define a next version of netlink API for the stack
right now. But taking into account, that iz tool & upper layers of
stack will be the only users of this API at least for next year, and
IEEE802.15.4 spec is evolving, it is probably not necessary to come up
with a very final version.

Kind regards,
Maxim
