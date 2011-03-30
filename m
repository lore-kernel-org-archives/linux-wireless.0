Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.10]:59825 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab1C3MyC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2011 08:54:02 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH 1/1] drivers: brcmaxi: provide amba axi functionality in separate module
Date: Wed, 30 Mar 2011 14:53:48 +0200
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
	rmk+kernel@arm.linux.org.uk, devel@linuxdriverproject.org,
	gregkh@suse.de, linux-wireless@vger.kernel.org,
	Jiri Slaby <jirislaby@gmail.com>
References: <1301391619-4499-1-git-send-email-arend@broadcom.com> <1301391619-4499-2-git-send-email-arend@broadcom.com> <4D91B856.8040302@suse.cz>
In-Reply-To: <4D91B856.8040302@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201103301453.48607.arnd@arndb.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 29 March 2011, Jiri Slaby wrote:
> On 03/29/2011 11:40 AM, Arend van Spriel wrote:
> > --- /dev/null
> > +++ b/drivers/brcmaxi/axi.c
> > @@ -0,0 +1,786 @@
> ...
> > +/* resetctrl */
> > +#define	AIRC_RESET		1
> > +
> > +/* definition for specifying padding fields */
> > +#define	_PADLINE(line)	pad ## line
> > +#define	_XSTR(line)	_PADLINE(line)
> > +#define	PAD		_XSTR(__LINE__)
> > +
> > +/*
> > + * struct aidmp - device management plugin "wrapper" registers.
> > + */
> > +struct aidmp {
> 
> This looks like it should be __packed__.

Why that? Adding the packed attribute would enforce byte access but
not change the layout of the structure, so I think that would make
it worse not better.

	Arnd
