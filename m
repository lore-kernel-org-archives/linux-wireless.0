Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34075 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189Ab0JYRiq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 13:38:46 -0400
Received: by wwe15 with SMTP id 15so3734034wwe.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 10:38:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik-SaE2ShV7H6Lv1qFQ-FM5fPuWGws6pWM+b6Go@mail.gmail.com>
References: <AANLkTinP32=snam3Bex+OC8LL00awfjrJz4834mhOaNL@mail.gmail.com>
 <1287995967.3587.9.camel@jlt3.sipsolutions.net> <AANLkTik-SaE2ShV7H6Lv1qFQ-FM5fPuWGws6pWM+b6Go@mail.gmail.com>
From: "Cassiano Tartari, Eng." <falecom@cassianotartari.eng.br>
Date: Mon, 25 Oct 2010 15:38:24 -0200
Message-ID: <AANLkTik12g6kmynbgyhPuu+B5jZ9Swv+1PhAg9EKMByw@mail.gmail.com>
Subject: Re: Modifying the driver iwlwifi
To: Blaise Gassend <blaise@willowgarage.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 25, 2010 at 2:27 PM, Blaise Gassend <blaise@willowgarage.com> wrote:
> On Mon, Oct 25, 2010 at 1:39 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>> On Thu, 2010-10-21 at 14:17 -0200, Cassiano Tartari, Eng. wrote:
>>> Its basic idea is that a client doesn't wait each
>>> response to go to the next step, so just do: AUTH REQ -> ASSOC REQ ->
>>> DHCP DISC -> DHCP REQ -> ARP QUERY and a PING THROUGH to verify that
>>> an end-to-end connection is available.
>>
>> I'd just like to point out that for various reasons (that I invite you
>> to research for yourself) there's no way this can work in encrypted
>> networks, or against compliant/certified access points.

In my work, I could use a open network.

How can I know if a AP is "compliant/certified" ? I'm such a newbie.

I read in the manual of the AP: The DWL-2100AP is also interoperable
with other 802.11g and 802.11b
standards-compliant devices.


>
> I had a look at the paper, and the original poster seems to have
> exaggerated the paper's claims. They do indeed do the authentication
> and association request before getting responses. For everything else,
> they wait to get the response for the previous stage. The main
> difference is that they greatly reduce the timeouts before retrying at
> each stage. The paper is also limited to non-encrypted networks.

My objetive in my current job is just that, reduce the time of authentication.

Someone has a better idea or solution to reduce the association time?
I need to use DHCP and could be a open network.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
