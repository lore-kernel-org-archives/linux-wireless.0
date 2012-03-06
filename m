Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56163 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756807Ab2CFKJk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 05:09:40 -0500
Subject: Re: [PATCH] compat: Fix module_init return type from void to int.
From: Johannes Berg <johannes@sipsolutions.net>
To: Nicolas Cavallari <Nicolas.Cavallari@lri.fr>
Cc: "Luis R. Rodriguez" <mcgrof@kernel.org>,
	Maximilian.Gmeiner.sam04@fh-joanneum.at,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
In-Reply-To: <1331027728-18496-1-git-send-email-cavallar@lri.fr> (sfid-20120306_105836_618222_61A5ED9C)
References: <CDCF1538AB98AA4FBCA89C8D5750845F1A473A21@MALMO.technikum.fh-joanneum.local>
	 <1331027728-18496-1-git-send-email-cavallar@lri.fr>
	 (sfid-20120306_105836_618222_61A5ED9C)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Mar 2012 11:09:35 +0100
Message-ID: <1331028575.3447.5.camel@jlt3.sipsolutions.net> (sfid-20120306_110945_808772_398E54B3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-03-06 at 10:55 +0100, Nicolas Cavallari wrote:
> 086f3a1 overrode module_init to make it depend on compat, but the
> overriding module_init has return type 'void', so strange things would
> happen when the module loading code see that init_module() returns
> positive values.  This patch makes it return the value returned by
> the overriden module_init.
> 
> Signed-off-by: Nicolas Cavallari <cavallar@lri.fr>
> ---
> On 05/03/2012 22:50, Gmeiner Maximilian wrote:
> > After compiling from the bleeding-edge without any errors this is what I get in kern.log when doing modprobe ath9k
> 
> I had the same problem with a completely different architecture and device,
> and this patch fixed it.
> 
> diff --git a/include/linux/compat-2.6.h b/include/linux/compat-2.6.h
> index bb00cd4..5715ce5 100644
> --- a/include/linux/compat-2.6.h
> +++ b/include/linux/compat-2.6.h
> @@ -27,10 +27,10 @@ void compat_dependency_symbol(void);
>  
>  #undef module_init
>  #define module_init(initfn)						\
> -	static void __init __init_compat(void)				\
> +	static int __init __init_compat(void)				\
>  	{								\
>  		compat_dependency_symbol();				\
> -		initfn();						\
> +		return initfn();					\


Yikes, you're right, thanks for the patch!

Acked-by: Johannes Berg <johannes@sipsolutions.net>

johannes

