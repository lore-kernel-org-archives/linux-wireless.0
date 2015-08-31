Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0204.hostedemail.com ([216.40.44.204]:40512 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751433AbbHaBGE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Aug 2015 21:06:04 -0400
Message-ID: <1440983160.3276.18.camel@perches.com> (sfid-20150831_030626_427491_AF647CE7)
Subject: Re: [PATCH 1/1] New driver: rtl8xxxu (mac80211)
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	johannes@sipsolutions.net
Date: Sun, 30 Aug 2015 18:06:00 -0700
In-Reply-To: <wrfjegik8vqy.fsf@redhat.com>
References: <1440883083-32498-1-git-send-email-Jes.Sorensen@redhat.com>
	 <1440883083-32498-2-git-send-email-Jes.Sorensen@redhat.com>
	 <55E289A3.6030001@lwfinger.net> <wrfjegik8vqy.fsf@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2015-08-30 at 14:41 -0400, Jes Sorensen wrote:
> Larry Finger <Larry.Finger@lwfinger.net> writes:
[]
> >> +	dev_info(&priv->udev->dev, "%s: dumping efuse (0x%02lx bytes):\n",
> >> +		 __func__, sizeof(struct rtl8192cu_efuse));
> >
> > On a 32-bit PowerPC, the above line outputs the following:
> >
> > warning: format ‘%lx’ expects argument of type ‘long unsigned int’,
> > but argument 4 has type ‘unsigned int’ [-Wformat]
> >
> > This issue does not affect the object code, but it should be
> > fixed. Setting the format specifier to %02x and adding a cast of (int)
> > before the "size_of" will fix it on both sets of systems.
> 
> Ewww, I didn't realize PowerPC 32 was this ugly :( Adding (long) as a
> cast would have the same effect here, but we will end up with an ugly
> cast in either case.

don't cast at all and use format specifier %zu instead


