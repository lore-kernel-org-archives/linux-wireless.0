Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48752 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751424AbdLCIj1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 3 Dec 2017 03:39:27 -0500
Message-ID: <1512290364.4827.57.camel@coelho.fi> (sfid-20171203_094122_762368_7334A42C)
From: Luca Coelho <luca@coelho.fi>
To: Chris Chiu <chiu@endlessm.com>
Cc: johannes.berg@intel.com, linuxwifi@intel.com,
        linux-wireless@vger.kernel.org,
        Linux Upstreaming Team <linux@endlessm.com>
Date: Sun, 03 Dec 2017 10:39:24 +0200
In-Reply-To: <1512107590.4827.38.camel@coelho.fi>
References: <CAB4CAwdO0dKAinnPk+ihJyDgOJ1z=2D=+pLMrObJYH+QiaDRqA@mail.gmail.com>
         <1509434718.4492.195.camel@coelho.fi>
         <CAB4CAwc43h5g+zLYd3hv=STELNGH+NEeQOMAXd-Gm0xj+TNuyA@mail.gmail.com>
         <1509952948.4492.360.camel@coelho.fi>
         <CAB4CAwc0G0j1zb+Z4z6iCJ2hzMznUsSVxyF8G3dbZn9pxzffng@mail.gmail.com>
         <CAB4CAwcwVEyFX=7KJcAT9eXQoof_M+U+tB+FRQCnoP5WgK-MrQ@mail.gmail.com>
         <1510825750.4011.179.camel@coelho.fi>
         <CAB4CAwfg73wRoNca2GBaMn4eN04vf+uR3xdzYO0UWG1Nmaqo=w@mail.gmail.com>
         <1510901207.4011.197.camel@coelho.fi>
         <CAB4CAwcit2jqHXs7x2cowHdi31OH3wKnmyW4=v-6RGO-+1gjog@mail.gmail.com>
         <CAB4CAwdZHwC0kiaGU5A1u_P8y0anw58o6KiOXAWbjwUtB=uLuQ@mail.gmail.com>
         <1511689749.4011.357.camel@coelho.fi>
         <CAB4CAwf6uBbMgT_=Qb5uo+2g_sNSLdRhnjJt-C9vB6OgSjphyg@mail.gmail.com>
         <CAB4CAweoq=PAqjPW_POLy5+9tHFquunoY6h5xNJ9EU=xY5zcxg@mail.gmail.com>
         <1512107590.4827.38.camel@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [linuxwifi] Need support for Intel new wifi module 9462NGW
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2017-12-01 at 07:53 +0200, Luca Coelho wrote:
> On Fri, 2017-12-01 at 13:29 +0800, Chris Chiu wrote:
> > Hi Luca,
> >     I think the problem is not missing DHCP reply. I installed
> > tcpdump
> > on the machine with Intel 9461NGW and start monitoring on the wlan
> > interface.
> > The result is following
> > https://gist.github.com/mschiu77/f4cc14ddae6adf137da15675cca59b30
> > 
> > I also attach the ifconfig result at the end of the above url. Hope
> > this can help a little.
> 
> Hi Chris,
> 
> Sorry for the delay.  We've been testing this internally, but
> couldn't
> reproduce it at first.  The problems seems to be with the firmware
> that
> we released.
> 
> I'll provide you an update today or latest by Monday next week.

Hi Chris,

We found a patch that was missing from upstream and causes data
corruption on secure associations:

https://patchwork.kernel.org/patch/10088939/


Can you try to apply this patch and see if it fixes the problem you are
having?

--
Cheers,
Luca.
