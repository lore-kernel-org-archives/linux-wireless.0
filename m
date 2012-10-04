Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1768 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757542Ab2JDVKb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 17:10:31 -0400
Message-ID: <506DFB31.8080208@broadcom.com> (sfid-20121004_231036_771925_31D3CC54)
Date: Thu, 4 Oct 2012 23:10:09 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Dan Carpenter" <dan.carpenter@oracle.com>
cc: "Brett Rudley" <brudley@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	"Kan Yan" <kanyan@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Pieter-Paul Giesberts" <pieterpg@broadcom.com>,
	linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	kernel-janitors@vger.kernel.org
Subject: Re: [patch 2/3] brcmfmac: fix end of loop check (signedness
 bug)
References: <20121003060631.GB3802@elgon.mountain>
 <506DB82B.9010106@broadcom.com> <20121004184212.GO13767@mwanda>
In-Reply-To: <20121004184212.GO13767@mwanda>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2012 08:42 PM, Dan Carpenter wrote:
> On Thu, Oct 04, 2012 at 06:24:11PM +0200, Arend van Spriel wrote:
>> On 10/03/2012 08:06 AM, Dan Carpenter wrote:
>>> The problem here is that we loop until "remained_buf_len" is less than
>>> zero, but since it is unsigned, it never is.
>>>
>>> "remained_buf_len" has to be large enough to hold the value from
>>> "mgmt_ie_buf_len".  That variable is type u32, but it only holds small
>>> values so I have changed to both variables to int.
>>>
>>> Also I removed the bogus initialization from "mgmt_ie_buf_len" so that
>>> GCC can detect if it is used unitialized.  I moved the declaration of
>>> "remained_buf_len" closer to where it is used so it's easier to read.
>>>
>>
>> Hi Dan,
>>
>> Good catch. I applied the patch internally on our HEAD and had it
>> reviewed. We did not take moving the declaration as we prefer to
>> have all variables at the top of the function. It makes it easier to
>> find what is declared in a function and whether exceeding the local
>> variable limit mentioned in Chapter 6. Functions of the CodingStyle
>> (we are exceeding it already ;-) ).
>>
>> Are you ok with us submitting it? It would be sent out for 3.8 or do
>> you prefer to have it fixed in 3.7?
>
> Uh, I don't know how hard it is to trigger this bug.  If it's
> impossible to trigger then we could wait until 3.8 otherwise I
> would tend to merge it into 3.7 given that we haven't hit -rc1 yet.

Hi Dan,

I don't know either, but to safe myself the trouble I will post it to 
John for 3.7. Thanks.

Gr. AvS


