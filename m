Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:57345 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675Ab2BRXVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Feb 2012 18:21:03 -0500
Received: by wics10 with SMTP id s10so2237831wic.19
        for <linux-wireless@vger.kernel.org>; Sat, 18 Feb 2012 15:21:01 -0800 (PST)
Message-ID: <1329607224.1772.8.camel@localhost.localdomain> (sfid-20120219_002141_246567_5E5E3AC7)
Subject: Re: [iwlwifi 5000] Linux 3.3.0-rc2 drops wifi connection
 (regression from 3.2) - "No buffer space available"
From: Maciej Marcin Piechotka <uzytkownik2@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 18 Feb 2012 23:20:24 +0000
In-Reply-To: <20120216131009.GH25833@redhat.com>
References: <1328667237.1747.26.camel@localhost.localdomain>
	 <20120216114348.GC25833@redhat.com>
	 <1329396752.1852.1.camel@localhost.localdomain>
	 <20120216131009.GH25833@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-16 at 14:10 +0100, Stanislaw Gruszka wrote:
> On Thu, Feb 16, 2012 at 12:52:32PM +0000, Maciej Marcin Piechotka wrote:
> > On Thu, 2012-02-16 at 12:43 +0100, Stanislaw Gruszka wrote:
> > > On Wed, Feb 08, 2012 at 02:13:57AM +0000, Maciej Marcin Piechotka wrote:
> > > > Hello,
> > > > 
> > > > Linux 3.3.0 drops connections from WiFi on 3.3 (worked on 3.2).
> > > > If I try to ping anything:
> > > > 
> > > > ping: sendmsg: No buffer space available
> > > > 
> > > > When I disable/enable WiFi by rfkill it works ok. I haven't found what
> > > > determines the period before it happens.
> > > 
> > > What show dmesg?
> > > 
> > > Stanislaw
> > 
> > There is no message in dmesg which would correspond to the problem (I
> > can send the full dump if you would like but there is nothing other then
> > I had in 3.2.x).
> 
> So it does not look like iwlwifi issue. When this happen what shows
> "strace ping" ?
> 
> Stanislaw

After recompiling the kernel (I deleted previous build of 3.3 by
accident) I cannot reproduce the error.

The only difference that should affect iwlwifi is CONFIG_IWLWIFI_P2P,
which was previously enabled (I guess i387 changes in kernel should not
affect the 64-bit system extensively). I'll try to rebuild the module
and check if the option affects the problem.

In any case the problem seems to be in kernel (or in glibc or other part
of basic stack) as it affected other programs as well (such as
browsers).

Best regards

