Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:11846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752647AbaAaMOM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jan 2014 07:14:12 -0500
Date: Fri, 31 Jan 2014 13:16:22 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sergei Antonov <saproj@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: USB rt2x00 driver regression
Message-ID: <20140131121621.GA19138@redhat.com> (sfid-20140131_131416_324870_DADED5A5)
References: <20140117100613.GD1425@redhat.com>
 <A411C6B4-8474-47AC-97E1-0D92B24EB675@gmail.com>
 <1390133995.6945.11.camel@X1Carbon.localdomain>
 <03574886-F38F-461C-97FC-B10DCCCF30E8@gmail.com>
 <52DC1761.9080608@openwrt.org>
 <CABikg9zdW7GjaaghfW3fLcPKEiF0-3P5Ht2DY9hx6r0-XcguRw@mail.gmail.com>
 <20140120185044.GA1682@redhat.com>
 <CABikg9y_jd6TWGGN09edqabXboO9VoBTPUtLWFyWZjfSr6dnqg@mail.gmail.com>
 <20140122162522.GA10630@redhat.com>
 <CABikg9w7JjdeD7EU1cw9A-aARddDigDZzaxoL5yk6YeFtJB4hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABikg9w7JjdeD7EU1cw9A-aARddDigDZzaxoL5yk6YeFtJB4hw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 29, 2014 at 06:45:31PM +0100, Sergei Antonov wrote:
> > On older kernels "TX status timeout" messages were only enabled if
> > kernel was compiled with CONFIG_RT2X00_DEBUG option , so perhaps
> > that is the reason why you did not see them on older kernel with
> > older firmware. But if really TX status timeouts start to happen after
> > firmware update, we should fix our driver to better talk to the
> > firmware, though I do not have idea how. If not, we should probably
> > disable those messages in non-debug mode as it was on old kernels.
> 
> Yes, it could have been due to CONFIG_RT2X00_DEBUG=n that I didn't
> have warnings.

I will move those annoying messages back to debug level, they are
printed by default by mistake anyway.

> The AP with which I have the warnings is another Linux computer with
> hostapd-2.0. Can it be the cause of this "TX status" thing?

It can be that AP does not ACK some frames for some reason and we see
those warnings. Could you please provide me details about that AP (what
H/W and driver is used and hostapd config file), I will see if I could
reproduce those messages locally.

Stanislaw
