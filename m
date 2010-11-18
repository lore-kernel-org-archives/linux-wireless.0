Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57866 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932515Ab0KRR3j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 12:29:39 -0500
Received: by bwz15 with SMTP id 15so2994016bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 09:29:37 -0800 (PST)
Message-ID: <4CE5627A.6060206@lwfinger.net>
Date: Thu, 18 Nov 2010 11:29:30 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: =?UTF-8?B?TWljaGFlbCBCw7xzY2g=?= <mb@bu3sch.de>
CC: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org
Subject: Re: [PATCH] ssb: fail registration for unknown SPROM revision
References: <1288823326-9686-1-git-send-email-zajec5@gmail.com>	 <1288823326-9686-2-git-send-email-zajec5@gmail.com>	 <20101116212321.GF10774@tuxdriver.com> <1290013976.2513.14.camel@maggie>	 <20101118162748.GB2468@tuxdriver.com> <1290098156.12596.2.camel@maggie>	 <AANLkTimh_8X1uRPudmQLDOTeA_X0ciR9BbDgyahLDMSs@mail.gmail.com>	 (sfid-20101118_174421_892253_3B53C8D3) <1290098865.12596.6.camel@maggie>	 <4CE55C3B.6020803@lwfinger.net> (sfid-20101118_180314_721728_2D534AE3) <1290100075.12596.8.camel@maggie>
In-Reply-To: <1290100075.12596.8.camel@maggie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/18/2010 11:07 AM, Michael Büsch wrote:
> On Thu, 2010-11-18 at 11:02 -0600, Larry Finger wrote: 
>> On 11/18/2010 10:47 AM, Michael Büsch wrote:
>>> If it would really succeed to initialize the device, this would be a
>>> regulatory issue, because the sprom contains various power amplifier
>>> calibration data. I think it should rather fail and be fixed correctly
>>> instead of incorrectly using rev1 in that case.
>>
>> I agree that it is better to fail than use incorrect power data.
>>
>> Would it be useful if the SPROM data were logged when the revision is crap?
> 
> 
> We need to keep in mind that there will be no new SSB devices.
> It seems pretty much EOL'ed by Broadcom.
> So I'm not sure whether this would be of any use or just random dead
> code.

Good point. When we get the data for the one case we know exists, we will have a
better idea if a special quirk for this case is feasible. Assuming that this is
not the only example of this hardware, then we might limit the breakage from
this patch. At least the random code would be needed and useful in keeping our
maintainer happy, which has a some merit.

Larry
