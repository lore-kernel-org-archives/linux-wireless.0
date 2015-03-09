Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from edge10.ethz.ch ([82.130.75.186]:8182 "EHLO edge10.ethz.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752275AbbCITsT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 15:48:19 -0400
Message-ID: <54FDF901.8060808@student.ethz.ch> (sfid-20150309_204822_665553_330BC8C3)
Date: Mon, 9 Mar 2015 20:48:17 +0100
From: kilian risse <krisse@student.ethz.ch>
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Virtual Interfaces with iwlwifi
References: <C768C63E9A2F584FACC2A65D915E5A2830535956@MBX13.d.ethz.ch>	 <C768C63E9A2F584FACC2A65D915E5A2830535975@MBX13.d.ethz.ch> <1425921599.32409.4.camel@redhat.com>
In-Reply-To: <1425921599.32409.4.camel@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think I figured it out - I tried to create two interfaces of the same 
type station - which is not supported according to the "iw phy0 info".

I use a intel 7260 card with a 3.18.7 Kernel.
The command I used was "iw phy phy0 interface add wlan0 type station".
Is this a limitation in hardware or software?

Kilian

On 03/09/2015 06:19 PM, Dan Williams wrote:
> On Mon, 2015-03-09 at 16:53 +0000, Risse Kilian wrote:
>> Hi
>>
>> I tried to create a second interface and connect to another AP. But I was unable to do so. As I tried to enable the second interface I got an error: Device or resource busy. So am I right assuming that this is not possible with the iwlwifi driver?
>
> What specific hardware do you have?
> What kernel version do you have?
> What specific command were you using to create the second interface?
> What are the "software interface modes" and "valid interface
> combinations" sections output from "iw phy0 info"?
>
> It's certainly possible and supported with iwlwifi, but it depends on
> specific hardware, the driver, etc.
>
> Dan
>
