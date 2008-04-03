Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:31679 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757845AbYDCCFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2008 22:05:21 -0400
From: bruno randolf <bruno@thinktube.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Ulrich Kunitz <kune@deine-taler.de>,
	Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] mac80211: use hardware flags for signal/noise units
Date: Thu, 3 Apr 2008 11:05:05 +0900
Cc: ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	flamingice@sourmilk.net, jbenc@suse.cz,
	"Ivan Seskar" <Seskar@winlab.rutgers.edu>,
	"Jean Tourrilhes" <jt@hpl.hp.com>,
	"Haris Kremo" <harisk@winlab.rutgers.edu>,
	"Ivo van Doorn" <ivdoorn@gmail.com>
References: <20080326123042.11233.80949.stgit@localhost> <200803271107.54208.bruno@thinktube.com> <43e72e890804021227y520380f7j8ad25eb30f635d2b@mail.gmail.com>
In-Reply-To: <43e72e890804021227y520380f7j8ad25eb30f635d2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200804031105.06176.bruno@thinktube.com> (sfid-20080403_030526_206427_6CE96C2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 03 April 2008 04:27:31 Luis R. Rodriguez wrote:
> >  so in the "unspecified" case we really don't know much about the units,
> > in the worst case we can't even assume that 1/2 the value will mean 1/2
> > of the received signal strength. it's very hard to work with this values,
> > but it's better than nothing.
> >
> >  other cards might not have noise, so no absolute (dBm) measurement, but
> > a form of RSSI which is measured in dB (that is a logarithmic
> > difference). in this case we might not know which reference point the
> > measurement is taken to, but we know how it behaves: -3 dB means half of
> > the signal strength. if you add a 6dB gain antenna you can expect to see
> > the signal reading to increase by 6dB. it's not strictly SNR (because we
> > don't know the noise) but quite close to it.
> >
> >  i think it's important to know the difference between this 3 cases i
> > order to make some sense of the values in userspace gui, roaming agents,
> > mesh link metrics, etc...
>
> Agreed, but can you give me an example of a card which does provide
> RSSI in db for values we don't know and that UNSPEC cannot handle? Is
> this what is assumed of the rt2x00 cards?

i currently assume that for rt2x00 and zd1211 cards - but i'm really just 
guessing here. feedback from driver authors or people who have more knowledge 
about the hardware would be greatly appreciated!

here's the current table:

    DRIVER          SIGNAL    MAX       NOISE   QUAL
    -----------------------------------------------------------------
    adm8211         unspec(?) 100   n/a     missing
    at76_usb        unspec(?) (?)   unused  missing
    ath5k           dBm             dBm     percent rssi
    b43legacy       dBm             dBm     percent jssi(?)
    b43             dBm             dBm     percent jssi(?)
    iwl-3945        dBm             dBm     percent snr+more
    iwl-4965        dBm             dBm     percent snr+more
    p54             unspec    127   n/a     missing
    rt2x00                              percent rssi+tx/rx frame success
      rt2400        dB(?)     100   n/a
      rt2500pci     dB(?)     100   n/a
      rt2500usb     dB(?)     100   n/a
      rt61pci       dB(?)     100   n/a
      rt73usb       dB(?)     100   n/a
    rtl8180         unspec(?) 65    n/a     (?)
    rtl8187         unspec(?) 65    (?)     noise(?)
    zd1211          dB(?)     100   n/a     percent

bruno
