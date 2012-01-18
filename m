Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:49353 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932197Ab2ARRTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Jan 2012 12:19:54 -0500
Subject: Re: [PATCH] compat-wireless: check if modprobe exists before using
 it
From: Luciano Coelho <coelho@ti.com>
To: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	wlist@ti.com, idor@ti.com, assaf@ti.com, gil.barak@ti.com
In-Reply-To: <CAB=NE6WFFPgQkBvn8uShMVG1+SExUFXfa9dW2jLGad62Sc5dOA@mail.gmail.com>
References: <1326874421-4654-1-git-send-email-coelho@ti.com>
	 <CAB=NE6WFFPgQkBvn8uShMVG1+SExUFXfa9dW2jLGad62Sc5dOA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 Jan 2012 19:19:48 +0200
Message-ID: <1326907188.4598.257.camel@cumari> (sfid-20120118_181959_546182_8056CCC4)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-01-18 at 09:15 -0800, Luis R. Rodriguez wrote: 
> On Wed, Jan 18, 2012 at 12:13 AM, Luciano Coelho <coelho@ti.com> wrote:
> > If you're cross-compiling compat-wireless on a different host, you
> > can't reliably use modprobe.  The host system may not even have
> > modprobe, so it doesn't make sense to run modprobe, unless you're
> > installing the modules on the target machine.
> >
> > The modprobe command was being used unconditionally to set the MADWIFI
> > and OLD_IWL variables.  This commit adds a check to see whether
> > modprobe exists before trying to use.  It also adds a dependency on
> > the modprobe commands to all recipes that rely on it, so we fail more
> > gracefully if modprobe doesn't exist in the system.
> >
> > Reported by: William List <wlist@ti.com>
> > Signed-off-by: Luciano Coelho <coelho@ti.com>
> 
> Good point, I've propagated this into the linux-3.2.y and linux-3.1.y
> branches of compat-wireless as well so that if a new release is made
> the fixes go along with it.

Excellent, thanks dude!

-- 
Cheers,
Luca.

