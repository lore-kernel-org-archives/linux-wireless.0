Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58891
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751006AbXLHCMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 21:12:22 -0500
Date: Fri, 07 Dec 2007 18:12:21 -0800 (PST)
Message-Id: <20071207.181221.09900510.davem@davemloft.net> (sfid-20071208_021226_119680_2C4C7D95)
To: dcbw@redhat.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jt@hpl.hp.com
Subject: Re: [PATCH] introduce WEXT scan capabilities
From: David Miller <davem@davemloft.net>
In-Reply-To: <1197073366.4563.15.camel@localhost.localdomain>
References: <1197073366.4563.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dan Williams <dcbw@redhat.com>
Date: Fri, 07 Dec 2007 19:22:46 -0500

> @@ -1040,6 +1049,16 @@ struct	iw_range
>  	 * because each entry contain its channel index */
>  
>  	__u32		enc_capa;	/* IW_ENC_CAPA_* bit field */
> +
> +	/* Do *NOT* use those fields, they are just used as padding to get
> +	 * proper alignement with user space */
> +	__s32		reserved1;
> +	__s32		reserved2;
> +	__u16		reserved3;
> +	__s32		reserved4;
> +	__u32		reserved5;
> +
> +	__u32		scan_capa;	/* IW_SCAN_CAPA_* bit field */
>  };
>  
>  /*

Major NACK.  These datastructure usages are complete wrong, and
we have to stop spreading this problem instead of continuing on
with it as if it's OK.

