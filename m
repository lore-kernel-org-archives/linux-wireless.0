Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39214 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab2IEQ5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 12:57:44 -0400
Date: Wed, 5 Sep 2012 11:57:35 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	stable <stable@vger.kernel.org>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	=?utf-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	Milan Bouchet-Valat <nalimilan@club-internet.fr>,
	Brad Figg <brad.figg@canonical.com>
Subject: Re: [PATCH 2/2] brcmsmac: rework of mac80211 .flush() callback
 operation
Message-ID: <20120905165735.GD302@thinkpad-t410> (sfid-20120905_185748_277627_DEEF409D)
References: <1346838562-4818-1-git-send-email-arend@broadcom.com>
 <1346838562-4818-3-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1346838562-4818-3-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 05, 2012 at 11:49:22AM +0200, Arend van Spriel wrote:
> This patch addresses a long standing issue of the driver with the
> mac80211 .flush() callback. Since implementing the .flush() callback
> a number of issues have been fixed, but a WARN_ON_ONCE() was still
> triggered because the flush takes too much time. The flush now
> makes use of a waitqueue and still has a timeout on which a warning
> is given.

Brad Figg and I have been testing this patch with a 3.5 kernel. With the
patch we're both still seeing the warning from brcms_ops_flush(), and
Brad has also seen the "No where to go" message in
brcms_c_prec_enq_head(). But the connection continues to work when this
happens, whereas previously we had to reconnect, so this is definitely
an improvement.

Seth

