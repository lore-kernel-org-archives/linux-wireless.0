Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:35618 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752621Ab2GLLrg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jul 2012 07:47:36 -0400
Message-ID: <4FFEB94E.6030808@hauke-m.de> (sfid-20120712_134740_451641_C501EA29)
Date: Thu, 12 Jul 2012 13:47:26 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org
Subject: Re: brcmsmac: use container_of instead of cast
References: <20120712112007.GA12822@elgon.mountain>
In-Reply-To: <20120712112007.GA12822@elgon.mountain>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/12/2012 01:20 PM, Dan Carpenter wrote:
> The patch ed1dd81464f5: "brcmsmac: use container_of instead of cast" 
> from Jun 30, 2012, leads to the following Smatch warning:
> drivers/net/wireless/brcm80211/brcmsmac/aiutils.c:543 ai_detach()
> 	 warn: can 'sii' even be NULL?
> 
>    533  /* may be called with core in reset */
>    534  void ai_detach(struct si_pub *sih)
>    535  {
>    536          struct si_info *sii;
>    537  
>    538          struct si_pub *si_local = NULL;
>    539          memcpy(&si_local, &sih, sizeof(struct si_pub **));

I do not get what this line is used for, it looks like unneeded code,
si_local is never read.

>    540  
>    541          sii = container_of(sih, struct si_info, pub);
>    542  
>    543          if (sii == NULL)
>    544                  return;
>    545  
>    546          kfree(sii);
>    547  }
> 
> 
> Smatch complains because container_of() of does pointer math and the
> check for NULL only works when ->pub is first member of the si_info
> struct.

For now pub is the first member of the struct, but the null check should
be done on sih and it should be moved before the container_of line.

> Are you sure you want to free sii and not sih?
Yes sii should be freed, it is allocated in the function ai_attach()
above and there sii is casted to sih, so this only works if pub is the
first member.

> Also kfree() checks for NULL.
> 
> The memcpy() is pointless.
> 
> The white space is not right.  There should be a blank line after the
> variable declarations.
> 
> regards,
> dan carpenter

Hauke
