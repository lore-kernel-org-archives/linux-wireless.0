Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51882 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932346Ab3CMSae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Mar 2013 14:30:34 -0400
Date: Wed, 13 Mar 2013 14:18:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: b43-dev@lists.infradead.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, zajec5@gmail.com
Subject: Re: [PATCH] ssb: pci: Fix flipping of MAC address
Message-ID: <20130313181817.GB19917@tuxdriver.com> (sfid-20130313_193048_897557_4D6514E6)
References: <513e40c2.MDaC+Q82iTl9PpIZ%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <513e40c2.MDaC+Q82iTl9PpIZ%Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 11, 2013 at 03:38:26PM -0500, Larry Finger wrote:
> Since commit e565275 entitled "ssb: pci: Standardize a function to get mac
> address", the SPROM readout of the MAC has had the values flipped so that
> 00:11:22:33:44:55 became 11:00:33:22:55:44. The fix has been tested on both
> little- and big-endian architectures.
> 
> Reported-by: Rafał Miłecki <zajec5@gmail.com>
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 
> John,
> 
> This bug was introduced in 3.9, and should be fixed there.
> 
> Thanks,
> 
> Larry
> ---
> 
> Index: wireless-testing-new/drivers/ssb/pci.c
> ===================================================================
> --- wireless-testing-new.orig/drivers/ssb/pci.c
> +++ wireless-testing-new/drivers/ssb/pci.c
> @@ -234,8 +234,8 @@ static void sprom_get_mac(char *mac, con
>  {
>  	int i;
>  	for (i = 0; i < 3; i++) {
> -		*mac++ = in[i];
>  		*mac++ = in[i] >> 8;
> +		*mac++ = in[i];
>  	}
>  }

Actually, FWIW it seems to have been introduced in commit
e5652756ff36ed9e1283121f788e6a17117efcab, which is slated for 3.10.
I'm happy to merge it in wireless-next.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
