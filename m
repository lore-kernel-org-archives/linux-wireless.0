Return-Path: <SRS0=M/jX=SP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFC9C10F11
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 10:11:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D02B9206BA
	for <linux-wireless@archiver.kernel.org>; Sat, 13 Apr 2019 10:11:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555150273;
	bh=TqQucXNq8jwxmLgcxKUMntoVPKZVHcmhPROxQjaCO5U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=eeYbmbohQR6U2HC3QSk5PfDA0XeW7quJ3gFkj49iEKusd8uAF0Zn8qU2bbAGQ7BBx
	 gMUgFrxFJVN7q0WlE0yYWuKizamFNACwXD+u9L4u2zWHFC4FnU7FEq4R54BwhwdNvS
	 ud7cBnFY6F+9VlKeu27w+aw9roW537G808IF9LNw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfDMKLL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 13 Apr 2019 06:11:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726261AbfDMKLL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 Apr 2019 06:11:11 -0400
Received: from localhost.localdomain (unknown [151.66.24.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9825206BA;
        Sat, 13 Apr 2019 10:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1555150270;
        bh=TqQucXNq8jwxmLgcxKUMntoVPKZVHcmhPROxQjaCO5U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mbKV1uzBW2xYJ931p4031dBBdJPVjjpi9//1V/qVvjqXGotcPEy5OnFjSwYnDtDNA
         zLSohmHvINKsHAOHe+UmtAVmEkqxulRF9MJVP48Z2E5WLEZL/Na0B1F/XfgT5mTlSH
         EjxjcROtmXONJJB0aVUxuKOUhymAg5dxkH5OivDs=
Date:   Sat, 13 Apr 2019 12:10:59 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>, nbd@nbd.name,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: usb: fix possible memory leak during suspend/resume
Message-ID: <20190413101056.GA7940@localhost.localdomain>
References: <cover.1555071870.git.lorenzo@kernel.org>
 <bdd1046beaee6104b1fcd25b1069f25db8f2fb20.1555071870.git.lorenzo@kernel.org>
 <20190412145442.GA2539@redhat.com>
 <20190412153509.GB3156@localhost.localdomain>
 <20190412162746.GC3156@localhost.localdomain>
 <20190413083050.GA7434@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20190413083050.GA7434@redhat.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Apr 12, 2019 at 06:27:48PM +0200, Lorenzo Bianconi wrote:
> > > > On Fri, Apr 12, 2019 at 02:27:16PM +0200, Lorenzo Bianconi wrote:
> > > > > Disable mt76u_tx_tasklet at the end of mt76u_stop_queues in order=
 to
> > > > > properly deallocate all pending skbs during suspend/resume phase
> > > >=20
> > > > On suspend/resume tx skb's are processed after tasklet_enable()
> > > > in resume callback. There is issue with device removal though
> > > > (during suspend or otherwise).
> > >=20
> > > Hi Stanislaw,
> > >=20
> > > I guess the right moment to deallocate the skbs is during suspend sin=
ce resume
> > > can happen in very far future
>=20
> Yes, it's better to free on suspend, but in practice does not really matt=
er since
> system is disabled till resume.
>=20
> > > > > Fixes: b40b15e1521f ("mt76: add usb support to mt76 layer")
> > > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > > ---
> > > > >  drivers/net/wireless/mediatek/mt76/usb.c | 4 ++--
> > > > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > > > >=20
> > > > > diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/n=
et/wireless/mediatek/mt76/usb.c
> > > > > index a3acc070063a..575207133775 100644
> > > > > --- a/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > +++ b/drivers/net/wireless/mediatek/mt76/usb.c
> > > > > @@ -842,10 +842,10 @@ static void mt76u_stop_tx(struct mt76_dev *=
dev)
> > > > >  void mt76u_stop_queues(struct mt76_dev *dev)
> > > > >  {
> > > > >  	tasklet_disable(&dev->usb.rx_tasklet);
> > > > > -	tasklet_disable(&dev->usb.tx_tasklet);
> > > > > -
> > > > >  	mt76u_stop_rx(dev);
> > > > > +
> > > > >  	mt76u_stop_tx(dev);
> > > > > +	tasklet_disable(&dev->usb.tx_tasklet);
> > > >=20
> > > > If tasklet is scheduled and we disable it and never enable, we end =
up
> > > > with infinite loop in tasklet_action_common(). This patch make the
> > > > problem less reproducible since tasklet_disable() is moved after
> > > > usb_kill_urb() -> tasklet_schedule(), but it is still possible.
> > >=20
> > > I can see the point here. Maybe we can just run tasklet_kill instead =
of
> > > tasklet_disable here (at least for tx one)
>=20
> I think you have right as tasklet_kill() will wait for scheduled tasklet .
> Originally in my patch (see below) I used wait_event as I thought
> tasklet_kill() may prevent scheduled tasklet to be executed (hence cause
> leak) but that seems to be not true.

I agree with rx side (good catch!!), but on tx one I guess usb_kill_urb()
is already waiting for tx pending so we just need to use tasklet_kill
at the end of mt76u_stop_queues, in this way we will free pending skbs duri=
ng
suspend

Regards,
Lorenzo

>=20
> > I think it is enough even for rx side since usb_kill_urb() will wait th=
e end of
> > mt76u_complete_rx() and tasklet_kill() will wait for the completion of
> > mt76u_rx_tasklet(). We will need to remove tasklet_enable in resume rou=
tines.
>=20
> No, because rx urb's are resubmitted on mt76u_rx_tasklet(). I use usb_poi=
son_urb()
> to prevent that in my patch.
>=20
> Stanislaw
>=20
> commit 088b1209302e17cda688c9b562e18970c92823ac
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Thu Apr 4 13:37:43 2019 +0200
>=20
>     mt76usb: fix tx/rx stop
>    =20
>     Disabling tasklets on stopping rx/tx is wrong. If blocked tasklet
>     is scheduled and we remove device we get 100% cpu usage:
>    =20
>       PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ =
COMMAND
>         9 root      20   0       0      0      0 R  93.8   0.0   1:47.19 =
ksoftirqd/0
>    =20
>     by using memory after free and eventually crash:
>    =20
>     [ 2068.591964] RIP: 0010:tasklet_action_common.isra.17+0x66/0x100
>     [ 2068.591966] Code: 41 89 f5 eb 25 f0 48 0f ba 33 00 0f 83 b1 00 00 =
00 48 8b 7a 20 48 8b 42 18 e8 56 a3 b5 00 f0 80 23 fd 48 89 ea 48 85 ed 74 =
53 <48> 8b 2a 48 8d 5a 08 f0 48 0f ba 6a 08 01 72 0b 8b 42 10 85 c0 74
>     [ 2068.591968] RSP: 0018:ffff98758c34be58 EFLAGS: 00010206
>     [ 2068.591969] RAX: ffff98758e6966d0 RBX: ffff98756e69aef8 RCX: 00000=
00000000006
>     [ 2068.591970] RDX: 01060a053d060305 RSI: 0000000000000006 RDI: ffff9=
8758e6966d0
>     [ 2068.591971] RBP: 01060a053d060305 R08: 0000000000000000 R09: 00000=
000000203c0
>     [ 2068.591971] R10: 000003ff65b34f08 R11: 0000000000000001 R12: ffff9=
8758e6966d0
>     [ 2068.591972] R13: 0000000000000006 R14: 0000000000000040 R15: 00000=
00000000006
>     [ 2068.591974] FS:  0000000000000000(0000) GS:ffff98758e680000(0000) =
knlGS:0000000000000000
>     [ 2068.591975] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>     [ 2068.591975] CR2: 00002c5f73a6cc20 CR3: 00000002f920a001 CR4: 00000=
000003606e0
>     [ 2068.591977] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000=
00000000000
>     [ 2068.591978] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000=
00000000400
>     [ 2068.591978] Call Trace:
>     [ 2068.591985]  __do_softirq+0xe3/0x30a
>     [ 2068.591989]  ? sort_range+0x20/0x20
>     [ 2068.591990]  run_ksoftirqd+0x26/0x40
>     [ 2068.591992]  smpboot_thread_fn+0xc5/0x160
>     [ 2068.591995]  kthread+0x112/0x130
>     [ 2068.591997]  ? kthread_create_on_node+0x40/0x40
>     [ 2068.591998]  ret_from_fork+0x35/0x40
>     [ 2068.591999] Modules linked in: ccm arc4 fuse rfcomm cmac bnep sunr=
pc snd_hda_codec_hdmi snd_soc_skl snd_soc_core snd_soc_acpi_intel_match snd=
_hda_codec_realtek snd_soc_acpi snd_hda_codec_generic snd_soc_skl_ipc snd_s=
oc_sst_ipc snd_soc_sst_dsp snd_hda_ext_core iTCO_wdt snd_hda_intel intel_ra=
pl iTCO_vendor_support x86_pkg_temp_thermal intel_powerclamp btusb mei_wdt =
coretemp btrtl snd_hda_codec btbcm btintel intel_cstate snd_hwdep intel_unc=
ore uvcvideo snd_hda_core videobuf2_vmalloc videobuf2_memops intel_rapl_per=
f wmi_bmof videobuf2_v4l2 intel_wmi_thunderbolt snd_seq bluetooth joydev vi=
deobuf2_common snd_seq_device snd_pcm videodev media i2c_i801 snd_timer idm=
a64 ecdh_generic intel_lpss_pci intel_lpss mei_me mei ucsi_acpi typec_ucsi =
processor_thermal_device intel_soc_dts_iosf intel_pch_thermal typec thinkpa=
d_acpi wmi snd soundcore rfkill int3403_thermal int340x_thermal_zone int340=
0_thermal acpi_thermal_rel acpi_pad pcc_cpufreq uas usb_storage crc32c_inte=
l i915 i2c_algo_bit nvme serio_raw
>     [ 2068.592033]  drm_kms_helper e1000e nvme_core drm video ipv6 [last =
unloaded: cfg80211]
>    =20
>     Fortunate thing is that this not happen frequently, as scheduling
>     tasklet on blocked state is very exceptional, though might happen.
>    =20
>     Due to different RX/TX tasklet processing fix is different for those.
>     For TX just wait until queues are empty. For RX assure rx_tasklet
>     do fail to resubmit buffers by poisoning urb's and kill the tasklet.
>    =20
>     Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>=20
> diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/=
wireless/mediatek/mt76/mac80211.c
> index 15825e9a458f..7bf91566e212 100644

[...]

> @@ -830,20 +831,35 @@ static void mt76u_free_tx(struct mt76_dev *dev)
>  static void mt76u_stop_tx(struct mt76_dev *dev)
>  {
>  	struct mt76_queue *q;
> -	int i, j;
> +	int i, j, ret;
> =20
>  	for (i =3D 0; i < IEEE80211_NUM_ACS; i++) {
>  		q =3D dev->q_tx[i].q;
>  		for (j =3D 0; j < q->ndesc; j++)
>  			usb_kill_urb(q->entry[j].urb);
>  	}
> +
> +	ret =3D wait_event_timeout(dev->tx_wait, !mt76_has_tx_pending(dev), HZ/=
5);
> +	if (!ret)
> +		dev_err(dev->dev, "timed out waiting for pending tx\n");
>  }
> =20
> -void mt76u_stop_queues(struct mt76_dev *dev)
> +int mt76u_start_queues(struct mt76_dev *dev)

maybe mt76u_resume_rx_queue would be more clear

>  {
> -	tasklet_disable(&dev->usb.rx_tasklet);
> -	tasklet_disable(&dev->usb.tx_tasklet);
> +	struct mt76_queue *q =3D &dev->q_rx[MT_RXQ_MAIN];
> +	int i;
> +
> +	/* Nothing to do for TX */
> =20
> +	for (i =3D 0; i < q->ndesc; i++)
> +		usb_unpoison_urb(q->entry[i].urb);
> +
> +	return mt76u_submit_rx_buffers(dev);
> +}
> +EXPORT_SYMBOL_GPL(mt76u_start_queues);
> +
> +void mt76u_stop_queues(struct mt76_dev *dev)
> +{
>  	mt76u_stop_rx(dev);
>  	mt76u_stop_tx(dev);
>  }


--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXLG1rQAKCRA6cBh0uS2t
rMCJAQD7dSuEJ31qxNeVIgRhw2Uat0l9S1H1kQhtaF9z7pZ12wEAzdN115zIOgoU
VAYKBh2mj6UX9y2xrYVJClmpMk/x5g0=
=R5P/
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
