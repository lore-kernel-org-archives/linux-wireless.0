Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:44048 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752436AbaILHYN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Sep 2014 03:24:13 -0400
Message-ID: <1410506650.7023.29.camel@linux.intel.com> (sfid-20140912_092416_922907_31C20951)
Subject: Re: [PATCH] hostap: proc: substitute loops by %*phN
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: g@tuxdriver.com, Jouni Malinen <j@w1.fi>,
	linux-wireless@vger.kernel.org
Date: Fri, 12 Sep 2014 10:24:10 +0300
In-Reply-To: <20140911192721.GD22872@tuxdriver.com>
References: <1409927416-27101-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <20140911192721.GD22872@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-09-11 at 15:27 -0400, John W. Linville wrote:
> Applying: hostap: proc: substitute loops by %*phN
> error: patch failed: drivers/net/wireless/hostap/hostap_proc.c:184
> error: drivers/net/wireless/hostap/hostap_proc.c: patch does not apply

Hmm... Originally it was applied on top of linux-next (few days ago).

Just checking with current origin/master. Applied correctly.

Moreover, took recent wireless-next. No issues.
Which tree you are trying?

> 
> On Fri, Sep 05, 2014 at 05:30:16PM +0300, Andy Shevchenko wrote:
> > For dumping small buffers we may use %*phN specifier instead of custom
> > approach..
> > 
> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > ---
> >  drivers/net/wireless/hostap/hostap_proc.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/hostap/hostap_proc.c b/drivers/net/wireless/hostap/hostap_proc.c
> > index 16a06b6..4e2a7dd9 100644
> > --- a/drivers/net/wireless/hostap/hostap_proc.c
> > +++ b/drivers/net/wireless/hostap/hostap_proc.c
> > @@ -184,11 +184,9 @@ static int prism2_bss_list_proc_show(struct seq_file *m, void *v)
> >  	seq_printf(m, "%*pE", bss->ssid_len, bss->ssid);
> >  
> >  	seq_putc(m, '\t');
> > -	for (i = 0; i < bss->ssid_len; i++)
> > -		seq_printf(m, "%02x", bss->ssid[i]);
> > +	seq_printf(m, "%*phN", (int)bss->ssid_len, bss->ssid);
> >  	seq_putc(m, '\t');
> > -	for (i = 0; i < bss->wpa_ie_len; i++)
> > -		seq_printf(m, "%02x", bss->wpa_ie[i]);
> > +	seq_printf(m, "%*phN", (int)bss->wpa_ie_len, bss->wpa_ie);
> >  	seq_putc(m, '\n');
> >  	return 0;
> >  }
> > -- 
> > 2.1.0
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 


-- 
Andy Shevchenko <andriy.shevchenko@intel.com>
Intel Finland Oy

