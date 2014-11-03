Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45307 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaKCMWq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2014 07:22:46 -0500
Date: Mon, 3 Nov 2014 15:22:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com
Subject: Re: brcm80211: use endian annotation for pmk related structure
Message-ID: <20141103122246.GQ6890@mwanda> (sfid-20141103_132249_565831_0B66D438)
References: <20141031125136.GA17467@mwanda>
 <54539A33.6000001@broadcom.com>
 <20141031142618.GL6890@mwanda>
 <54539EB0.2050207@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54539EB0.2050207@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 31, 2014 at 03:37:36PM +0100, Arend van Spriel wrote:
> On 10/31/14 15:26, Dan Carpenter wrote:
> >On Fri, Oct 31, 2014 at 03:18:27PM +0100, Arend van Spriel wrote:
> >>Understood. Not sure what the motivation is to mistrust endian more.
> >
> >Endian data tends to come from suspicious places such as disk images,
> >usb devices, and networks.
> >
> >>Simply because there could be conversion errors? Anyway, the main
> >>question is whether pmkid_len is always between 0 and
> >>WLAN_PMKID_LEN. As far as I know it is. We could 1) add additional
> >>checks here, 2) make pmkid_len of u32 type, or 3) just mention the
> >>(sure) assumption in a comment. I would prefer option 2) or 3).
> >
> >I would prefer 2.  Static checker warnings are a pain.
> 
> Now who has been tinkering on static checkers ;-) Anyway, option 2)
> it is. Who will do the patch? :-p

Actually, in the end making it unsigned doesn't make sense because we
don't check for upper bound either.

Let's just forget about it.

regards,
dan carpenter

