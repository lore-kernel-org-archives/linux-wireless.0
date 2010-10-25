Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37753 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab0JYQ1j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Oct 2010 12:27:39 -0400
Received: by ewy7 with SMTP id 7so4407705ewy.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Oct 2010 09:27:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1287995967.3587.9.camel@jlt3.sipsolutions.net>
References: <AANLkTinP32=snam3Bex+OC8LL00awfjrJz4834mhOaNL@mail.gmail.com>
	<1287995967.3587.9.camel@jlt3.sipsolutions.net>
Date: Mon, 25 Oct 2010 09:27:38 -0700
Message-ID: <AANLkTik-SaE2ShV7H6Lv1qFQ-FM5fPuWGws6pWM+b6Go@mail.gmail.com>
Subject: Re: Modifying the driver iwlwifi
From: Blaise Gassend <blaise@willowgarage.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Cassiano Tartari, Eng." <falecom@cassianotartari.eng.br>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 25, 2010 at 1:39 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2010-10-21 at 14:17 -0200, Cassiano Tartari, Eng. wrote:
>> Its basic idea is that a client doesn't wait each
>> response to go to the next step, so just do: AUTH REQ -> ASSOC REQ ->
>> DHCP DISC -> DHCP REQ -> ARP QUERY and a PING THROUGH to verify that
>> an end-to-end connection is available.
>
> I'd just like to point out that for various reasons (that I invite you
> to research for yourself) there's no way this can work in encrypted
> networks, or against compliant/certified access points.

I had a look at the paper, and the original poster seems to have
exaggerated the paper's claims. They do indeed do the authentication
and association request before getting responses. For everything else,
they wait to get the response for the previous stage. The main
difference is that they greatly reduce the timeouts before retrying at
each stage. The paper is also limited to non-encrypted networks.
