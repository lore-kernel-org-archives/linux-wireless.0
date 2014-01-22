Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:61533 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070AbaAVQXZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 11:23:25 -0500
Date: Wed, 22 Jan 2014 17:25:23 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Sergei Antonov <saproj@gmail.com>
Cc: Gabor Juhos <juhosg@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: USB rt2x00 driver regression
Message-ID: <20140122162522.GA10630@redhat.com> (sfid-20140122_172329_062872_734C039C)
References: <CABikg9yZrXX=qfqeR+V77u+Ndegx50D1_POAYMeq63qJuEzv=w@mail.gmail.com>
 <20140117100613.GD1425@redhat.com>
 <A411C6B4-8474-47AC-97E1-0D92B24EB675@gmail.com>
 <1390133995.6945.11.camel@X1Carbon.localdomain>
 <03574886-F38F-461C-97FC-B10DCCCF30E8@gmail.com>
 <52DC1761.9080608@openwrt.org>
 <CABikg9zdW7GjaaghfW3fLcPKEiF0-3P5Ht2DY9hx6r0-XcguRw@mail.gmail.com>
 <20140120185044.GA1682@redhat.com>
 <CABikg9y_jd6TWGGN09edqabXboO9VoBTPUtLWFyWZjfSr6dnqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CABikg9y_jd6TWGGN09edqabXboO9VoBTPUtLWFyWZjfSr6dnqg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 22, 2014 at 12:27:44PM +0100, Sergei Antonov wrote:
> On 20 January 2014 19:50, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> > On Mon, Jan 20, 2014 at 12:20:05PM +0100, Sergei Antonov wrote:
> >> On 19 January 2014 19:20, Gabor Juhos <juhosg@openwrt.org> wrote:
> >> > The attached patch set adds the missing code to rt2x00. Please test whether it
> >> > fixes the problem or not.
> >>
> >> It does not work.
> >>
> >> The minimal change that fixes the problem is removing 'return;' after
> >> rt2800_mcu_request() allowing the standard freq. adjustment code to
> >> execute.
> >
> > Perhaps this MCU request is not supported by old firmware from
> > linux-firmware repository.
> >
> > Please download binary file accessible from this link
> > http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2013-January/005610.html
> > and replace rt2870.bin file in /lib/firmware directory.
> >
> > Does it help ?
> 
> Great hint. Thanks!
> Turned out I had firmware version 0.22
> With firmware 0.29 or 0.33 the adapter works with unmodified kernel 3.13.
> 
> The only problem I have now is that when connected to a particular
> access point I get a lot of warnings like this:
> [  327.309858] ieee80211 phy0: rt2800usb_entry_txstatus_timeout:
> Warning - TX status timeout for entry 13 in queue 2
> and this:
> [  327.332847] ieee80211 phy0: rt2800usb_txdone: Warning - Got TX
> status for an empty queue 2, dropping
> I didn't have this problem before (with older kernels and old firmware).

Does it mean that after you remove new rt2800_mcu_request() and use 0.22
firmware with 3.13 kernel you do not have those TX status timeout
warnings with this particular AP ?

On older kernels "TX status timeout" messages were only enabled if 
kernel was compiled with CONFIG_RT2X00_DEBUG option , so perhaps
that is the reason why you did not see them on older kernel with
older firmware. But if really TX status timeouts start to happen after
firmware update, we should fix our driver to better talk to the
firmware, though I do not have idea how. If not, we should probably
disable those messages in non-debug mode as it was on old kernels.

Stanislaw

