Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47049 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbaGBOMM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jul 2014 10:12:12 -0400
Message-ID: <1404310302.5102.41.camel@smile.fi.intel.com> (sfid-20140702_161230_019101_F1E956DD)
Subject: Re: [PATCH 5/6] staging: rtl8192e: re-use string_escape_mem()
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 02 Jul 2014 17:11:42 +0300
In-Reply-To: <1404308150.14624.73.camel@joe-AO725>
References: <1404307229-19186-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404307229-19186-6-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404308150.14624.73.camel@joe-AO725>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-07-02 at 06:35 -0700, Joe Perches wrote:
> On Wed, 2014-07-02 at 16:20 +0300, Andy Shevchenko wrote:
> > Let's use kernel's library function to escape a buffer.

[]

> > @@ -2965,15 +2965,8 @@ static inline const char *escape_essid(const char *essid, u8 essid_len)
> >  	}
> >  
> >  	essid_len = min(essid_len, (u8)IW_ESSID_MAX_SIZE);
> > -	while (essid_len--) {
> > -		if (*s == '\0') {
> > -			*d++ = '\\';
> > -			*d++ = '0';
> > -			s++;
> > -		} else {
> > -			*d++ = *s++;
> > -		}
> > -	}
> > +	d += string_escape_mem(essid, essid_len, escaped, sizeof(escaped) - 1,
> > +			       ESCAPE_NULL, NULL);
> 
> I'd've probably used
> 
> 	d += string_escape_mem(essid, essid_len, d, ...
> or
> 	d = escaped + string_escap_mem(essid, essid_len, escaped, ...
> 
> so there's some relation between the thing being added to
> 
> >  	*d = '\0';
> 
> or maybe not used d at all with
> 
> 	escaped[1 + string_escape_mem(etc...)] = 0;

Perhaps without '1 + ' part. I could update this as well if someone
insists.

> 
> >  	return escaped;
> >  }
> 
> Unrelated but this isn't a thread safe or multiple instance
> safe function.

Do you mean escape_ssid() or string_escape_mem() or both?

For the string_escape_mem() I think caller should take care of.

> It seems it's used only in debugging message output though.


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

