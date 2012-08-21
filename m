Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50174 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2HUE4H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2012 00:56:07 -0400
Received: by eeil10 with SMTP id l10so2021067eei.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Aug 2012 21:56:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345478494.4459.30.camel@jlt3.sipsolutions.net>
References: <502D0C72.2050207@lwfinger.net> <1345459509.4459.5.camel@jlt3.sipsolutions.net>
 <50325D89.9080209@lwfinger.net> <1345478494.4459.30.camel@jlt3.sipsolutions.net>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Tue, 21 Aug 2012 06:55:46 +0200
Message-ID: <CA+XFjiqyqAiZGcBZB6u13FquBbkgBLDbDFAMLnHRMiK6P0Heww@mail.gmail.com> (sfid-20120821_065646_151608_E8EE2C8C)
Subject: Re: Missing firmware iwlwifi-2030-5.ucode
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 20, 2012 at 6:01 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-08-20 at 10:53 -0500, Larry Finger wrote:
>
>> I'm still concerned about the bigger picture. I can understand that the -5
>> version was experimental, but why was a driver released that needed a firmware
>> version that could never be obtained? If any driver version needs a particular
>> firmware, the fw must be available as long as anyone might be using that driver.
>> To me, that means forever.
>
> Well, yes. That firmware, however, never was never available publicly.
> The fact that the driver was released anyway is due to us working on the
> driver upstream while working with the experimental internal firmware.
>
> johannes

Perhaps we should add a Kconfig option to disable internal development
hardware - with that option unchecked, support for hardware that is
not on the market is disabled, with a printk warning to upgrade the
driver in case a user tries to use a driver with a card that it thinks
is internal-only. This way, users will get a meaningful error message,
rather than a misleading "missing firmware" one.
The Kconfig option should also come with a big warning of "Say N
unless you are an Intel employee". Maybe it should even be marked
BROKEN, like N-PHY was in b43 before it became usable.
