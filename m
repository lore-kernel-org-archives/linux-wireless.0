Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.188]:25892 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399AbXKAWCN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 18:02:13 -0400
Received: by nf-out-0910.google.com with SMTP id g13so665203nfb
        for <linux-wireless@vger.kernel.org>; Thu, 01 Nov 2007 15:02:10 -0700 (PDT)
Message-ID: <472A4CDD.8080104@gmail.com> (sfid-20071101_220215_429069_69E3E37A)
Date: Thu, 01 Nov 2007 23:02:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: Re: [PATCH 5/7] ath5k: Move OFDM timings into a helper routine
References: <20071101043520.GC21987@pogo> <20071101043718.GD21987@pogo>	 <20071101043815.GE21987@pogo> <20071101043855.GF21987@pogo>	 <20071101215318.GC4182@pogo> <472A4BBD.4050207@gmail.com> <43e72e890711011501i3c2675f0o76af69f424946c5b@mail.gmail.com>
In-Reply-To: <43e72e890711011501i3c2675f0o76af69f424946c5b@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/01/2007 11:01 PM, Luis R. Rodriguez wrote:
> On 11/1/07, Jiri Slaby <jirislaby@gmail.com> wrote:
>> On 11/01/2007 10:53 PM, Luis R. Rodriguez wrote:
>>> +     if (!(ah->ah_version == AR5K_AR5212) ||
>>> +             !(channel->val & CHANNEL_OFDM))
>>> +             BUG();
>> Note, that BUG can return (on configurations where !CONFIG_BUG). It is my fault
>> writing you it won't, sorry! Could you post a patch which will add return from
>> here and also from places where the BUG() is used in other places?
> 
> The only case where this will trigger is if someone in the driver
> called this on hardware not supported so it is intended.
> 
> Do you want to BUG() and also return?

Yes, exactly.
