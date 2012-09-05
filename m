Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:39397 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab2IERd3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Sep 2012 13:33:29 -0400
Message-ID: <50478CE9.6040103@canonical.com> (sfid-20120905_193333_767238_C36A8F6B)
Date: Wed, 05 Sep 2012 10:33:29 -0700
From: Brad Figg <brad.figg@canonical.com>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	stable <stable@vger.kernel.org>,
	Jonathan Nieder <jrnieder@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	=?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>,
	Milan Bouchet-Valat <nalimilan@club-internet.fr>
Subject: Re: [PATCH 2/2] brcmsmac: rework of mac80211 .flush() callback operation
References: <1346838562-4818-1-git-send-email-arend@broadcom.com> <1346838562-4818-3-git-send-email-arend@broadcom.com> <20120905165735.GD302@thinkpad-t410>
In-Reply-To: <20120905165735.GD302@thinkpad-t410>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/05/2012 09:57 AM, Seth Forshee wrote:
> On Wed, Sep 05, 2012 at 11:49:22AM +0200, Arend van Spriel wrote:
>> This patch addresses a long standing issue of the driver with the
>> mac80211 .flush() callback. Since implementing the .flush() callback
>> a number of issues have been fixed, but a WARN_ON_ONCE() was still
>> triggered because the flush takes too much time. The flush now
>> makes use of a waitqueue and still has a timeout on which a warning
>> is given.
> 
> Brad Figg and I have been testing this patch with a 3.5 kernel. With the
> patch we're both still seeing the warning from brcms_ops_flush(), and
> Brad has also seen the "No where to go" message in
> brcms_c_prec_enq_head(). But the connection continues to work when this
> happens, whereas previously we had to reconnect, so this is definitely
> an improvement.
> 
> Seth
> 

Arend,

Though the driver is definitely better, it is still struggling quite a
bit as can be seen in the iperf output found at:
    http://pastebin.ubuntu.com/1187578/

-- 
Brad Figg brad.figg@canonical.com http://www.canonical.com
