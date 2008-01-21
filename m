Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from MGW3.Sony.CO.JP ([137.153.0.15]:60014 "EHLO mgw3.sony.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754839AbYAULQV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jan 2008 06:16:21 -0500
Date: Mon, 21 Jan 2008 20:16:19 +0900
From: Masakazu Mokuno <mokuno@sm.sony.co.jp>
To: David Miller <davem@davemloft.net>
Subject: Re: [WEXT 8/12]: Pull top-level ioctl dispatch logic into helper function.
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20071221.205623.141035851.davem@davemloft.net>
References: <20071221.205623.141035851.davem@davemloft.net>
Message-Id: <20080121194758.6139.40F06B3A@sm.sony.co.jp> (sfid-20080121_111624_607613_D5E7153B)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi Dave,

On Fri, 21 Dec 2007 20:56:23 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> 
> [WEXT]: Pull top-level ioctl dispatch logic into helper function.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

<snip>

> +int wext_handle_ioctl(struct net *net, struct ifreq *ifr, unsigned int cmd,
> +		      void __user *arg)
> +{
> +	int ret = wext_ioctl_dispatch(net, ifr, cmd,
> +				      ioctl_standard_call,
> +				      ioctl_private_call);
> +
> +	if (ret > 0 &&

As the return value 0 is legal, should we allow copybacking in the case
of 'ret == 0'?

Same issue exists in compat_wext_handle_ioctl() of the #9 patch.

> +	    IW_IS_GET(cmd) &&
> +	    copy_to_user(arg, ifr, sizeof(struct iwreq)))
>  		return -EFAULT;
> +
>  	return ret;
>  }


-- 
Masakazu MOKUNO

