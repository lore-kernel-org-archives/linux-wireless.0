Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55867 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbaFXHhm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 03:37:42 -0400
Received: by mail-wi0-f170.google.com with SMTP id cc10so5396339wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 00:37:41 -0700 (PDT)
Message-ID: <53A92ACB.8080005@gmail.com> (sfid-20140624_093745_506059_CB3B2597)
Date: Tue, 24 Jun 2014 10:37:47 +0300
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Victor <silentworks@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: No channels available (no IR) in 5Ghz band for intel 7260-ac
References: <CAAnNoB_8MSR3S+VmFJUKKU4bO5zfeu1N_4-vQULqBf1_UbAqkg@mail.gmail.com> <20140624005030.GI1390@garbanzo.do-not-panic.com>
In-Reply-To: <20140624005030.GI1390@garbanzo.do-not-panic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 06/24/2014 03:50 AM, Luis R. Rodriguez wrote:
> On Mon, Jun 23, 2014 at 10:55:48PM +0200, Victor wrote:
>> Hello, first of all i'm not sure if this is the proper place to ask
>> since it seems mostly dev-related, but i have been looking everywhere
>> trying to find a solution without luck, so i'm not sure if i
>> encountered some kind of bug.
>>
>> Context: Setup of wireless AP using an intel 7260-ac on 5Ghz+ band, linux 3.15.1

This configuration is not supported.

>>
>> Problem found: the system shows all channels for Ghz band as (no IR),
>> so they can't be used
> 
> NO-IR means you can't initiate radiation, it doesn't mean they are
> disabled. The NO-IR flag then means you cannot use modes of operation
> that require you to initiate radiation first, there are two ways that
> can happen:
> 
>   * beconing -- AP, IBSS, Mesh, P2P master mode
>   * active scanning
> 
> You are still able to do passive scanning. The NO-IR flag can be
> lifted from channels if the driver does like the idea of trusting
> beacon hints:
> 
> http://wireless.kernel.org/en/developers/Regulatory/processing_rules#Beacon_hints
> 
> If the driver does not like those then you won't get the NO-IR flag
> lifted when a beacon is found. There device follows the desire by
> the silicon manufacturer and whoever deploys the device and integrates
> it into your system so anything beyond this should be checked with
> Intel folks.
> 
>   Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
