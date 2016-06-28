Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0206.hostedemail.com ([216.40.44.206]:34282 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752042AbcF1DzT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2016 23:55:19 -0400
Message-ID: <1467086116.24287.11.camel@perches.com> (sfid-20160628_055545_012254_55CBF154)
Subject: Re: [PATCH] rtlwifi: Create _rtl_dbg_trace function to reduce
 RT_TRACE code size
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 27 Jun 2016 20:55:16 -0700
In-Reply-To: <5771CA6C.1060403@lwfinger.net>
References: <90cd7c8f12b51571db565fd496a2fcf610e2e484.1466894688.git.joe@perches.com>
	 <5771CA6C.1060403@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2016-06-27 at 19:53 -0500, Larry Finger wrote:
> On 06/25/2016 05:46 PM, Joe Perches wrote:
> > 
> > This debugging macro can expand to a lot of code.
> > Make it a function to reduce code size.
> > 
> > (x86-64 defconfig w/ all rtlwifi drivers and allyesconfig)
> > $ size drivers/net/wireless/realtek/rtlwifi/built-in.o*
> >     text	   data	    bss	    dec	    hex	filename
> >   900083	 200499	   1907	1102489	 10d299	drivers/net/wireless/realtek/rtlwifi/built-in.o.defconfig.new
> > 1113597	 200499	   1907	1316003	 1414a3	drivers/net/wireless/realtek/rtlwifi/built-in.o.defconfig.old
> > 1746879	 453503	   8512	2208894	 21b47e	drivers/net/wireless/realtek/rtlwifi/built-in.o.new
> > 2051965	 503311	   8512	2563788	 271ecc	drivers/net/wireless/realtek/rtlwifi/built-in.o.old
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> I acked this before; however there is a bug that breaks the build if 
> CONFIG_RTLWIFI_DEBUG is not defined. The rest of the code calls 
> _rtl_dbg_trace(), but that symbol is never defined. The problem can be fixed in 
> debug.c or debug.h.

Confused a bit.  What breaks again?

debug.h:

#ifdef CONFIG_RTLWIFI_DEBUG
[]
__printf(5, 6)
void _rtl_dbg_trace(struct rtl_priv *rtlpriv, int comp, int level,
		    const char *modname, const char *fmt, ...);

#define RT_TRACE(rtlpriv, comp, level, fmt, ...)			\
	_rtl_dbg_trace(rtlpriv, comp, level,				\
		       KBUILD_MODNAME, fmt, ##__VA_ARGS__)
[]
#else
[]
__printf(4, 5)
static inline void RT_TRACE(struct rtl_priv *rtlpriv,
			    int comp, int level,
			    const char *fmt, ...)
{
}
[]
#endif
