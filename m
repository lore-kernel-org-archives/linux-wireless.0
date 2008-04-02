Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:56072 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbYDBCkH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2008 22:40:07 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rtl8187b work in progress...
Date: Tue, 1 Apr 2008 23:40:01 -0300
Cc: linux-wireless@vger.kernel.org,
	Daniel Gimpelevich <daniel@gimpelevich.san-francisco.ca.us>
References: <pan.2008.04.01.18.07.31.772700@gimpelevich.san-francisco.ca.us> <1207074268-16335-1-git-send-email-linville@tuxdriver.com> <200804012109.57965.herton@mandriva.com.br>
In-Reply-To: <200804012109.57965.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804012340.01354.herton@mandriva.com.br> (sfid-20080402_034015_397269_031D700D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Tuesday 01 April 2008 21:09:57 Herton Ronaldo Krzesinski escreveu:
> Em Tuesday 01 April 2008 15:24:28 John W. Linville escreveu:
> @@ -432,10 +688,24 @@ static int rtl8187_start(struct ieee8021
>  	u32 reg;
>  	int ret;
>  
> -	ret = rtl8187_init_hw(dev);
> +	ret = (priv->hw_type == RTL8187) ? rtl8187_init_hw(dev) :
> +					   rtl8187b_init_hw(dev);
> +	//ret = rtl8187_init_hw(dev);
>  	if (ret)
>  		return ret;
>  
> +	if (priv->hw_type == RTL8187B) {
> +		rtl818x_iowrite32(priv, &priv->map->TX_CONF,
> +				  RTL818X_TX_CONF_DURPROCMODE |
> +				  RTL818X_TX_CONF_DISREQQSIZE |
> +				  RTL818X_TX_CONF_MAXDMA_2048 |
> +				  (7 << 8) | 7); //TODO: define, short-long retry limit
> +		reg = rtl818x_ioread8(priv, &priv->map->MSR);
> +		reg |= RTL818X_MSR_ENEDCA;
> +		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
> +		return 0;
                ^^^
Now that I removed this return (obviously wrong heh) It seems to work ok :),
the rtl8187b I have here at least now successfuly scans for aps/receive data,
later I'll do more testing/improvements.

-- 
[]'s
Herton
