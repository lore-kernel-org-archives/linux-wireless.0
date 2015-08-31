Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48796 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752967AbbHaNL2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 09:11:28 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	<1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	<55E289A3.6030001@lwfinger.net> <wrfjegik8vqy.fsf@redhat.com>
	<1440983160.3276.18.camel@perches.com>
Date: Mon, 31 Aug 2015 09:11:26 -0400
In-Reply-To: <1440983160.3276.18.camel@perches.com> (Joe Perches's message of
	"Sun, 30 Aug 2015 18:06:00 -0700")
Message-ID: <wrfjd1y361s1.fsf@redhat.com> (sfid-20150831_151131_096584_E544A2DD)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Joe Perches <joe@perches.com> writes:
> On Sun, 2015-08-30 at 14:41 -0400, Jes Sorensen wrote:
>> Larry Finger <Larry.Finger@lwfinger.net> writes:
> []
>> >> +	dev_info(&priv->udev->dev, "%s: dumping efuse (0x%02lx bytes):\n",
>> >> +		 __func__, sizeof(struct rtl8192cu_efuse));
>> >
>> > On a 32-bit PowerPC, the above line outputs the following:
>> >
>> > warning: format ‘%lx’ expects argument of type ‘long unsigned int’,
>> > but argument 4 has type ‘unsigned int’ [-Wformat]
>> >
>> > This issue does not affect the object code, but it should be
>> > fixed. Setting the format specifier to %02x and adding a cast of (int)
>> > before the "size_of" will fix it on both sets of systems.
>> 
>> Ewww, I didn't realize PowerPC 32 was this ugly :( Adding (long) as a
>> cast would have the same effect here, but we will end up with an ugly
>> cast in either case.
>
> don't cast at all and use format specifier %zu instead

Would be %zx in this case, but thanks, I updated that.

Jes
