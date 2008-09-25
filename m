Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:37253 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752658AbYIYQtK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Sep 2008 12:49:10 -0400
Subject: Re: [PATCH] wireless: consolidate on a single escape_essid
	implementation
From: Dan Williams <dcbw@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1222318157.10563.22.camel@johannes.berg>
References: <>  <1222294536-24367-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20080925_010455_582253_D66BE03B)  <1222317983.10563.20.camel@johannes.berg>
	 (sfid-20080925_064714_797821_C549800C)  <1222318157.10563.22.camel@johannes.berg>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 12:47:59 -0400
Message-Id: <1222361279.14444.6.camel@localhost.localdomain> (sfid-20080925_184916_946462_496EB8A9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-09-25 at 06:49 +0200, Johannes Berg wrote:
> On Thu, 2008-09-25 at 06:46 +0200, Johannes Berg wrote:
> 
> > > +	essid_len = min(essid_len, (u8) IW_ESSID_MAX_SIZE);
> > > +	while (essid_len--) {
> > > +		if (*s == '\0') {
> > > +			*d++ = '\\';
> > > +			*d++ = '0';
> > > +			s++;
> > > +		} else {
> > > +			*d++ = *s++;
> > > +		}
> > > +	}
> > > +	*d = '\0';
> > > +	return escaped;
> > > +}
> > > +EXPORT_SYMBOL(escape_essid);
> 
> Also, it seems like this should escape any non-printable characters, not
> just NUL?

Yes, it should escape any _non-ASCII_ characters.

Dan


