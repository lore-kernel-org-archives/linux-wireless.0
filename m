Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:53920 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbaGUMNf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2014 08:13:35 -0400
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Michal Kazior <michal.kazior@tieto.com>
Subject: Re: [PATCH 2/2] ath10k: add spectral scan feature
Date: Mon, 21 Jul 2014 14:13:29 +0200
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	"Giori, Kathy" <kgiori@qca.qualcomm.com>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Sven Eckelmann <sven@narfation.org>
References: <1405689992-8538-1-git-send-email-sw@simonwunderlich.de> <201407211159.26103.sw@simonwunderlich.de> <CA+BoTQnCLDJYzGDLA-zHcaddY-cyuC48dMwTnoHJP+KYG2tN_Q@mail.gmail.com>
In-Reply-To: <CA+BoTQnCLDJYzGDLA-zHcaddY-cyuC48dMwTnoHJP+KYG2tN_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201407211413.29392.sw@simonwunderlich.de> (sfid-20140721_141338_255020_DC5E5D5D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> >> > +       arvif = ath10k_get_spectral_vdev(ar);
> >> > +       if (!arvif)
> >> > +               return -ENODEV;
> >> > +       vdev_id = arvif->vdev_id;
> >> > +
> >> > +       if (ar->spectral_mode == SPECTRAL_DISABLED)
> >> > +               return 0;
> >> > +
> >> > +       res = ath10k_wmi_vdev_spectral_enable(ar, vdev_id,
> >> > +
> >> > WMI_SPECTRAL_TRIGGER_CMD_CLEAR, +
> >> > 
> >> >      WMI_SPECTRAL_ENABLE_CMD_ENABLE); +       if (res < 0)
> >> > 
> >> > +               return res;
> >> > +
> >> > +       res = ath10k_wmi_vdev_spectral_enable(ar, vdev_id,
> >> > +
> >> > WMI_SPECTRAL_TRIGGER_CMD_TRIGGER, +
> >> > 
> >> >        WMI_SPECTRAL_ENABLE_CMD_ENABLE); +       if (res < 0)
> >> > 
> >> > +               return res;
> >> > +
> >> > +       return 0;
> >> > +}
> >> > +static int ath10k_spectral_scan_config(struct ath10k *ar,
> >> > +                                      enum ath10k_spectral_mode mode)
> >> > +{
> >> > +       struct wmi_vdev_spectral_conf_arg arg;
> >> > +       struct ath10k_vif *arvif;
> >> > +       int vdev_id, count, res = 0;
> >> > +
> >> 
> >> Ditto. lockdep_assert_held().
> > 
> > Actually both functions are calling ath10k_get_spectral_vdev() which
> > already has that assert, but it doesn't hurt to put it here as well.
> > Will do. :)
> 
> True but those functions (scan_config, scan_trigger) also access
> conf_mutex protected data themselves directly. If
> ath10k_get_spectral_vdev() was to be changed to not require conf_mutex
> you'd have to remember to move lockdep_assert_held() up the call
> stack.

Ah, that's right. I'll add that anyway. :)

> 
> >> Did you test this against a firmware crash while spectral scan is
> >> enabled? ar->spectral_mode will be left as-is when restart is
> >> performed but no spectral scan will be actually configured. You either
> >> need to restart spectral scan (better from user perspective) or clear
> >> out the old mode (easier to code, but bad from user perspective
> >> because suddenly spectral scan would be stopped implicitly by device
> >> crash).
> > 
> > No, I didn't test that against a firmware crash yet ...
> 
> There's 'simulate_fw_crash' in debugfs. I suggest 'hard' method.
> 'soft' works only with fw 636 now. Watch out for possible host lockups
> though.
> 

Thanks, the hard firmware crash worked for me.

> > Restarting spectral
> > would probably a good idea in endless mode, but not if "count" has been
> > set.
> 
> Hmm good point, but then what if you have count=20 and fw crashes in
> the middle of performing the spectral scan run (e.g. at iteration 10)?
> 
> But then this is just a debug interface (or is it?). I don't know if
> it's worth it going to great lengths to provide a super smooth user
> experience.

Well yeah, it's in debugfs so its a debug interface. ;) Since we don't really 
keep track whether a scan was triggered or not, and the firmware takes some 
time to recover, I don't think it's worth the hassle - without creating more 
confusion. I'll reset the spectral mode in any case so users at least see that 
its disabled.

I'll send the next round of patches in some minutes. :)

Thanks!
    Simon
