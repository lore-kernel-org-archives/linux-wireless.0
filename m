Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58413 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755767AbaIKTaL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Sep 2014 15:30:11 -0400
Date: Thu, 11 Sep 2014 15:27:21 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	g@tuxdriver.com
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] hostap: proc: substitute loops by %*phN
Message-ID: <20140911192721.GD22872@tuxdriver.com> (sfid-20140911_213016_372865_13CC5E61)
References: <1409927416-27101-1-git-send-email-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1409927416-27101-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Applying: hostap: proc: substitute loops by %*phN
error: patch failed: drivers/net/wireless/hostap/hostap_proc.c:184
error: drivers/net/wireless/hostap/hostap_proc.c: patch does not apply

On Fri, Sep 05, 2014 at 05:30:16PM +0300, Andy Shevchenko wrote:
> For dumping small buffers we may use %*phN specifier instead of custom
> approach..
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/wireless/hostap/hostap_proc.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/wireless/hostap/hostap_proc.c b/drivers/net/wireless/hostap/hostap_proc.c
> index 16a06b6..4e2a7dd9 100644
> --- a/drivers/net/wireless/hostap/hostap_proc.c
> +++ b/drivers/net/wireless/hostap/hostap_proc.c
> @@ -184,11 +184,9 @@ static int prism2_bss_list_proc_show(struct seq_file *m, void *v)
>  	seq_printf(m, "%*pE", bss->ssid_len, bss->ssid);
>  
>  	seq_putc(m, '\t');
> -	for (i = 0; i < bss->ssid_len; i++)
> -		seq_printf(m, "%02x", bss->ssid[i]);
> +	seq_printf(m, "%*phN", (int)bss->ssid_len, bss->ssid);
>  	seq_putc(m, '\t');
> -	for (i = 0; i < bss->wpa_ie_len; i++)
> -		seq_printf(m, "%02x", bss->wpa_ie[i]);
> +	seq_printf(m, "%*phN", (int)bss->wpa_ie_len, bss->wpa_ie);
>  	seq_putc(m, '\n');
>  	return 0;
>  }
> -- 
> 2.1.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
