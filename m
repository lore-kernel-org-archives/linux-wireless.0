Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:53499 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023AbYG3DiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Jul 2008 23:38:00 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Kalle Valo <kalle.valo@nokia.com>
Subject: Re: Commit 741b4fbc44 (mac80211: fix TX sequence numbers) breaks rtl8187
Date: Wed, 30 Jul 2008 00:37:49 -0300
Cc: "Hin-Tak Leung" <hintak.leung@gmail.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net> <200807290021.45400.herton@mandriva.com.br> <87d4kwl7hh.fsf@nokia.com>
In-Reply-To: <87d4kwl7hh.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807300037.50088.herton@mandriva.com.br> (sfid-20080730_053814_281333_D2FBC82A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Em Tuesday 29 July 2008 18:12:58 Kalle Valo escreveu:
> Herton Ronaldo Krzesinski <herton@mandriva.com.br> writes:
> >> I also wonder how Herton encountered the problem :-). Older
> >> wireless-testing simply say "unimplemented" or something if one
> >> tries to set power-saving. Maybe Herton has a few devices which he
> >> routinely tries out every part of iwconfig?
> >
> > The original sequence of commands:
> > [1] /sbin/ip link set dev wlan0 down
> > [2] /sbin/ip link set dev wlan0 up
> > [3] /sbin/iwconfig wlan0 power on
> > [4] /sbin/iwconfig wlan0 essid any
> > [5] /sbin/iwconfig wlan0 power on
> > [6] /sbin/iwconfig wlan0 essid <my AP>
> > [7] /sbin/iwconfig wlan0 key open <my key>
> >
> > That show the issue on rtl8187b I have to test just is near on what
> > Mandriva 2008.0 ifup-wireless script does, so that's what first made me
> > catch the bug. the '... power on' after '... essid any' is what causes
> > later the association or any scan attempt to fail, if I place a sleep
> > between [4] and [5] I don't get the problem too.
>
> Thanks for the clarification, this kind of information is important
> when reporting a bug.
>
> > The problem is, I couldn't see yet how a power on after essid any
> > could cause this.
>
> I'm guessing that it has something to do ieee80211_ioctl_siwpower()
> calling ieee80211_hw_config(local) which ends up as an extra call to
> rtl8187_config(). I do not know why this is a problem for rtl8187b.

You are right, I was looking at wrong place, indeed the issue is on rtl8187. 
The problem here is that mac80211 can call rtl8187_config while another 
instance of it is still running, and on rtl8187_config this is a critical 
section:

...
        /* Enable TX loopback on MAC level to avoid TX during channel
         * changes, as this has be seen to causes problems and the
         * card will stop work until next reset
         */
        rtl818x_iowrite32(priv, &priv->map->TX_CONF,
                          reg | RTL818X_TX_CONF_LOOPBACK_MAC);
        msleep(10);
        priv->rf->set_chan(dev, conf);
        msleep(10);
        rtl818x_iowrite32(priv, &priv->map->TX_CONF, reg);
...

My sequence of commands trigger this, so there are cases where it disables TX 
loopback while there are another instance that can be still 
inside ->set_chan, that's explain also why card stops to work. This section 
should be lock protected or mac80211 ensure to not call local->ops->config 
while another call is still running.

>
> It would help if you, or someone else seeing the same problem, could
> provide more information by enabling MAC80211_VERBOSE_DEBUG and
> MAC80211_LOWTX_FRAME_DUMP config options, and sending the kernel log
> output here. I don't have a rtl8187b card myself so I cannot test
> this.

-- 
[]'s
Herton
