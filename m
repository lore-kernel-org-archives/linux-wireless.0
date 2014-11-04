Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173023pub.verizon.net ([206.46.173.23]:47151 "EHLO
	vms173023pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241AbaKDVTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 16:19:10 -0500
Received: from [192.168.1.2] ([108.28.174.148]) by vms173023.mailsrvcs.net
 (Oracle Communications Messaging Server 7.0.5.32.0 64bit (built Jul 16 2014))
 with ESMTPA id <0NEJ00JZP733ZW80@vms173023.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Tue, 04 Nov 2014 14:18:40 -0600 (CST)
Message-id: <5459349F.9020903@verizon.net> (sfid-20141104_221913_784006_45BE169C)
Date: Tue, 04 Nov 2014 15:18:39 -0500
From: "C. McPherson" <ccmcphe@verizon.net>
MIME-version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	radiotap@radiotap.org
Subject: Re: Vendor Namespace Question
References: <54591CF9.7030106@verizon.net>
 (sfid-20141104_203850_228702_C706EE9A)
 <1415130476.2064.22.camel@sipsolutions.net>
In-reply-to: <1415130476.2064.22.camel@sipsolutions.net>
Content-type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks so much for the info Johannes. I did notice that rx_status was 
getting full.  I'll go ahead and put it in skb->data, that's a good idea.
Clyde

On 11/04/2014 02:47 PM, Johannes Berg wrote:
> On Tue, 2014-11-04 at 13:37 -0500, C. McPherson wrote:
>> Hello all:
>> I was just trying to use the latest stable backports-3.18-rc1-1 and I
>> noticed that there is no longer structure members in the
>> ieee80211_rx_status structure for Vendor namespace information?  In my
>> backports 3.14 version I used them to add some register information to
>> the radiotap header in the lab. How does one use the vendor name space
>> without those structure members?
> We removed this from the Linux kernel because there was no driver using
> it and we needed the space for other purposes. That said, it shouldn't
> be too difficult to put it back by keeping the OUI/subtype also in the
> skb->data rather than the rx_status (which is now full enough to no
> longer have space for it, I believe)
>
> johannes
>
>

