Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:38873 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752153Ab1EXRE5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 May 2011 13:04:57 -0400
Message-ID: <4DDBE538.1090902@gnu.org> (sfid-20110524_190459_907884_66CA9637)
Date: Tue, 24 May 2011 13:04:56 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Cristian Ionescu-Idbohrn <cristian.ionescu-idbohrn@axis.com>
CC: hostap@lists.shmoo.com, linux-wireless@vger.kernel.org
Subject: Re: Initial automatic channel selection implementation
References: <BANLkTi=-MDn9eAsRsoXtAetDOZehkMEhJw@mail.gmail.com>	<4DDBCE8C.5000608@gnu.org> <1105241841310.6936@somehost>
In-Reply-To: <1105241841310.6936@somehost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/24/2011 12:44 PM, Cristian Ionescu-Idbohrn wrote:
> On Tue, 24 May 2011, Pavel Roskin wrote:
>>
>> Speaking of channels, I think only some channels should be eligible for
>> automatic selection (that would be 1, 6 and 11 in the 2.4 GHz range).
>
> May I ask what the rationale behind that may be?

That's a safe distance between channels.  That's why channels 1, 6 and 
11 are used more often than others.

Our algorithm make select, say, channel 3.  That may be the most quiet 
channel at the moment.  We may use absolutely the best algorithm to 
determine that.  However, it is likely that APs operating on channels 1 
and 6 would eventually appear in vicinity, and out AP would interfere 
with both of them instead of just one of them.

Using a car analogy, consider channels 1, 6 and 11 like lanes on a 
highway.  Using other channels would be like driving between lanes.  It 
may seem safe, but only in absence of other traffic.

It's possible that the list of autoselectable channels could be country 
specific.  I would hate to add complexity to CRDA.  Hopefully we could 
device a simple algorithm to find the autoselectable channels based on 
the CRDA data.

-- 
Regards,
Pavel Roskin
