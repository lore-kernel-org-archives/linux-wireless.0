Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:15697 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865AbZKIN65 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 08:58:57 -0500
Received: by ey-out-2122.google.com with SMTP id 25so169498eya.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 05:59:02 -0800 (PST)
References: <1257770381-7680-1-git-send-email-rpaulo@gmail.com> <1257770381-7680-12-git-send-email-rpaulo@gmail.com> <1257771552.29454.171.camel@johannes.local> <B2865F30-1886-4985-AB76-2AAB769530F4@gmail.com> <1257773259.29454.175.camel@johannes.local>
In-Reply-To: <1257773259.29454.175.camel@johannes.local>
Mime-Version: 1.0 (Apple Message framework v1076)
Content-Type: text/plain; charset=us-ascii; format=flowed; delsp=yes
Message-Id: <9D7C4644-B28F-4E50-93F2-A9CF126AF481@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>
From: Rui Paulo <rpaulo@gmail.com>
Subject: Re: [PATCH 11/21] mac80211: add WLAN_EID_RANN
Date: Mon, 9 Nov 2009 13:58:58 +0000
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 Nov 2009, at 13:27, Johannes Berg wrote:

> Hi,
>
>>> On Mon, 2009-11-09 at 12:39 +0000, Rui Paulo wrote:
>>>> Process the RX of RANN information elements.
>>>
>>> That commit log is not really right.
>>
>> You're right. Is "Parse the RANN information element" a better one?
>
> You're not really parsing them either ... Maybe "add code to find RANN
> IE" or something? Doesn't matter that much. For all I care 11 and 12
> could be collapsed into one patch.

Ok, I'll merge 11 and 12.

>>> I'd definitely prefer if here you added a 17-byte long struct that
>>> explains the layout of the IE, and then used that in patch 12. Also
>>> it's
>>> probably useful to check the length directly in
>>> ieee802_11_parse_elems.
>>
>> I prefer structures describing the IE layout too, but I was following
>> the mesh code on this. If structure layouts are preferable, then  
>> there
>> are 4 mesh IEs that should probably be changed.
>
> Yeah, but I think at least one of them had a problem with struct
> description because it was kinda variable. Not sure if that's still  
> the
> case though.

There are two variable IEs according to the latest draft. Right now we  
only support the fixed case (i.e., IEs have only one target and target  
count == 1) so we can make it a struct and deal with it later,  
assuming there's nothing wrong with using a struct to hold variable  
data (I see that we already use structs to hold variable IEs).

>
>> Regarding to the length check, I was also following the way the mesh
>> code does it. Again, if we want to change RANN, we should probably
>> also change PREQ, PREP and PERR.
>
> True too.
>
> But you were just adding a new one, so I figured I could ask you to  
> make
> the new one nicer, but couldn't really ask you to fix the old  
> ones :) If
> you want to, I'd welcome it.

Heh, ok. :-)

--
Rui Paulo

