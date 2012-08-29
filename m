Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48214 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab2H2WMq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 18:12:46 -0400
Message-ID: <1346278357.2177.7.camel@router7789> (sfid-20120830_001310_270151_B05B4411)
Subject: Re: [PATCH] vt6656: [BUG] - Failed connection, incorrect endian. v2
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Wed, 29 Aug 2012 23:12:37 +0100
In-Reply-To: <503E8789.6050809@lwfinger.net>
References: <1346273644.2077.3.camel@router7789>
	 <503E8789.6050809@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-29 at 16:20 -0500, Larry Finger wrote:
> On 08/29/2012 03:54 PM, Malcolm Priestley wrote:
> >
> > This patch fixes a bug with driver failing to negotiate a connection.
> >
> > The bug was traced to commit
> > 203e4615ee9d9fa8d3506b9d0ef30095e4d5bc90
> > staging: vt6656: removed custom definitions of Ethernet packet types
> >
> > In that patch, definitions in include/linux/if_ether.h replaced ones
> > in tether.h which had both big and little endian definitions.
> >
> > include/linux/if_ether.h only refers to big endian values, cpu_to_be16
> > should be used for the correct endian architectures.
> >
> > checkpatch fixed version.
> >
> > Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> 
> Patches for staging drivers should be sent to gregkh@linuxfoundation.org. He is 
> the one that handles them. In addition, the patch subject line usually has the 
> sequence "staging: vt6656: blabla" the way the faulty patch did.

Thanks

I have forwarded the patch.


Regards


Malcolm



