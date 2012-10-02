Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from narfation.org ([79.140.41.39]:34859 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862Ab2JBPCe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Oct 2012 11:02:34 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	lindner_marek@yahoo.de
Subject: Re: [PATCHv2] ath9k_hw: Handle AR_INTR_SYNC_HOST1_FATAL on AR9003
Date: Tue, 02 Oct 2012 17:02:30 +0200
Message-ID: <7670031.sYFb4t8Iqn@bentobox> (sfid-20121002_170241_339974_6B18AF60)
In-Reply-To: <CAJ-VmomddCMRxx6Vh_i8AJsqYMUCyguUwFt_PQHpDY7-+Gs88A@mail.gmail.com>
References: <1348756862-8788-1-git-send-email-sven@narfation.org> <20121002133533.GA19403@pandem0nium> <CAJ-VmomddCMRxx6Vh_i8AJsqYMUCyguUwFt_PQHpDY7-+Gs88A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart16869054.HR4UOUtFXv"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart16869054.HR4UOUtFXv
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Tuesday 02 October 2012 07:06:03 Adrian Chadd wrote:
> Hm, there are still issues on Hornet?

Yes, we still have problems with hornet. The issue I am trying to "fix" with 
this patch is an interrupt storm on AR9330 devices with sta interface(s). 
Random devices crash after getting a stacktrace reporting __report_bad_irq. 
The crash either results in a reboot or hang of the device

[  952.950000] irq 2: nobody cared (try booting with the "irqpoll" option)
[  952.950000] Call Trace:
[  952.950000] [<8026ade8>] dump_stack+0x8/0x34
[  952.950000] [<800a75d0>] __report_bad_irq+0x44/0xf4
[  952.950000] [<800a78ec>] note_interrupt+0x200/0x2a4
[  952.950000] [<800a58c8>] handle_irq_event_percpu+0x19c/0x1e0
[  952.950000] [<800a86cc>] handle_percpu_irq+0x54/0x88
[  952.950000] [<800a501c>] generic_handle_irq+0x3c/0x4c
[  952.950000] [<80064748>] do_IRQ+0x1c/0x34
[  952.950000] [<80062d6c>] ret_from_irq+0x0/0x4
[  952.950000] [<8007673c>] tasklet_action+0xb8/0xd4
[  952.950000] [<80076c24>] __do_softirq+0xa0/0x154
[  952.950000] [<80076e30>] do_softirq+0x48/0x68
[  952.950000] [<80076f94>] local_bh_enable+0x94/0xb0
[  952.950000] [<83406d60>] cfg80211_scan_done+0x670/0x6d0 [cfg80211]
[  952.950000] 
[  952.950000] handlers:
[  952.950000] [<83564d48>] ath_isr
[  952.950000] Disabling IRQ #2

The test setup is using 30 AR9330 devices running OpenWRT 32727/33559. 32727 
is using compat-wireless-2012-04-17 (+ many OpenWRT patches) and 33559 is 
running compat-wireless-2012-09-07 (+many more patches from Felix). 1 device 
is running an open AP device (standard OpenWRT settings) and 29 devices are 
trying to connect. Random devices will now fail. To debug this problem, I used 
one devices with 8 vif devices and restarted the network script again and 
again to force the recreation of the vif and reconnect.

The stack trace doesn't seem to be very helpful. Therefore, I checked ath_isr 
and noticed that the interrupts right before the device crash get the status 0 
from ar9003_hw_get_isr. Digging a little but further also revealed that the 
interrupts in the interrupt storm also have async_cause 0 and sync_cause 0x20.

This sync cause 0x20 isn't handled anywhere and may be the cause of the 
hang/crash. At least this is the symptom which can be fixed without crashing 
the system.

I hope that helps to track down the problem.

Kind regards,
        Sven
--nextPart16869054.HR4UOUtFXv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQawIGAAoJEF2HCgfBJntGqqIQANbDchedUroWCI+Hgx1a+KEf
1LDzldlcajoY4WRalUwH7Lm+HkP6D5TralEa0E93S9Wo14H1PEyhUfErA5W5aTLQ
EOxZEPVgXoBuKfKZFcXk7AYi/BZxZuc4p71T7bGrvWcL5Rq3qKfapzGht4gkYJyE
HWzJ1mLGIZZkCp9J8fPBf+4nmhgxWLDzK/qdzfvcetQgHEPFov/uISQVRPxQoBf2
chEx5v9l3P/ZGa9eFmCoWYzo8zVOzI8KhdfaOUrmhZfWh96dkFVCrLJfXTog306q
Au9eU4k2LUg+IsaJynWcxWaId0QnrXdSmJ/8JkmlDLX1UF69qPAtOpbbkEG1TSf9
Jbo84zZzrCR5Szs7oHDIXcSqh1eHXcAaFD0gnRHTQg3IpDHdVVETbdxWQWZkfV6J
9M6zzNMcE01ayjNunZaUzl4/91G9/n6Kb7YYQBc5pjRBmMo+tWdOCCLiJ29IlkCa
Wcxp78XueQDbrKkCdBt+6WQpq4sfT84dtqCLRAm9wCpq6FrnWq42cDuakCd4QaEQ
H4A2847fayTdrOWTKNB4XdDqGXW0tAFxOkAHhA6jsvwHArCBWF6EduSC1GMPPXbz
UDgeGJAlq8uLw6feJH/xqd2RKmEaMJvsGI1vvpI11kzwlaKFYLeVFknZYBQ1O8Ao
jfvpVVnd9Anlz0mASket
=qgbi
-----END PGP SIGNATURE-----

--nextPart16869054.HR4UOUtFXv--

