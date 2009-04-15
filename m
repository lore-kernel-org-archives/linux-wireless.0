Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f208.google.com ([209.85.217.208]:33312 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649AbZDOPJS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 11:09:18 -0400
Received: by gxk4 with SMTP id 4so6807646gxk.13
        for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2009 08:09:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <49E5EC66.80408@tuffmail.co.uk>
References: <9b2b86520904150345r31851012jb6a231e02583038a@mail.gmail.com>
	 <9b2b86520904150358u81dd977g3378ef81d7748355@mail.gmail.com>
	 <20090415130232.GA21411@tuxdriver.com> <49E5EC66.80408@tuffmail.co.uk>
Date: Wed, 15 Apr 2009 11:09:16 -0400
Message-ID: <b6c5339f0904150809p308d8eedt83198f12a7887f7e@mail.gmail.com> (sfid-20090415_170939_085693_A295E835)
Subject: Re: [ath5k-devel] BUG in freq_reg_info_regd
From: Bob Copeland <bcopeland@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath5k-devel@lists.ath5k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 15, 2009 at 10:17 AM, Alan Jenkins
<alan-jenkins@tuffmail.co.uk> wrote:
>>> Um, also the new "ath" module taints the kernel

Christian Lamparter posted a patch for that yesterday.

> [ =A0 =A04.176459] ath: Country alpha2 being used: 00
> [ =A0 =A04.176556] ath: Regpair detected: 0x60
> [ =A0 =A04.176679] BUG: unable to handle kernel NULL pointer derefere=
nce at
> 00000004
> [ =A0 =A04.176874] IP: [<dffede2e>] freq_reg_info_regd+0x2a/0xf2 [cfg=
80211]
> [ =A0 =A04.177053] *pdpt =3D 0000000017451001 *pde =3D 00000000000000=
00
> [ =A0 =A04.177245] Oops: 0000 [#2]
> [ =A0 =A04.177376] last sysfs file: /sys/class/input/input5/modalias
> [ =A0 =A04.177477] Modules linked in: ath5k(+) snd_hwdep snd_pcm_oss
> snd_mixer_oss uhci_hcd ehci_hcd mac80211 i2c_i801 led_class ath(P)
> psmouse serio_raw snd_pcm i2c_core pcspkr cfg80211 atl2 intel_agp
> snd_timer snd_page_alloc usbcore agpgart eeepc_laptop video backlight
> output battery rfkill ac processor button evdev thermal fan ata_gener=
ic
> [ =A0 =A04.179388]
> [ =A0 =A04.179475] Pid: 1641, comm: modprobe Tainted: P =A0 =A0 =A0D
> (2.6.30-rc1-wleeepc #11) 701
> [ =A0 =A04.179615] EIP: 0060:[<dffede2e>] EFLAGS: 00010286 CPU: 0
> [ =A0 =A04.179732] EIP is at freq_reg_info_regd+0x2a/0xf2 [cfg80211]
> [ =A0 =A04.179834] EAX: 00000000 EBX: df200060 ECX: 00004e20 EDX: e00=
99524
> [ =A0 =A04.179938] ESI: 00000060 EDI: 0024cde0 EBP: de551d70 ESP: de5=
51d50
> [ =A0 =A04.180003] =A0DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
> [ =A0 =A04.180003] Process modprobe (pid: 1641, ti=3Dde550000 task=3D=
de833000
> task.ti=3Dde550000)

Hmm, null pointer is probably custom_regd since reg_rule comes from
the stack and wiphy should've been validated a lot earlier.

Mind posting the objdump -S net/wireless/reg.o ?

--=20
Bob Copeland %% www.bobcopeland.com
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
