Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:35911 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933780AbXCZXpq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 19:45:46 -0400
Date: Mon, 26 Mar 2007 16:45:03 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: mohamed <mabbas@linux.intel.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [patch 4/5] IEEE 802.11n management action frame data  structures
Message-Id: <20070326164503.f276cd71.randy.dunlap@oracle.com>
In-Reply-To: <1174909342.1364.60.camel@dell-4965.jf.intel.com>
References: <1174909342.1364.60.camel@dell-4965.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 26 Mar 2007 04:42:22 -0700 mohamed wrote:

> Add draft IEEE 802.11n management action frame data structures and
> constants
> 
> Several Action frame format are defined to support IEEE 802.11n
> features. 
> This patch add the data structure for Block Ack management action frame.
> 
> Signed-off-by: Mohamed Abbas <mabbas@linux.intel.com>
> 
> diff -Nupr wireless-dev/include/linux/ieee80211.h
> wireless-dev-new/include/linux/ieee80211.h
> --- wireless-dev/include/linux/ieee80211.h	2007-03-23 13:25:24.000000000
> -0700
> +++ wireless-dev-new/include/linux/ieee80211.h	2007-03-23
> 13:43:21.000000000 -0700
> @@ -105,6 +105,19 @@ struct ieee80211_hdr {
>  } __attribute__ ((packed));
>  
>  
> +struct ieee802_11_addba_param {
> +	 __le16 reserved:1;
> +	 __le16 backPolicy:1;
> +	 __le16 tid:4;
> +	 __le16 bufSize:10;
> +} __attribute__ ((packed));
> +
> +struct ieee80211_delba_param {
> +	 __le16 reserved:11;
> +	 __le16 intiator:1;
> +	 __le16 tid:4;
> +}__attribute__ ((packed));

These bitfields are all local to one machine, not transported
across a network to systems where the bitfields may be represented
differently?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
