Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm24-vm7.bullet.mail.ird.yahoo.com ([212.82.109.198]:44200 "HELO
	nm24-vm7.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752582Ab2A2Uqz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jan 2012 15:46:55 -0500
Message-ID: <1327869629.89221.YahooMailClassic@web29503.mail.ird.yahoo.com> (sfid-20120129_214659_547682_0995EABF)
Date: Sun, 29 Jan 2012 20:40:29 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: rtl8187 behavior change/breakage with 3.2.1-3.fc16.x86_64<->3.2.2-1.fc16.x86_64
To: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	herton@mandriva.com.br
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This may be a fedora-specific problem - I noticed that just after booting into the new fedora kernel (3.2.2-1.fc16.x86_64), I am getting a strange message from the kernel:

rtl8187: Invalid hwaddr! Using randomly generated MAC address

And it is setting my rtl8187 to an alien mac address instead of the usual one I have. The previous (3.2.1-3.fc16.x86_64) works correctly, and as far as I go back through my /var/log/message, had never had this problem ever.

The relevant changelog in the fedora package is this, so this might be a compat-wireless 3.3-rc1-2 problem? I checked rhbz 784345 which looked unrelated, although it is realtek (another driver).

--------------

* Wed Jan 25 2012 Josh Boyer <jwboyer@redhat.com> - 3.2.2-1
- Linux 3.2.2
- Add patch to invalidate parent cache when fsync is called on a partition 
  (rhbz 783211)
- Test fix for realtek_async_autopm oops from Stanislaw Gruszka (rhbz 784345)

* Wed Jan 25 2012 John W. Linville <linville@redhat.com>
- modpost: add option to allow external modules to avoid taint
- Make integrated compat-wireless take advantage of the above

* Wed Jan 25 2012 Josh Boyer <jwboyer@redhat.com>
- Backport patch to fix oops in rds (rhbz 718790)

* Tue Jan 24 2012 John W. Linville <linville@redhat.com>
- Update compat-wireless snapshot to version 3.3-rc1-2

* Tue Jan 24 2012 Josh Boyer <jwboyer@redhat.com>
- Re-enable the ARCMSR module (rhbz 784287)
- Add back a set of patches that were erroneously dropped during the rebase
- Re-enable the LIRC_STAGING drivers (rhbz 784398)
--------------------------------
